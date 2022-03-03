
-- Lua 5.0 implementation of the Lua 5.1 function string.match
-- Returns a regex match
-- optional param init defines where to start searching. Can be negative to search from the end.
rawset(string, 'match', function(input, exp, init)
    local match
    string.gsub(input:sub(init or 1), exp, function(...) match = arg end, 1)
    return unpack(match)
end)

-- Lua 5.0 implementation of the Lua 5.1 function string.gmatch
-- Iterator function, returns each sequential match from a string
rawset(string, 'gmatch', string.gfind--[[function(input, exp)
    local matches = {}
    string.gsub(input, exp, function(...) table.insert(matches, arg) end)
    local i=0
    return function()
        i=i+1
        if matches[i] then
            return unpack(matches[i])
        end
    end
end]])
