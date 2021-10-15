do

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
        if sub(word, 1, 1) == '%' or sub(word, -2) == 'ay' then
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

    local oldLOC = LOC
    function LOC(s)
        local old = oldLOC(s)
        if type(old) == 'string' then
            old = string.gsub(old, '[%%]?[%a\']+', piggy)
        end
        return old
    end

end
