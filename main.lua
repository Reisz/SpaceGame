local Player = require "Player"
local Enemy = require "Enemy"
local BulletManager = require "BulletManager"
local Bullet = require "Bullet"

local world
local player
local enemy

function love.load()
  love.graphics.setBackgroundColor(255, 255, 255)
  
  world = love.physics.newWorld(0, 0, true)
  player = Player(world, 50, 50)
  enemy = Enemy(world, 650, 400)
  
  BulletManager.add(Bullet(world, 100, 100, 100, 0))
end

function love.draw()
  player:draw()
  enemy:draw()
  BulletManager:draw()
end

function love.update(dt)
  world:update(dt)
  BulletManager.update(dt)
  player:update(dt)
end

function love.keypressed(key)
  if key == "up" then
    player:setYVelocity(-1)
  elseif key == "down" then
    player:setYVelocity(1)
  elseif key == "left" then
    player:setXVelocity(-1)
  elseif key == "right" then
    player:setXVelocity(1)
    
  elseif key == " " then
    player:shoot(world)
    
  elseif key == "0" then
    print(#BulletManager.instances)
  end
end


function love.keyreleased(key)
  if key == "up" and not love.keyboard.isDown("down") then
    player:setYVelocity(0)
  elseif key == "down" and not love.keyboard.isDown("up") then
    player:setYVelocity(0)
  elseif key == "left" and not love.keyboard.isDown("right") then
    player:setXVelocity(0)
  elseif key == "right" and not love.keyboard.isDown("left") then
    player:setXVelocity(0)
  end
end