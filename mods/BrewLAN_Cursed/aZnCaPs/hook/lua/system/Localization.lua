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

    local LYBlen = 0
    local LittleYellowBook = {}

    local function aZn(word)
        local sub = string.sub
        if sub(word, 1, 1) == '%' then
            return word -- skip format characters
        else
            local function rancap(a)
                return math.random(0,1) == 0 and string.upper(a) or string.lower(a)
            end
            return string.gsub(word, '%a', rancap)
        end
    end

    CursedFunctions.aZnLOC = function(old, fucked)
        if not LittleYellowBook[old] and type(fucked) == 'string' then
            LittleYellowBook[old] = string.gsub(fucked, '[%%]?[%a\']+', aZn)
            LYBlen = LYBlen + 1
            WARN("Little Yellow Book length "..LYBlen)
        end
        return LittleYellowBook[old]
    end
end
