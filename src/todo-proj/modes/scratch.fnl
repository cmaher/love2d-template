(class scratch-mode)

(fn scratch-mode.construct [self game]
  (extend self {: game}))


(fn scratch-mode.draw [self]
  (let [camera self.game.camera]
    (camera:attach)
    (camera:detach)))

(fn scratch-mode.update [self dt])

scratch-mode
