function VersionIsSC()
    return string.sub(GetVersion(),1,3) == '1.1' or string.sub(GetVersion(),1,3) == '1.0'
end

Buff = {}

if not VersionIsSC() then --If not original Steam SupCom
    Buff = import('/lua/sim/Buff.lua')
else
    Buff.ApplyBuff = function()
    end
end