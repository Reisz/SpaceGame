local InstanceManager = require "InstanceManager"

local enemies = {
  require "Enemy", require "FastEnemy"
}

local EnemySpawner = {}

local world
local currentTimer, delay = 0, 2

local function spawnEnemy()
  InstanceManager.add(enemies[math.random(#enemies)](
      world, 850, math.random(100,700)
    ))
end

function EnemySpawner.update(dt)
  currentTimer = currentTimer + dt
  while currentTimer > delay do
    currentTimer = currentTimer - delay
    spawnEnemy()
  end
end

return function(w)
  world = w
  return EnemySpawner
end