local SShieldStructureUnit = import('/lua/seraphimunits.lua').SShieldStructureUnit

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
        self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy - (75 * 6))
    end,

    OnShieldEnabled = function(self)
        self:CleanUp()
        SShieldStructureUnit.OnShieldEnabled(self)
        local army = self:GetArmy()
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, army, v ) )
        end
        local drones, radius
        for setI, set in {{6, 22, 'ssb4401_large'},{12, 38, 'ssb4401_small'}} do
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
                IssueMove({dude}, {pos[1] + (radius * (math.sin((math.pi * 2/drones)*i))), pos[2], pos[3] + (radius * (math.cos((math.pi * 2/drones)*i)))})
                for i2 = 1, patrolnodes do
                    IssuePatrol({dude}, {
                        pos[1] + (radius * (math.sin((math.pi * 2/drones)*(i) + ((math.pi * 2/patrolnodes)*i2)))),
                        pos[2],
                        pos[3] + (radius * (math.cos((math.pi * 2/drones)*(i) + ((math.pi * 2/patrolnodes)*i2)))),
                    })
                end
            end
        end
        self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy - (75 * drones))
        LOG(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy - (75 * drones))
    end,

    OnShieldDisabled = function(self)
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

    CleanUp = function(self, notdeathcleanup)
        for i, v in {'ShieldEffectsBag', 'ShieldDroneBag'} do
            if self[v] then
                for k, j in self[v] do
                    j:Destroy()
                end
                if not notdeathcleanup then
                    self[v] = {}
                end
            end
            if not self[v] and not notdeathcleanup then
                self[v] = {}
            end
        end
    end,
}

TypeClass = SSB4401
