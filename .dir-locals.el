((fennel-mode . ((eval . (font-lock-add-keywords
                          'fennel-mode
                          `((,(rx word-start
                                  (group (or "class"
                                             "locals"
                                             "requires"

                                             "all"
                                             "any"
                                             "filter"
                                             "foreach"
                                             "head"
                                             "map"
                                             "nth"
                                             "nthrest"
                                             "reduce"
                                             "range"
                                             "tail"
                                             "to-list"
                                             "to-map"
                                             "extend"
                                             "keys"
                                             "push"
                                             "unpack"))
                                  word-end)
                             1 'font-lock-keyword-face)))))))
