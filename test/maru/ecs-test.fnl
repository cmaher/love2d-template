(requires lu :luaunit
          lume :lume
          ecs :maru.ecs)

(local suite {:name :maru.ecs-test})

(fn suite.test-query []
  (var sys-ents nil)
  (let [world (ecs.world)
        marker (ecs.component 0)
        any-comp-1 (ecs.component {})
        any-comp-2 (ecs.component {})
        all-comp (ecs.component {})
        none-comp (ecs.component {})
        query (ecs.query [:all [all-comp]
                          :any [any-comp-1 any-comp-2]
                          :none [none-comp]])
        ;; when this system is called, it will set the sys-ents var to the entities it will process
        ;; so we can check to make sure the proper entities are being queried
        system (ecs.system :process 1 query (fn [self]
                                              (set sys-ents (tolist (self:result)))))

        entity-ids (fn [ents] (->> ents
                                   (map #(: $ :get marker))
                                   (map #(. $ :value))
                                   (tolist)
                                   (#(lume.sort $ lt))))

        ;; in query
        e1 (world:entity (marker 1)
                         (all-comp)
                         (any-comp-1))
        ;;  in query
        e2 (world:entity (marker 2)
                         (all-comp)
                         (any-comp-2))
        ;;  not in query
        e3 (world:entity (marker 3)
                         (all-comp)
                         (any-comp-1)
                         (none-comp))
        ;;  not in query
        e4 (world:entity (marker 4)
                         (any-comp-1))

        _ (world:add-system system)
        _ (world:update :process 1)]
    (lu.assertEquals (entity-ids [e1 e2]) (entity-ids sys-ents))))

suite
