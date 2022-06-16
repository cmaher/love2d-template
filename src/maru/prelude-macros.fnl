;; Fennel compiler plugin
;; When called from the uncompiled code, root is _SCOPE.parent.
;; When called from the compiler, root is _SCOPE.parent.parent
(eval-compiler
  (let [root (if _SCOPE.parent.parent
                 _SCOPE.parent.parent
                 _SCOPE.parent)]
    (set root.macros.class
         (fn [name]
           `(local ,name
                   (let [cls# {}
                         new# (fn [...]
                                (let [inst# {}]
                                  (setmetatable inst# cls#)
                                  (when inst#.construct
                                    (inst#:construct ...))
                                  inst#))]
                     (set cls#.__index cls#)
                     (set cls#.new new#)
                     cls#))))

    ;; locals and requires are basically duplicated because
    ;; I haven't figured out how to use macros from macros in this setup
    (set root.macros.locals
         (fn [...]
           (let [args [...]
                 bindings {}
                 bound {}]
             (each [i v (ipairs args)]
               (when (= 0 (% i 2))
                 (let [k (. args (- i 1))]
                   (tset bindings (tostring k) k)
                   (tset bound (tostring k) v))))
             `(local ,bindings ,bound))))

    (set root.macros.requires
         (fn [...]
           (let [args [...]
                 bindings {}
                 bound {}]
             (each [i v (ipairs args)]
               (when (= 0 (% i 2))
                 (let [k (. args (- i 1))]
                   (tset bindings (tostring k) k)
                   (tset bound (tostring k) `(require ,v)))))
             `(local ,bindings ,bound))))))

{:name "maru/prelude-macros"
 :versions ["1.1.0"]}
