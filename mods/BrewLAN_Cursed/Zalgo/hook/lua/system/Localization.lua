do
    local oldLOC = LOC
    function LOC(s)
        local old = oldLOC(s)
        if type(old) == 'string' then

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

            old = string.gsub(old, '%l%l', fuck)
        end
        return old
    end
end
