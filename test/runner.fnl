(requires lfs :love.filesystem
          evt :love.event
          lu :luaunit
          lume :lume
          fun :fun)

(class love-runner)

;; Each directory init exports a list of suites
;; A suite has exported test functions and a name
;; The name of the suite is prepended to the name of the test
;; a comma-separated list of values can be passed to --run to run only matching tests
(local suites
       [(unpack (require :test.maru))])

(fn love-runner.construct [self args]
  (let [tests []
        args-sep-pos (find args "--")
        test-args (if args-sep-pos
                      (tolist (fun.drop_n args-sep-pos))
                      nil)]
    (each [_ suite (ipairs suites)]
      (each [k v (pairs suite)]
        (when (= "function" (type v))
          (let [name (.. suite.name "." k)]
            (table.insert tests [name v])))))
    ;; luaunit runner will parse the cli arguments, and we don't want that
    (lume.clear arg)
    (set self.tests tests)
    (set self.test-args test-args)
    (set self.lu-runner (lu.LuaUnit:new))
    (set self.is-repl (find args "--repl"))))

(fn love-runner.run [self]
  (self.lu-runner:setOutputType :tap)
  (self.lu-runner:runSuiteByInstances self.tests self.test-args)
  (when (not self.is-repl)
    (evt.quit (if (= 0 self.lu-runner.notSuccessCount)
                  0
                  1))))

(fn love-runner.init [self]
  (self:run))

love-runner
