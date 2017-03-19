function VersionIsSC()
    return string.sub(GetVersion(),1,3) == '1.1' or string.sub(GetVersion(),1,3) == '1.0'
end

function VersionIsSteam()
    return GetVersion() == '1.6.6'
end

function VersionIsFAF()
    return string.sub(GetVersion(),1,3) == '1.5' and tonumber(string.sub(GetVersion(),5)) > 3603
end

function VersionIsRetail()
    return string.sub(GetVersion(),1,3) == '1.5' and tonumber(string.sub(GetVersion(),5)) <= 3603
end

function GetVersionName()
    if VersionIsSC() then
        return 'SC'
    elseif VersionIsSteam() or VersionIsRetail() then
        return 'FA'
    elseif VersionIsFAF() then
        return 'FAF'
    else
        return false
    end
end

Buff = {}

if not VersionIsSC() then --If not original Steam SupCom
    Buff = import('/lua/sim/Buff.lua')
else
    Buff.ApplyBuff = function()
    end
end
