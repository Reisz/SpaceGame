local class = require "middleclass"

local InstanceManager = require "InstanceManager"
local Bullet = require "Bullet"

local globals = require "globals"

local lg, lp = love.graphics, love.physics
local ew, eh = 40, 15
local erx, ery = ew / 2, eh / 2

local Enemy = class("Enemy")

Enemy.static.shape = lp.newPolygonShape(  erx,ery,  -eh,ery,  -erx,-ery,  eh,-ery  )
Enemy.static.shootRate = 1.5
Enemy.static.bulletSpeed = 120
Enemy.static.maxHealth = 100
Enemy.static.speed = 35

function Enemy:initialize(world, x, y)
  self.body = lp.newBody(world, x, y, "kinematic")
  self.fixture = lp.newFixture(self.body, self.class.shape)

  self.fixture:setFilterData(2,2,0)
  self.fixture:setUserData(self)
  
  self.body:setLinearVelocity(-self.class.speed,0)

  self.health = self.class.maxHealth
  self.shootTimer = 0
end

function Enemy:update(dt)
  self.shootTimer = self.shootTimer + dt
  if self.shootTimer >= self.class.shootRate then
    InstanceManager.add(Bullet(globals.world, 1, self.body:getX() - erx, self.body:getY() - ery, -self.class.bulletSpeed, 0))
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
  lg.polygon("fill", self.body:getWorldPoints(self.class.shape:getPoints()))
end

return Enemy
