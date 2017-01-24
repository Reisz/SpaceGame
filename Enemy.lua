local class = require "middleclass"

local InstanceManager = require "InstanceManager"
local Bullet = require "Bullet"

local globals = require "globals"

local lg, lp = love.graphics, love.physics
local ew, eh = 40, 15
local erx, ery = ew / 2, eh / 2
local hpad = 5
local hw = ew - 2 * hpad
local healthDuration, healthDecay = 2, 20
local healthFade = .5

local Enemy = class("Enemy")

Enemy.static.shape = lp.newPolygonShape(  erx,ery,  -eh,ery,  -erx,-ery,  eh,-ery  )
Enemy.static.shootRate = 1.5
Enemy.static.bulletSpeed = 120
Enemy.static.maxHealth = 30
Enemy.static.speed = 35

function Enemy:initialize(world, x, y)
  self.body = lp.newBody(world, x, y, "kinematic")
  self.fixture = lp.newFixture(self.body, self.class.shape)

  self.fixture:setFilterData(2,2,0)
  self.fixture:setUserData(self)

  self.body:setLinearVelocity(-self.class.speed,0)

  self.health = self.class.maxHealth
  self.displayHealth = self.class.maxHealth
  self.shootTimer, self.healthTimer = 0, 0
end

function Enemy:update(dt)
  local h, dh, ht = self.health, self.displayHealth, self.healthTimer

  if h == dh and ht > 0 then
    -- start fading out as soon as the animation finished
    self.healthTimer = math.max(0, ht - dt)
  elseif h ~= dh then
    -- animate the health bar decay
    self.displayHealth = math.max(h, dh - healthDecay * dt)
  end

  self.shootTimer = self.shootTimer + dt
  if h ~= 0 and self.shootTimer >= self.class.shootRate then
    InstanceManager.add(Bullet(globals.world, 1, self.body:getX() - erx, self.body:getY() - ery, -self.class.bulletSpeed, 0))
    self.shootTimer = 0
  end
end

function Enemy:damage(amount)
  local h = math.max(0, self.health - amount)
  if h == 0 then
    self.fixture:setUserData(nil)
  end
  self.health = h
  self.healthTimer = healthDuration
end

function Enemy:draw()
  lg.setColor(255,127,0, self.health == 0 and 128 or 255)
  lg.polygon("fill", self.body:getWorldPoints(self.class.shape:getPoints()))

  local ht = self.healthTimer
  if ht > 0 then
    local x1, x2, x3, x4, y, a
    local h, dh, mw = self.health, self.displayHealth, hw / self.class.maxHealth
    y = self.body:getY() - ery - hpad
    x1 = self.body:getX() - erx + hpad
    x4 = x1 + hw
    x2 = x1 + (mw * h)
    x3 = x1 + (mw * dh)
    a = ht < healthFade and 255 * ht / healthFade or 255

    lg.push()
    lg.setLineWidth(2)
    lg.setColor(32, 255, 32, a)
    lg.line(x1, y, x2, y)
    lg.setColor(255, 255, 32, a)
    lg.line(x2, y, x3, y)
    lg.setColor(255, 32, 32, a)
    lg.line(x3, y, x4, y)
    lg.pop()
  end
end

return Enemy
