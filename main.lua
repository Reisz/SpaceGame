local Player = require "Player"
local Enemy = require "Enemy"
local InstanceManager = require "InstanceManager"

local globals = require "globals"
local lk = love.keyboard

local player

function love.load()
  print("Love version: " .. love._version_major .. "." .. love._version_minor .. "." .. love._version_revision)
  love.graphics.setBackgroundColor(255, 255, 255)

  globals.world = love.physics.newWorld(0, 0, true)
  require "physics"(globals.world)

  player = Player(globals.world, 50, 50)
  InstanceManager.add(Enemy(globals.world, 650, 400))
end

function love.draw()
  InstanceManager:draw()
  player:draw()
end

function love.update(dt)
  globals.world:update(dt)
  InstanceManager.update(dt)
  player:update(dt)
end

local spaceConstant
if love._version_minor < 9 or
  (love._version_minor == 9 and love._version_revision <= 2) then
  spaceConstant = " "
else
  spaceConstant = "space"
end

local function updateVelocity(key)
  if key == "up" or key == "down" or key == "left" or key == "right" then
    player:setVelocity(
      (lk.isDown("left") and -1 or 0) + (lk.isDown("right") and 1 or 0),
      (lk.isDown("up"  ) and -1 or 0) + (lk.isDown("down" ) and 1 or 0)
    )
  end
end

function love.keypressed(key)
  updateVelocity(key)

  if key == spaceConstant then
    player:shoot()
  elseif key == "0" then
    print(#InstanceManager.instances)
  end
end


function love.keyreleased(key)
  updateVelocity(key)
end
