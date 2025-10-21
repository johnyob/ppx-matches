; -------- Test: `matches.ml` --------; The executable under test
(executable
 (name matches)
 (modules matches)
 (preprocess (pps ppx_matches)))

; Run the PPX on the `.ml` file
(rule
 (targets matches.actual)
 (deps
  (:pp pp.exe)
  (:input matches.ml))
 (action
  ; expect the process to succeed, captured in target
  (run ./%{pp} --impl %{input} -o %{targets})))

; Compare the post-processed output to the .expected file
(rule
 (alias runtest)
 (package ppx_matches)
 (action
  (diff matches.expected matches.actual)))
; Ensure that the post-processed executable runs correctly
(rule
 (alias runtest)
 (package ppx_matches)
 (action
  (run ./matches.exe)))

; -------- Test: `matches_inline.ml` --------; The executable under test
(executable
 (name matches_inline)
 (modules matches_inline)
 (preprocess (pps ppx_matches)))

; Run the PPX on the `.ml` file
(rule
 (targets matches_inline.actual)
 (deps
  (:pp pp.exe)
  (:input matches_inline.ml))
 (action
  ; expect the process to succeed, captured in target
  (run ./%{pp} --impl %{input} -o %{targets})))

; Compare the post-processed output to the .expected file
(rule
 (alias runtest)
 (package ppx_matches)
 (action
  (diff matches_inline.expected matches_inline.actual)))
; Ensure that the post-processed executable runs correctly
(rule
 (alias runtest)
 (package ppx_matches)
 (action
  (run ./matches_inline.exe)))


