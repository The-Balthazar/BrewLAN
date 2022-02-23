
rawset(string, 'match', function(input, exp, init)
    local match
    string.gsub(input:sub(init or 1), exp, function(...) match = arg end, 1)
    return unpack(match)
end)

rawset(string, 'gmatch', function(input, exp)
    local matches = {}
    string.gsub(input, exp, function(...) table.insert(matches, arg) end)
    local i = 0
    return function()
        i=i+1
        if matches[i] then
            return unpack(matches[i])
        end
    end
end)
