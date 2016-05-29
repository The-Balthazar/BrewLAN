local TArtilleryAntiMatterProjectile = import('/lua/terranprojectiles.lua').TArtilleryAntiMatterProjectile02
local utilities = import('/lua/utilities.lua')
TIFDropPodArtilleryMechMarine = Class(TArtilleryAntiMatterProjectile) {

    FxLandHitScale = 0.2,
    FxUnitHitScale = 0.2,
    FxSplatScale = 1,

    OnCreate = function(self, inWater)
        TArtilleryAntiMatterProjectile.OnCreate(self, inWater)
    end,

    OnImpact = function(self, TargetType, TargetEntity)
        if TargetType == 'Shield' then
            TArtilleryAntiMatterProjectile.OnImpact(self, TargetType, TargetEntity)
            Damage(self, {0,0,0}, TargetEntity, __blueprints[self.Data].Economy.BuildCostMass, 'Normal')
            self.DropUnit(self,true)
        else
            TArtilleryAntiMatterProjectile.OnImpact(self, TargetType, TargetEntity)
            self.DropUnit(self)
        end
    end,
        
    DropUnit = function(self,thing)
        if self.Data then
            local pos = self:GetPosition()
            local AssaultBot = CreateUnitHPR(self.Data,self:GetArmy(),pos[1], pos[2], pos[3],0, math.random(0,360), 0)
            if type(thing) == 'number' then
                AssaultBot:SetHealth(AssaultBot,AssaultBot:GetHealth()*thing or 1)
            elseif thing then
                AssaultBot:Kill()
            else
                --LOG(__blueprints[self.Data].Physics.BuildOnLayerCaps)
                --This doesn't work. BuildOnLayerCaps gets replaced with a bitwise opperator. Need to actually parse the number.
                --if __blueprints[self.Data].Physics.BuildOnLayerCaps['LAYER_' .. AssaultBot:GetCurrentLayer()]) then
                    local target = self:GetCurrentTargetPosition()
                    IssueMove( {AssaultBot},  {target[1] + Random(-3, 3), target[2], target[3]+ Random(-3, 3)} )
                --else
                    --AssaultBot:Kill()
                --end
            end
        else
            LOG("YOU GET NOTHING. GOOD DAY")
        end
        self:Kill()
    end,     
}

TypeClass = TIFDropPodArtilleryMechMarine
