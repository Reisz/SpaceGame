local class = require "middleclass"

local Enemy = require "Enemy"

local ew, eh = 40, 15
local erx, ery = ew / 2, eh / 2

local FastEnemy = class("FastEnemy", Enemy)

FastEnemy.static.shape = love.physics.newPolygonShape(  -erx,0,  erx,-ery,  0,0,  erx,ery  )
FastEnemy.static.speed = 50

return FastEnemy