local SShieldStructureUnit = import('/lua/seraphimunits.lua').SShieldStructureUnit
local LDNo = 6
local sdNo = 12
local LDBP = __blueprints.ssb4401_large
local sdBP = __blueprints.ssb4401_small

SSB4401 = Class(SShieldStructureUnit) {

    ShieldEffects = {
        '/effects/emitters/seraphim_shield_generator_t3_01_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t3_02_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t3_03_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t3_04_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t3_05_emit.bp',
    },

    OnStopBeingBuilt = function(self,builder,layer)
        SShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy - LDNo * LDBP.Economy.MaintenanceConsumptionPerSecondEnergy - sdNo * sdBP.Economy.MaintenanceConsumptionPerSecondEnergy)
    end,

    OnShieldEnabled = function(self)
        self:CleanUp()
        SShieldStructureUnit.OnShieldEnabled(self)
        local army = self:GetArmy()
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, army, v ) )
        end
        local drones, radius
        for setI, set in {{LDNo, 22, 'ssb4401_large'},{sdNo, 38, 'ssb4401_small'}} do
            drones = set[1]
            radius = set[2]
            local patrolnodes = 18
            local pos = self:GetPosition()
            for i = 1, drones do
                local dude = CreateUnitHPR(
                    set[3],
                    self:GetArmy(),
                    pos[1], pos[2], pos[3],
                    0, 0, 0
                )
                dude.Parent = self
                table.insert(self.ShieldDroneBag, dude)
                dude.MyShield:SetHealth(self, dude.MyShield:GetHealth() * self.MyShield:GetHealth() / self:GetBlueprint().Defense.Shield.ShieldMaxHealth)
                IssueMove({dude}, {pos[1] + (radius * (math.sin((math.pi * 2/drones)*i))), pos[2], pos[3] + (radius * (math.cos((math.pi * 2/drones)*i)))})
                for i2 = 1, patrolnodes do
                    local xpos = pos[1] + (radius * (math.sin((math.pi * 2/drones)*(i) + ((math.pi * 2/patrolnodes)*i2))))
                    local zpos = pos[3] + (radius * (math.cos((math.pi * 2/drones)*(i) + ((math.pi * 2/patrolnodes)*i2))))
                    local ypos = pos[2]--GetTerrainHeight(xpos, zpos) -- Terrain height checks actually make deviations worse.
                    IssuePatrol({dude}, {xpos, ypos, zpos})
                end
            end
        end
        self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy - LDNo * LDBP.Economy.MaintenanceConsumptionPerSecondEnergy - sdNo * sdBP.Economy.MaintenanceConsumptionPerSecondEnergy)
    end,

    OnShieldDisabled = function(self)
        local maxShieldhealth = LDNo * LDBP.Defense.Shield.ShieldMaxHealth + sdNo * sdBP.Defense.Shield.ShieldMaxHealth + self:GetBlueprint().Defense.Shield.ShieldMaxHealth
        local Shieldhealth = 0
        for i, drone in self.ShieldDroneBag do
            Shieldhealth = Shieldhealth + drone.MyShield:GetHealth()
        end
        Shieldhealth = Shieldhealth + self.MyShield:GetHealth()
        self.MyShield:SetHealth(self, self:GetBlueprint().Defense.Shield.ShieldMaxHealth * (Shieldhealth / maxShieldhealth))
        self:CleanUp()
        SShieldStructureUnit.OnShieldDisabled(self)
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self:CleanUp(true)
        SShieldStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    OnDestroyed = function(self)
        self:CleanUp(true)
        SShieldStructureUnit.OnDestroyed(self)
    end,

    CleanUp = function(self, deathcleanup)
        for i, v in {'ShieldEffectsBag', 'ShieldDroneBag'} do
            if self[v] then
                for k, j in self[v] do
                    --if v == 'ShieldDroneBag' then
                    --end
                    j:Destroy()
                end
                if not deathcleanup then
                    self[v] = {}
                end
            end
            if not self[v] and not deathcleanup then
                self[v] = {}
            end
        end
    end,
}

TypeClass = SSB4401
