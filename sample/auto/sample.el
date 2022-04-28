(TeX-add-style-hook
 "sample"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "oneside" "a4paper")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "kotex"))
 :latex)

