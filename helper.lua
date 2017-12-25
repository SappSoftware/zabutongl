roundTo = function(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  if num >= 0 then 
    return math.floor(num * mult + 0.5) / mult
  else 
    return math.ceil(num * mult - 0.5) / mult 
  end
end

deepCopy = function(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end