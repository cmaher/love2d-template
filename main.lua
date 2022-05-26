-- bootstrap the compiler
-- Use LuaRocks load path
local lfs = require("love.filesystem")
local requirePath = lfs.getRequirePath() ..
   ";.luarocks/share/lua/5.1/?.lua" ..
   ";.luarocks/share/lua/5.1/?/init.lua"
lfs.setRequirePath(requirePath)

lume = require("lume")
fennel = require("fennel")
js = (require "lib.js")

table.insert(package.loaders, fennel.make_searcher({correlate=true}))
fennel.path =
   lfs.getSource() .. "/?.fnl;" ..
   lfs.getSource() .. "/src/?.fnl;" ..
   lfs.getSource() .. "/src/?/init.fnl;" ..
   lfs.getSource() .. "/src/?/init.fnl;" ..
   lfs.getSource() .. "/lib/?.fnl;" ..
   lfs.getSource() .. "/lib/?/init.fnl;" ..
   fennel.path

debug_mode = true
pp = function(x) print(fennel.view(x)) end
db = function(x)
   if (debug_mode == true) then
      local debug_info = debug.getinfo(1)
      -- print debug.getinfo
      local currentline = debug_info.currentline
      -- local file = debug_info.source:match("^.+/(.+)$")
      local file = debug_info["short_src"] or ""
      local name = debug_info["namewhat"] or ""
      pp({"db", x})
   end
end


local make_love_searcher = function(env)
   return function(module_name)
      local path = module_name:gsub("%.", "/") .. ".fnl"
      if lfs.getInfo(path) then
         return function(...)
            local code = lfs.read(path)
            return fennel.eval(code, {env=env}, ...)
         end, path
      end
   end
end

table.insert(package.loaders, make_love_searcher(_G))
table.insert(fennel["macro-searchers"], make_love_searcher("_COMPILER"))

require("wrap")
