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
 (depends
  ocaml
  (dune
   (>= 3.6))
  ppxlib
  core))
