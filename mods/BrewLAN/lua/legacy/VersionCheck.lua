local ver = string.sub(GetVersion(),1,3)
local ver2 = tonumber(string.sub(GetVersion(),5))

function VersionIsSC()
    return ver == '1.1' or ver == '1.0'
end

function VersionIsSteam()
    return GetVersion() == '1.6.6'
end

function VersionIsFAF()
    return ver == '1.5' and ver2 > 3603
end

function VersionIsRetail()
    return ver == '1.5' and ver2 <= 3603
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
    Buff.RemoveBuff = function()
    end
end
