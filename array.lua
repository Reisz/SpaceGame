local array = {}

function array.filter(tbl, filter)
  local len = #tbl
  local index, offset = 1, 0

  while index <= len do
    if filter(tbl[index]) then
      if offset > 0 then
        tbl[index - offset] = tbl[index]
        tbl[index] = nil
      end
    else
      offset = offset + 1
      tbl[index] = nil
    end

    index = index + 1
  end
end

return array