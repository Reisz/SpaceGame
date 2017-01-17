local class = require "middleclass"

local array = require "array"

local margin = 50
local ww, wh = love.graphics.getWidth(), love.graphics.getHeight()

local InstanceManager = class("InstanceManager")

local instances = {}
local queue = {}
InstanceManager.static.instances = instances

function InstanceManager.static.update(dt)
  array.join(instances, queue)
  array.clear(queue)
  array.filter(instances, function(v)
    v:update(dt)

    local tlx, tly, brx, bry = v.fixture:getBoundingBox()
    if
      type(v.fixture:getUserData()) == "nil" or
      tlx > ww + margin or tly > wh + margin or
      brx < 0  - margin or bry < 0  - margin
    then
      v.fixture:destroy()
      v.body:destroy()
      return nil
    end

    return v
  end)
end

function InstanceManager.static.draw()
  for _,v in ipairs(instances) do
    v:draw()
  end
end

function InstanceManager.static.add(...)
  assert(select(1, ...) ~= InstanceManager, "Make sure that you are using 'InstanceManager.add' instead of 'InstanceManager:add'")
  array.append(queue, ...)
end

return InstanceManager
