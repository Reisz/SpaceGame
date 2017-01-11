local class = require "middleclass"

local lg, lp = love.graphics, love.physics
local br = 3

local Bullet = class("Bullet")

function Bullet:initialize(world, cat, x, y, dx, dy)
  self.body = lp.newBody(world, x, y, "dynamic")
  self.shape = lp.newCircleShape(br)
  self.fixture = lp.newFixture(self.body, self.shape)

  self.fixture:setFilterData(cat, cat, 0)
  self.fixture:setUserData(self)

  self.body:setLinearVelocity(dx, dy)
  self.damage = 10
end

function Bullet.update() end

function Bullet:draw()
  lg.setColor(0,255,127)
  lg.circle("fill", self.body:getX(), self.body:getY(), br)
end

function Bullet:beginContact(other)
  if type(other) == "table" and type(other.damage) == "function" then
    other:damage(self.damage)
    self.fixture:setUserData(nil)
  end
end

return Bullet
