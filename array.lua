--- Functions for the array part of tables.

local array = {}

--- Filter an array using a function.
-- Traverse the array while removing certain elements depending on the value
-- that was returned by the passed filter funciton. This function will make sure
-- to read each index exactly once.
--
-- To execute a function on each element without changing the structure of the
-- array, @{\\array.forEach} will present a better alternative.
-- @tparam table tbl table to be filtered
-- @tparam function callback filter function.
--   Return true to leave in, return false to sort out.
-- @return tbl
function array.filter(tbl, callback)
  local offset = 0

  for index = 1, #tbl do
    local value = tbl[index]
    if not callback(value, index, tbl) then
      tbl[index] = nil
      offset = offset + 1
    elseif offset > 0 then
      tbl[index] = nil
      tbl[index - offset] = value
    end
  end

  return tbl
end

--- Execute a function on each element of an array.
-- This funtion will execute a function on each element of an array, without
-- modifiying its content. This is the fastest of the traversal functions.
-- @tparam table tbl table to be traversed
-- @tparam function callback function to apply.
--   Return values are ignored.
-- @return tbl
function array.forEach(tbl, callback)
  for index = 1, #tbl do
    callback(tbl[index], index, tbl)
  end

  return tbl
end

--- Apply a function to each element of an array.
-- @tparam table tbl table to be traversed
-- @tparam function callback callback function to apply.
-- @return tbl
function array.map(tbl, callback)
  for index = 1, #tbl do
    tbl[index] = callback(tbl[index], index, tbl)
  end

  return tbl
end

function array.reduce(tbl, callback, init)
  print(tbl, callback, init)
end

function array.reduceRight(tbl, callback, init)
  print(tbl, callback, init)
end

--- Join multiple arrays into a single big array.
-- This will add all the elements of second table onwards to the end of the
-- first array.
--
-- As this function will mutate its first argument, a call like
-- `@{array.join}(a, a, a)` will not behave as expected. If the first argument
-- appears again anywhere but in the second argument, consider calling this
-- function as `a = @{array.join}({}, a, a, a)`.
-- @tparam table tbl table to be written to
-- @tparam[opt] table ... tables to append to the end of tbl
-- @return tbl
function array.join(tbl, ...)
  local last = #tbl

  for i = 1, select('#', ...) do
    local other = select(i, ...)
    local length = #other

    for index = 1, length do
      tbl[last + index] = other[index]
    end

    last = last + length
  end

  return tbl
end

return array
