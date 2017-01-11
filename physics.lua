local function callback(name, a, b, ...)
  local ua, ub = a:getUserData(), b:getUserData()
  if type(ua) == "table" and type(ua[name]) == "function" then
    ua[name](ua, ub, ...)
  end
  if type(ub) == "table" and type(ub[name]) == "function" then
    ub[name](ub, ua, ...)
  end
end

local function beginContact(...) callback("beginContact", ...) end
local function endContact(...) callback("endContact", ...) end
local function preSolve(...) callback("preSolve", ...) end
local function postSolve(...) callback("postSolve", ...) end

return function(world)
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end
