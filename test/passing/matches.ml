(* function form without when *)
let is_some = [%matches? Some _]
let () = assert (is_some (Some 1))
let () = assert (not (is_some None))
let is_none = [%matches? None]
let () = assert (is_none None)
let () = assert (not (is_none (Some 1)))

(* function form with when *)
let is_positive_int = [%matches? x when x > 0]
let () = assert (is_positive_int 5)
let () = assert (not (is_positive_int (-1)))
let is_even_some = [%matches? Some x when x mod 2 = 0]
let () = assert (is_even_some (Some 4))
let () = assert (not (is_even_some (Some 3)))
let () = assert (not (is_even_some None))

(* function form with complex patterns *)
let is_positive_tuple = [%matches? x, y when x > 0 && y > 0]
let () = assert (is_positive_tuple (1, 2))
let () = assert (not (is_positive_tuple (-1, 2)))
let () = assert (not (is_positive_tuple (1, -2)))

(* function form with constants *)
let is_answer = [%matches? 42]
let () = assert (is_answer 42)
let () = assert (not (is_answer 41))
let is_hello = [%matches? "hello"]
let () = assert (is_hello "hello")
let () = assert (not (is_hello "world"))

(* function form with or patterns *)
let is_small_digit = [%matches? 0 | 1 | 2 | 3]
let () = assert (is_small_digit 2)
let () = assert (not (is_small_digit 5))

(* function form with arrays *)
let is_pair_array = [%matches? [| _; _ |]]
let () = assert (is_pair_array [| 1; 2 |])
let () = assert (not (is_pair_array [| 1; 2; 3 |]))

(* function form with records *)
type point =
  { x : int
  ; y : int
  }

let is_origin = [%matches? { x = 0; y = 0 }]
let () = assert (is_origin { x = 0; y = 0 })
let () = assert (not (is_origin { x = 1; y = 0 }))
let is_on_x_axis = [%matches? { x = _; y = 0 }]
let () = assert (is_on_x_axis { x = 5; y = 0 })
let () = assert (not (is_on_x_axis { x = 5; y = 1 }))

(* function form with nested patterns *)
let is_nested_some_pair = [%matches? Some (_, 42)]
let () = assert (is_nested_some_pair (Some (1, 42)))
let () = assert (not (is_nested_some_pair (Some (1, 43))))
let () = assert (not (is_nested_some_pair None))

(* function form with lazy patterns *)
let is_lazy = [%matches? lazy _]
let lazy_val = lazy 123
let () = assert (is_lazy lazy_val)

(* function form with ranges *)
let is_letter = [%matches? 'a' .. 'z' | 'A' .. 'Z']
let () = assert (is_letter 'f')
let () = assert (is_letter 'Z')
let () = assert (not (is_letter '1'))

(* function form with constraint patterns *)
let is_int = [%matches? (_ : int)]
let () = assert (is_int 42)
