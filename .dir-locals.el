;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((fennel-mode .
   ((eval . (setq-local inferior-lisp-program
                        (concat "love " (locate-dominating-file default-directory dir-locals-file) "/build"))))))
