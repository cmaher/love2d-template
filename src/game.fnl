(requires hump-camera :hump.camera
          gamestate :hump.gamestate
          asset-cache :maru.asset-cache
          scratch-mode :todo-proj.modes.scratch
          gamedefs :todo-proj.gamedefs)

(fn new-game []
  (let [game {:camera (hump-camera.new)
              :assets (asset-cache.new)
              :gamedefs (gamedefs.new)
              :units {}
              :modes {}}]
    (love.graphics.setDefaultFilter :nearest :nearest 0)
    (set game.modes.scratch (scratch-mode.new game))
    (game.gamedefs:load game)
    ;; Set the game as a global for debugging access
    (set love.game game)
    game))

(fn love.load [args]
  (when (find args :--repl)
    (do (let [stdio (require :stdio)]
          (stdio:start))))
  (if (find args :--test)
      (let [test-runner (require :test.runner)
            runner (test-runner.new args)]
        (set love.tests runner)
        (gamestate.switch runner))
      (let [game (new-game)]
        (gamestate.switch game.modes.scratch))))

(fn love.update [dt]
  (let [mode (gamestate.current)]
    (when mode.update
      (mode:update dt))))

(fn love.draw []
  (let [mode (gamestate.current)]
    (when mode.draw
      (mode:draw))))
