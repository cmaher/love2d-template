;; This package adapts nidorx/ecs-lua to a more fennel-appropriate interface
(local ecs (require :ecs))

(fn world-entity [self ...]
  (let [entity (self:Entity ...)]
    (extend entity {:get entity.Get
                    :set entity.Set
                    :unset entity.Unset
                    :alive? (fn [self] self.isAlive)})))

(fn world-exec [self ...]
  (: (self:Exec ...) :Iterator))

(fn world [...]
  (let [world (ecs.World ...)]
    (extend world {:add-system world.AddSystem
                   :destroy world.Destroy
                   :entity world-entity
                   :exec world-exec
                   :remove world.Remove
                   :update world.Update})))

(fn component [...]
  (let [component (ecs.Component ...)]
    (extend component {:new component.New
                       :is component.Is})))

(fn system-result [self ...]
  (: (self:Result ...) :Iterator))

(fn system [...]
  (let [system (ecs.System ...)]
    (extend system {:result system-result})))

(fn query [[op val & rest]]
  "Build queries given a list, e.g.
    (ecs.query [:all [some-component some-filter]
                :any [other-component]
                :none [bad-component]])"
  (let [op->q (fn [op] (.. (string.upper (head op))
                           (string.sub op 2)))
        qb (: ecs.Query (op->q op) (unpack val))
        loop (fn loop [qb rest]
               (match rest
                 [o v & r]
                 (loop (: qb (op->q o) (unpack v)) r)
                 ;; when we're out of ops, build the query
                 _ (qb:Build)))]
    (loop qb rest)))

{: world
 : component
 : system
 :filter ecs.Query.Filter
 :query query}
