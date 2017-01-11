local class = require "middleclass"

local InstanceManager = require "InstanceManager"
local Bullet = require "Bullet"

local globals = require "globals"

local lg, lp = love.graphics, love.physics
local ew, eh = 40, 15
local erx, ery = ew / 2, eh / 2
local shootRate = 1.5
local bulletSpeed = 120

local Enemy = class("Enemy")

function Enemy:initialize(world, x, y)
  self.body = lp.newBody(world, x, y, "kinematic")
  self.shape = lp.newPolygonShape(  erx,ery,  -eh,ery,  -erx,-ery,  eh,-ery  )
  self.fixture = lp.newFixture(self.body, self.shape)

  self.fixture:setFilterData(2,2,0)
  self.fixture:setUserData(self)
  
  self.body:setLinearVelocity(-35,0)

  self.health = 100
  self.shootTimer = 0
end

function Enemy:update(dt)
  self.shootTimer = self.shootTimer + dt
  if self.shootTimer >= shootRate then
    InstanceManager.add(Bullet(globals.world, 1, self.body:getX() - erx, self.body:getY() - ery, -bulletSpeed, 0))
    self.shootTimer = 0
  end
end

function Enemy:damage(amount)
  self.health = self.health - amount
  if self.health <= 0 then
    self.fixture:setUserData(nil)
  end
end

function Enemy:draw()
  lg.setColor(255,127,0)
  lg.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

return Enemy
