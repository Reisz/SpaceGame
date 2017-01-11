local class = require "middleclass"

local BulletManager = require "BulletManager"
local Bullet = require "Bullet"

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
  self.dx, self.dy = 0, 0
end

function Player:draw()
  lg.setColor(0,127,255)
  lg.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

function clamp(min, x, max)
  return x < min and min or (x > max and max or x)
end

function Player:update(dt)
  self.body:setPosition(
    clamp(prx, self.body:getX() + (self.dx * dt), ww - prx),
    clamp(pry, self.body:getY() + (self.dy * dt), wh - pry)
  )
end

function Player:setXVelocity(dx)
  self.dx = speed * dx
end

function Player:setYVelocity(dy)
  self.dy = speed * dy
end

function Player:shoot(world)
  BulletManager.add(Bullet(world, self.body:getX() + prx, self.body:getY() + pry, bulletSpeed, 0))
end

return Player