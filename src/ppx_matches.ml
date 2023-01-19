open! Core
open! Ppxlib
open! Ast_builder.Default

let ppx_namespace = "ppx_matches"
let pp_quoted pp ppf = Format.fprintf ppf "`%a`" pp
let raise_errorf ~loc fmt = Location.raise_errorf ~loc ("%s: " ^^ fmt) ppx_namespace

module Matches = struct
  let is_binding_var var = not (String.is_prefix ~prefix:"_" var.txt)

  let rec is_binding_pattern pat =
    match pat.ppat_desc with
    | Ppat_any -> false
    | Ppat_var var -> is_binding_var var
    | Ppat_alias (pat, var) -> is_binding_pattern pat || is_binding_var var
    | Ppat_array pats | Ppat_tuple pats -> List.exists pats ~f:is_binding_pattern
    | Ppat_interval _ | Ppat_constant _ -> false
    | Ppat_construct (_constr_ident, arg_pat) ->
      Option.exists arg_pat ~f:(fun (_type_vars, pat) -> is_binding_pattern pat)
    | Ppat_variant (_variant, arg_pat) -> Option.exists arg_pat ~f:is_binding_pattern
    | Ppat_record (fields, _) ->
      List.exists fields ~f:(fun (_field, pat) -> is_binding_pattern pat)
    | Ppat_or (pat1, pat2) -> is_binding_pattern pat1 || is_binding_pattern pat2
    | Ppat_constraint (pat, _type) -> is_binding_pattern pat
    | Ppat_type _type_ident -> true
    | Ppat_lazy pat -> is_binding_pattern pat
    | Ppat_unpack mod_ident -> Option.is_some mod_ident.txt
    | Ppat_exception pat -> is_binding_pattern pat
    | Ppat_extension _ ->
      (* Overapproximation. User's ppx extension *may* bind patterns once extended *)
      true
    | Ppat_open (_mod_ident, pat) -> is_binding_pattern pat
  ;;

  let assert_pat_is_not_binding ~loc pat =
    if is_binding_pattern pat
    then
      raise_errorf
        ~loc
        "invalid [%%matches? ...] payload. Pattern %a cannot bind any variables."
        (pp_quoted Pprintast.pattern)
        pat
  ;;

  let expand_inline ~loc matchee pat ?when_ () =
    match when_ with
    | None ->
      assert_pat_is_not_binding ~loc pat;
      [%expr
        match [%e matchee] with
        | [%p pat] -> true
        | _ -> false]
    | Some when_ ->
      [%expr
        match [%e matchee] with
        | [%p pat] when [%e when_] -> true
        | _ -> false]
  ;;

  let expand ~loc pat ?when_ () =
    match when_ with
    | None ->
      assert_pat_is_not_binding ~loc pat;
      [%expr
        function
        | [%p pat] -> true
        | _ -> false]
    | Some when_ ->
      [%expr
        function
        | [%p pat] when [%e when_] -> true
        | _ -> false]
  ;;
end

let impl : structure -> structure =
  (object
     inherit Ast_traverse.map as super

     method! expression expr =
       let loc = expr.pexp_loc in
       match expr with
       | [%expr [%matches? [%p? pat]] [%e? matchee]] ->
         Matches.expand_inline ~loc matchee pat ()
       | [%expr [%matches? [%p? pat] when [%e? when_]] [%e? matchee]] ->
         Matches.expand_inline ~loc matchee pat ~when_ ()
       | [%expr [%matches? [%p? pat]]] -> Matches.expand ~loc pat ()
       | [%expr [%matches? [%p? pat] when [%e? when_]]] ->
         Matches.expand ~loc pat ~when_ ()
       | expr -> super#expression expr
  end)
    #structure
;;

let () =
  Reserved_namespaces.reserve ppx_namespace;
  Driver.register_transformation ~impl ppx_namespace
;;
