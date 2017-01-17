--- Handle keyboard input in Löve2d.
-- keysetup
--   action    map<id, list<input> >
--   axis      map<id, list<{float,input}> >
--
-- keyconfig   map<id, list<input> >
--
-- id          string
--   unique between action and axis
--
-- input
--   KeyConstant
--   ":"  .. Scancode
--   "g:" .. GamepadButton
--   "a:" .. GamepadAxis
--   "j:" .. buttonId
--   "x:" .. axisId
--   "h:" .. hatId .. ":" .. JoystickHat

local input = {}

local byteColon = string.byte(":")
local byteMapping = {
  [string.byte("g")] = "gamepadButton",
  [string.byte("a")] = "gamepadAxis"
}

local function processMapping(v)
  local a, b = string.byte(v, 1, 2)
  if a == byteColon then
    return input.mappings.scanCode, string.sub(v, 2)
  elseif b == byteColon then
    local m = byteMapping[a]
    if m then return input.mappings[m], string.sub(v, 3) end
    
    --[[m = byteMappingNum[a]
    if m then
      return input.mappings[m], tonumber(string.sub(v, 3))
    elseif a == byteHat then
      local id, val = string.match(v, "([^:]):(.*))", 3)
      id = tonumber(id)
      
      local hat = input.mappings.joystickHat[id]
      if not hat then
        hat = {}; input.mappings.joystickHat[id] = hat
      end
      
      return hat, val
    end]]
  else
    return input.mappings.keyConstant, inputValue
  end
end

function input.parseSetup(setup, config)
  assert(type(setup) == "table", "Invalid argument 'setup' expected type table.")
  config = config or {}
  assert(type(config) == "table", "Invalid argument 'config' expected type table or nil.")
  
  local action, axis = setup.action or {}, setup.axis or {}
  assert(type(action) == "table", "Keysetup.action must be a table or undeclared.")
  assert(type(axis) == "table", "Keysetup.axis must be a table or undeclared.")
  
  input.mappings = {
    keyConstant = {},
    scanCode = {},
    gamepadButton = {},
    gamepadAxis = {},
    joystick = {}
  }
  input.handlers = {}
  
  for i,v in pairs(action) do
    local keys = config[i] or v
    local entry = {
      keys = keys,
      listeners = {}
    }
    
    for _,key in ipairs(keys) do
      local tbl, index = processMapping(v)
      assert(tbl, "Invalid mapping: '" .. v .. "'.")
      tbl[index] = entry
    end
    input.handlers[i] = entry
  end
end

return function()
  return input
end