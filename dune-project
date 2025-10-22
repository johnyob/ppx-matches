(lang dune 3.6)

(generate_opam_files true)

(name ppx_matches)

(source
 (github johnyob/ppx-matches))

(license MIT)

(authors "Alistair O'Brien")

(maintainers "ajob410@gmail.com")

(package
 (name ppx_matches)
 (synopsis "A syntax extension for Rust's `matches!` in OCaml 🐪")
 (depends
  (ocaml 
    (>= 4.14.0))
  (dune
   (>= 3.6))
  ppxlib
  core
  (core_unix :with-test)))
