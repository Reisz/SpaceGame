local class = require "middleclass"

local lg, lp = love.graphics, love.physics
local ew, eh = 40, 15
local erx, ery = ew / 2, eh / 2

local Enemy = class("Enemy")

function Enemy:initialize(world, x, y)
  self.body = lp.newBody(world, x, y, "kinematic")
  self.shape = lp.newPolygonShape(  -erx,ery,  eh,ery,  erx,-ery,  -eh,-ery  )
  self.fixture = lp.newFixture(self.body, self.shape)
  
  self.body:setLinearVelocity(-35,0)
end

function Enemy:draw()
  lg.setColor(255,127,0)
  lg.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

return Enemy