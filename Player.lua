local class = require "middleclass"

local InstanceManager = require "InstanceManager"
local Bullet = require "Bullet"

local globals = require "globals"

local lg, lp = love.graphics, love.physics
local ww, wh = lg.getWidth(), lg.getHeight()
local pw, ph = 40, 20
local prx, pry = pw / 2, ph / 2
local speed, bulletSpeed = 100, 150

local Player = class("Player")

function Player:initialize(world, x, y)
  self.body = lp.newBody(world, x, y, "kinematic")
  self.shape = lp.newPolygonShape(  -prx,pry,  prx,pry,  0,-pry,  -prx,-pry  )
  self.fixture = lp.newFixture(self.body, self.shape)

  self.fixture:setFilterData(1,1,0)
  self.fixture:setUserData(self)

  self.dx, self.dy = 0, 0
end

function Player:draw()
  lg.setColor(0,127,255)
  lg.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

local function clamp(min, x, max)
  return x < min and min or (x > max and max or x)
end

function Player:update(dt)
  self.body:setPosition(
    clamp(prx, self.body:getX() + (self.dx * dt), ww - prx),
    clamp(pry, self.body:getY() + (self.dy * dt), wh - pry)
  )
end

function Player:setVelocity(dx, dy)
  self.dx, self.dy = speed * dx, speed * dy
end

function Player:damage(amount)
  print(self, amount)
end

function Player:shoot()
  InstanceManager.add(Bullet(globals.world, 2, self.body:getX() + prx, self.body:getY() + pry, bulletSpeed, 0))
end

return Player
