local class = require "middleclass"

local lg, lp = love.graphics, love.physics
local br = 3

local Bullet = class("Bullet")

function Bullet:initialize(world, x, y, dx, dy)
  self.body = lp.newBody(world, x, y, "kinematic")
  self.shape = lp.newCircleShape(br)
  self.fixture = lp.newFixture(self.body, self.shape)
  
  self.body:setLinearVelocity(dx, dy)
end

function Bullet:draw()
  lg.setColor(0,255,127)
  lg.circle("fill", self.body:getX(), self.body:getY(), br)
end

return Bullet