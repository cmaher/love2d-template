(local ffi (require :ffi))
(local vector (require :brinevector))

(local transform {})
(set transform.__index transform)

(local transform-c
       (ffi.typeof "struct {brinevector pos, scale; double rot;}"))

(fn transform.new [pos rot scale]
  (let [pos (or pos (vector 0 0))
        rot (or rot 0)
        scale (or scale (vector 1 1))]
    (transform-c pos scale rot)))


(ffi.metatype transform-c transform)

transform
