do
    if not rawget(_G, 'UncursedLOC') then
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

    local function TitleCase(word)
        return string.upper(string.sub(word, 1, 1))..string.lower(string.sub(word, 2))
    end

    CursedFunctions.TitleCaseLOC = function(old, fucked)
        if type(fucked) == 'string' then
            fucked = string.gsub(fucked, '[%%]?[%a\']+', TitleCase)
        end
        return fucked
    end
end
