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
        LOG("Terrain type: " .. (GetTerrainType( pos[1], pos[3] ).Style or "nil") .. " POS: " .. pos[1] .. ", " .. pos[2] .. ", " .. pos[3])
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
        --LOG globals to a single recursion so the game doesn't crash
        for k, v in _G do
            LOG(k,"   ",v)
            if type(v) == "table" then
                for k2, v2 in v do
                    LOG("   ",k2, "   ", v2)
                end
            end
        end
        ]]--
        --LOG(repr(_G)) --how to kill the universe in 13 characters.
    end,

    OnDamage = function(self, instigator, amount, vector, damageType)
        self:DoOnDamagedCallbacks(instigator)
        self:DoTakeDamage(instigator, amount, vector, damageType)
    end,

    DoTakeDamage = function(self, instigator, amount, vector, damageType)
        local unitdetails = ("\"" .. instigator:GetBlueprint().BlueprintId .. "\", \"" .. LOC(instigator:GetBlueprint().General.UnitName or instigator:GetBlueprint().Description ) .. "\", " .. tostring(amount) .. ", ")
        if not self.DPScalcs[instigator:GetEntityId()] then
            self.DPScalcs[instigator:GetEntityId()] = {
                startTime = GetGameTimeSeconds(),
                totalDamageSustain = 0,
                totalDamageBurst = amount,
            }
            LOG(", \"Time\", \"Unit id\", \"Unit name\", \"Damage tick\", \"Estimated sustain DPS\", \"Current burst DPS\", \"Note\"")
            LOG(", 0, " .. unitdetails .. "\"N/A\", \"1.#INF\", \"First damage instance\"")
            --self:SetMesh(self:GetBlueprint().Display.MeshBlueprintFrozen, true)
        else
            local enttable = self.DPScalcs[instigator:GetEntityId()]
            enttable.totalDamageSustain = enttable.totalDamageSustain + amount
            enttable.totalDamageBurst = enttable.totalDamageBurst + amount

            local duration = GetGameTimeSeconds() - enttable.startTime
            local intro = (", " .. tostring(duration) .. ", " .. unitdetails)

            if enttable.Message ~= math.floor(enttable.totalDamageSustain / duration + 0.5) .. ", " .. math.floor(enttable.totalDamageBurst / duration + 0.5) then
                enttable.Message = math.floor(enttable.totalDamageSustain / duration + 0.5) .. ", " .. math.floor(enttable.totalDamageBurst / duration + 0.5)
                LOG(intro .. enttable.Message )
                if math.floor(enttable.totalDamageSustain / duration + 0.5) == math.floor(enttable.totalDamageBurst / duration + 0.5) then
                    if instagator.SetCustomName then
                        instigator:SetCustomName('DPS: ' .. math.floor(enttable.totalDamageSustain / duration + 0.5) )
                    end
                end
            else
                LOG(intro .. enttable.Message .. ", \"No rounded DPS change\"" )
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
