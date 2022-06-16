(local sti (require "sti"))

(class asset-cache)
(fn asset-cache.construct [self]
  (extend self {:images {}
                :maps {}}))

(fn asset-cache.image [self path settings]
  (match self.images
    {path asset} asset
    _ (let [asset (love.graphics.newImage path settings)]
        (tset self.images path asset)
        asset)))

(fn asset-cache.tiled [self path plugins ox oy]
  (match self.maps
    {path asset} asset
    _ (let [asset (sti path plugins ox oy)]
        (tset self.maps path asset)
        asset)))

asset-cache
