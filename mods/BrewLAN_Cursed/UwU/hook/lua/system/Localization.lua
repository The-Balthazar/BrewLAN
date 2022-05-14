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

    local function uwu(uw)
        local u = string.sub(uw, 1, 1)
        return u..'w'..u
    end

    local owolibrary = {
        No = 'Noooo x.x',
        Yes = 'yus!',
        Not = 'Nawt',
    }

    local function owoget(word)
        return owolibrary[word] or word
    end

    CursedFunctions.UwULOC = function(old, fucked)
        if type(fucked) == 'string' then
            fucked = string.gsub(fucked, '[u][lrw]+', uwu)
            fucked = string.gsub(fucked, '[o][eoulrw]+', uwu)
            fucked = string.gsub(fucked, '([^%%]?)[lr](%a)', '%1w%2')
            fucked = string.gsub(fucked, '[LR](%a)', 'W%1')
            fucked = string.gsub(fucked, '[%%]?[%a\']+', owoget)

            if old == string.upper(old) and not string.find(fucked, '┻━┻') then
                fucked = fucked .. "\n(ノ°Д°）ノ︵ ┻━┻"
            --elseif string.sub(old, -1) == '?' then
            --    fucked = fucked .. ' 👉👈'
            end
        end
        return fucked
    end
end
