let () = print_endline "Hello World!"
let () = assert ([%matches? Some x when x > 2] (Some 4))

let () =
  let chr = 'a' in
  print_endline "test";
  if [%matches? 'a' | 'b' | 'c'] chr then print_endline "Woo!" else print_endline "Bad :D"
;;
