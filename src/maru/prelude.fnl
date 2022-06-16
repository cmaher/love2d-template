(requires fun :fun
          lume :lume)

(global all fun.all)
(global any fun.any)
(global filter fun.filter)
(global foreach fun.each)
(global head fun.head)
(global map fun.map)
(global reduce fun.reduce)
(global range fun.range)
(global tail fun.tail)
(global tolist fun.totable)
(global tomap fun.tomap)

(global find lume.find)
(global extend lume.extend)
(global keys lume.keys)
(global push lume.push)

(global le fun.operator.le)
(global lt fun.operator.lt)
(global eq fun.operator.eq)
(global ne fun.operator.ne)
(global gt fun.operator.gt)
(global ge fun.operator.ge)

(global noop (fn []))

(if table.unpack
    (global unpack table.unpack)
    (set table.unpack unpack))

(set string.split lume.split)

(global debug-mode false)
(global pp noop)
(global dbg noop)

(fn pp-debug [it]
  (print (fennel.view it)))

(fn dbg-debug [msg]
  (let [{:short_src file
         :currentline line} (debug.getinfo 1)]
    (pp {: file
         : line
         : msg})))

(when (find arg "--debug")
  (do
    (set _G.debug-mode true)
    (set _G.pp pp-debug)
    (set _G.dbg dbg-debug)))

nil
