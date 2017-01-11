local class = require "middleclass"

local array = require "array"

local margin = 1
local ww, wh = love.graphics.getWidth(), love.graphics.getHeight()

local BulletManager = class("BulletManager")

local instances = {}
BulletManager.static.instances = instances


local function bulletFilter(v)
  local tlx, tly, brx, bry = v.fixture:getBoundingBox()
  if
    tlx > ww + margin or tly > wh + margin or
    brx < 0  + margin or bry < 0  + margin
  then
    v.fixture:destroy()
    v.body:destroy()
    return false
  end
  
  return true
end
function BulletManager.static.update()
  array.filter(instances, bulletFilter)
end

function BulletManager.static.draw()
  for _,v in ipairs(instances) do
    v:draw()
  end
end

function BulletManager.static.add(...)
  local last = #instances + 1
  for i = 1, select("#", ...) do
    instances[last] = select(i, ...)
    last = last + 1
  end
end

return BulletManager