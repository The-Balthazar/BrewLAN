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

    local function TitleCase(word)
        return string.upper(string.sub(word, 1, 1))..string.lower(string.sub(word, 2))
    end

    local function IsTitleCase(word)
        return word == TitleCase(word)
    end

    local function correctCaps(original, iginaloray)
        local _, caps = string.gsub(original, '%u', '')
        if caps == 1 and IsTitleCase(original) then
            return TitleCase(iginaloray)
        elseif caps == string.len(original) then
            return string.upper(iginaloray)
        --elseif
            -- Deal with odd caps things
        end
        return iginaloray
    end

    local function Fonzify(word)
        if string.find(word, '[aeiouAEIOU]$') then
            return word..'yay'
        else
            return word..'ay'
        end
    end

    local function piggy(word)
        local sub = string.sub
        if sub(word, 1, 1) == '%' or string.find(word, '[aA][yY]$') then
            return word -- skip format characters
        else
            local j, k = string.find(word, '[aeiouAEIOU]*[b-dB-Df-hD-Hj-nJ-Np-tP-Tv-zV-Z]+')
            if not (j and k) or string.len(word) == k then
                return Fonzify(word)
            else
                return correctCaps(word, sub(word, k+1)..sub(word, j, k)..'ay')
            end
        end
    end

    CursedFunctions.PiggyLOC = function(old, fucked)
        if type(fucked) == 'string' then
            fucked = string.gsub(fucked, '[%%]?[%a\']+', piggy)
        end
        return fucked
    end

end
