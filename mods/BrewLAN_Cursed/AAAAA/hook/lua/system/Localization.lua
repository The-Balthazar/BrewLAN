do
    local oldLOC = LOC
    function LOC(s)
        local old = oldLOC(s)
        if type(old) == 'string' then
            --This is to dance around breaking things like %s for string.format
            old = string.gsub(old, '%u', 'A')
            old = string.gsub(old, 'A%l', 'Aa')
            old = string.gsub(old, '%l%l', string.rep('a', math.random(1,3)) )
            old = string.gsub(old, '%l[b-z]', string.rep('a', math.random(1,3)) )
        end
        return old
    end
end
