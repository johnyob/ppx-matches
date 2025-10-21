(* Error: patterns that bind variables are not allowed in inline form without when clause *)
let value = Some 42
let () = assert ([%matches? Some x] value)
