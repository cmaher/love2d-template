(love.graphics.setNewFont 30)

(local (major minor revision) (love.getVersion))

{:draw (fn draw [self message]
         (local (w h _flags) (love.window.getMode))
         (love.graphics.printf
          (: "Love Version: %s.%s.%s"
             :format  major minor revision) 0 10 w :center)
         (love.graphics.printf "This window should close when you press a key"
                               0 (- (/ h 2) 15) w :center))
 :update (fn update [self dt set-mode])
 :keypressed (fn keypressed [self key set-mode]
               (love.event.quit))}
