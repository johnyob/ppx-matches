(* constant patterns *)
let () = assert ([%matches? 42] 42)
let () = assert (not ([%matches? 42] 43))
let () = assert ([%matches? "hello"] "hello")
let () = assert (not ([%matches? "hello"] "world"))

(* variant patterns *)
let () = assert ([%matches? None] None)
let () = assert ([%matches? Some _] (Some 1))
let () = assert (not ([%matches? Some _] None))

(* tuple patterns *)
let () = assert ([%matches? _, 2] (1, 2))
let () = assert (not ([%matches? _, 2] (1, 3)))

(* array patterns *)
let () = assert ([%matches? [| 1; _ |]] [| 1; 2 |])
let () = assert (not ([%matches? [| 1; _ |]] [| 2; 1 |]))

(* record patterns *)
type point =
  { x : int
  ; y : int
  }

let p = { x = 1; y = 2 }
let () = assert ([%matches? { x = 1; y = _ }] p)
let () = assert (not ([%matches? { x = 2; y = _ }] p))

(* or patterns *)
let () = assert ([%matches? 1 | 2 | 3] 2)
let () = assert (not ([%matches? 1 | 2 | 3] 4))

(* when clauses with various conditions *)
let bar = Some 4
let () = assert ([%matches? Some x when x > 2] bar)
let () = assert ([%matches? x when x > 0] 5)
let () = assert (not ([%matches? x when x > 0] (-1)))
let () = assert ([%matches? Some x when x mod 2 = 0] (Some 4))
let () = assert (not ([%matches? Some x when x mod 2 = 0] (Some 3)))

(* range pattern *)
let foo = 'f'
let () = assert ([%matches? 'A' .. 'Z' | 'a' .. 'z'] foo)

(* complex nested patterns *)
let nested = Some (1, [| 2; 3 |])
let () = assert ([%matches? Some (1, [| _; 3 |])] nested)
let () = assert (not ([%matches? Some (2, [| _; 3 |])] nested))

(* lazy patterns *)
let lazy_val = lazy 42
let () = assert ([%matches? lazy _] lazy_val)

(* constraint patterns *)
let () = assert ([%matches? (_ : int)] 42)
