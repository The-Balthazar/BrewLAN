do
    if not pcall(function() return UncursedLOC end) then
        UncursedLOC = LOC
        CursedFunctions = {}

        function LOC(s)
            local old = UncursedLOC(s)
            local fucked = old
            for i, v in CursedFunctions do
                fucked = v(old, fucked)
            end
            return fucked
        end
    end

    CursedFunctions.AaaaaLOC = function(old, fucked)
        if type(fucked) == 'string' then
            --This is to dance around breaking things like %s for string.format
            fucked = string.gsub(fucked, '%u', 'A')
            fucked = string.gsub(fucked, 'A%l', 'Aa')
            fucked = string.gsub(fucked, '%l%l', string.rep('a', math.random(1,3)) )
            fucked = string.gsub(fucked, '%l[b-z]', string.rep('a', math.random(1,3)) )
        end
        return fucked
    end
end
