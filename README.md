# 🔥 ppx-matches
> A syntax extension for Rust's `matches!` in OCaml 🐪

[![OCaml-CI Build Status](https://img.shields.io/endpoint?url=https://ci.ocamllabs.io/badge/johnyob/ppx-matches/main&logo=ocaml)](https://ci.ocamllabs.io/github/johnyob/ppx-matches)

## Install 

This library has not yet been released to `opam`. To install it, first 

```
opam pin add --yes https://github.com/johnyob/ppx-matches.git
opam install ppx_matches
```

Users of [`dune`](https://github.com/ocaml/dune/) can then use this PPX on their
libraries and executables by adding the appropriate stanza field:

```lisp
(library
 ...
 (preprocess (pps ppx_matches)))
```

## Syntax

In short:

- `[%matches? pat [when cond]]` expands to
  ```
  function
  | pat [when cond] -> true
  | _ -> false
  ```

- `[%matches? pat [when cond]] matchee` expands to the inlined version:
  ```
  match matchee with
  | pat [when cond] -> true
  | _ -> false
  ```

