; -------- Test: `binding_pat.ml` --------

; Run the PPX on the `.ml` file
(rule
 (targets binding_pat.actual)
 (deps
  (:pp pp.exe)
  (:input binding_pat.ml))
 (action
  ; expect the process to fail, capturing stderr
  (with-stderr-to
   %{targets}
   (bash "! ./%{pp} -no-color --impl %{input}"))))

; Compare the post-processed output to the .expected file
(rule
 (alias runtest)
 (package ppx_matches)
 (action
  (diff binding_pat.expected binding_pat.actual)))


