(lang dune 2.0)
(name travesty)
(formatting (enabled_for dune ocaml))
(implicit_transitive_deps false)

(generate_opam_files true)
(source (github MattWindsor91/travesty))
(license MIT)
(authors "Matt Windsor <m.windsor@imperial.ac.uk>")
(maintainers "Matt Windsor <m.windsor@imperial.ac.uk>")
(homepage "https://MattWindsor91.github.io/travesty/")
(documentation "https://MattWindsor91.github.io/travesty/")

(package
 (name travesty)
 (synopsis "Monadically traversable containers")
 (description "'Travesty' is a library for defining containers with monadic traversals,
inspired by Haskell's Traversable typeclass.  It sits on top of Jane Street's
Base library and ecosystem.")
 (depends
  (ocaml (and (>= 4.07) (< 4.11)))
  (dune (and (>= 2.0) (< 3.0)))
  (ppx_jane (and (>= v0.12.0) (< v0.15.0)))
  (base (and (>= v0.12.0) (< v0.15.0)))))
