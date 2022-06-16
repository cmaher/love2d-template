-- bootstrap the compiler
-- Use LuaRocks load path
local lfs = require("love.filesystem")

local requirePath = lfs.getRequirePath() ..
  ";.luarocks/share/lua/5.1/?.lua" ..
  ";.luarocks/share/lua/5.1/?/init.lua" ..
  ";lib/?.lua" ..
  ";lib/?/init.lua"
lfs.setRequirePath(requirePath)

local lume = require("lume")

-- Fennel view is helpful in release logs
local fennel = require("fennel")
-- required by stdio
_G.fennel = fennel

-- Skip fennel files in the release build
if lume.find(arg, "--fennel") then
  local plugins = {lfs.getSource() .. "/src/maru/prelude-macros.fnl"}
  table.insert(package.loaders, fennel.makeSearcher({
                  correlate=true,
                  plugins=plugins}))
  fennel.path =
    lfs.getSource() .. "/?.fnl;" ..
    lfs.getSource() .. "/?/init.fnl;" ..
    lfs.getSource() .. "/src/?.fnl;" ..
    lfs.getSource() .. "/src/?/init.fnl;" ..
    lfs.getSource() .. "/lib/?.fnl;" ..
    lfs.getSource() .. "/lib/?/init.fnl;" ..
    fennel.path

  fennel["macro-path"] =
    lfs.getSource() .. "/?.fnl;" ..
    lfs.getSource() .. "/?/init-macros.fnl;" ..
    lfs.getSource() .. "/src/macros/?.fnl;" ..
    lfs.getSource() .. "/src/macros/?/init-macros.fnl;" ..
    lfs.getSource() .. "/lib/?.fnl;" ..
    lfs.getSource() .. "/lib/?/init-macros.fnl;" ..
    fennel["macro-path"]
end
