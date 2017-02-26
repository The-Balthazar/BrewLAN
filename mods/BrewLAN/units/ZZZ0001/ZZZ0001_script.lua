local AShieldStructureUnit = import('/lua/aeonunits.lua').AShieldStructureUnit
local function LOC(s)
    if string.sub(s, 1, 4)=='<LOC' then
        local i = string.find(s,">")
        if i then
            s = string.sub(s, i+1)
        end
    end
    return s
end

ZZZ0001 = Class(AShieldStructureUnit) {

    OnCreate = function(self)
        AShieldStructureUnit.OnCreate(self)
        local pos = self:GetPosition()
        LOG("Terrain type: " .. GetTerrainType( pos[1], pos[3] ).Style .. " POS: " .. pos[1] .. ", " .. pos[2] .. ", " .. pos[3])
        self.DPScalcs = {}
        self:SetCustomName('True Brick')
        --Get lag fraction
        --[[
            ForkThread(function()
                local time1, time2 = GetGameTimeSeconds(), GetSystemTimeSeconds()
                WaitSeconds(1)
                time1, time2 = GetGameTimeSeconds() - time1, GetSystemTimeSeconds() - time2
                LOG(time1 / time2)
            end)
        ]]--
        for k, v in _G do
            LOG(k,"   ",v)
            if type(v) == "table" then
                for k2, v2 in v do
                    LOG("   ",k2, "   ", v2)
                end
            end
        end
        --LOG(repr(_G)) --how to kill the universe in 13 characters.
    end,

    DoTakeDamage = function(self, instigator, amount, vector, damageType)
        if not self.DPScalcs[instigator:GetEntityId()] then
            self.DPScalcs[instigator:GetEntityId()] = {
                startTime = GetGameTimeSeconds(),
                totalDamageSustain = 0,
                totalDamageBurst = amount,
            }
            self:SetMesh(self:GetBlueprint().Display.MeshBlueprintFrozen, true)
        else
            local enttable = self.DPScalcs[instigator:GetEntityId()]
            enttable.totalDamageSustain = enttable.totalDamageSustain + amount
            enttable.totalDamageBurst = enttable.totalDamageBurst + amount

            local intro = (instigator:GetBlueprint().BlueprintId .. " - " .. LOC(instigator:GetBlueprint().General.UnitName or instigator:GetBlueprint().Description ) ) .. " DPS: "
            local duration = GetGameTimeSeconds() - enttable.startTime

            if enttable.Message != math.floor(enttable.totalDamageSustain / duration + 0.5) .. " - " .. math.floor(enttable.totalDamageBurst / duration + 0.5) then
                enttable.Message = math.floor(enttable.totalDamageSustain / duration + 0.5) .. " - " .. math.floor(enttable.totalDamageBurst / duration + 0.5)
                LOG(intro .. enttable.Message )
                if math.floor(enttable.totalDamageSustain / duration + 0.5) == math.floor(enttable.totalDamageBurst / duration + 0.5) then
                    instigator:SetCustomName('DPS: ' .. math.floor(enttable.totalDamageSustain / duration + 0.5) )
                end
            end
        end
        if IsUnit(instigator) then
            FloatingEntityText(instigator:GetEntityId(),string.rep(' ', math.random(0,5)) .. tostring(amount) .. string.rep(' ', math.random(0,5)))
        end
        if IsUnit(self) then
            FloatingEntityText(self:GetEntityId(),string.rep(' ', math.random(0,5)) .. tostring(amount) .. string.rep(' ', math.random(0,5)))
        end
        --AShieldStructureUnit.DoTakeDamage(self, instigator, amount, vector, damageType)
    end,
}

TypeClass = ZZZ0001
