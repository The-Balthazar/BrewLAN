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

    CursedFunctions.ZalgoLOC = function(old, fucked)
        if type(fucked) == 'string' then

            local function zalgo()
                return loadstring(string.format([[return "\x%x\x%x"]], math.random(204,205), math.random(128, 175)))() --204--128-191 and 205--128-175 we have an incomplete set here, but it's easier this way.
            end

            local function fuck(s)
                for i = 1, math.random(1,10) do
                    s = zalgo()..s
                end
                for i = 1, math.random(1,10) do
                    s = s..zalgo()
                end
                return s
            end

            fucked = string.gsub(fucked, '%l%l', fuck)
        end
        return fucked
    end
end
