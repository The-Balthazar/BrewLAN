local TArtilleryAntiMatterProjectile = import('/lua/terranprojectiles.lua').TArtilleryAntiMatterProjectile02
local utilities = import('/lua/utilities.lua')
--local Buff = import('/lua/sim/Buff.lua')
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
            --Damage(self, {0,0,0}, TargetEntity, __blueprints[self.Data].Economy.BuildCostMass, 'Normal')
            self.DropUnit(self,true)
        else
            TArtilleryAntiMatterProjectile.OnImpact(self, TargetType, TargetEntity)
                              --Take health off equal to discount. Since debuf doesn't work.
            self.DropUnit(self, __blueprints.seb2404.Economy.BuilderDiscountMult or 1)
        end
    end,
        
    DropUnit = function(self,thing)
        if self.Data then
            local pos = self:GetPosition()
            local AssaultBot = CreateUnitHPR(self.Data,self:GetArmy(),pos[1], pos[2], pos[3],0, math.random(0,360), 0)
            --Nothing equates to 1 for 'thing' 
            if type(thing) == 'number' or not thing then
                if thing then
                    AssaultBot:SetHealth(AssaultBot,AssaultBot:GetHealth()*thing or 1)
                end
                --Although 'thing' of 0 or less is makes for a dead unit
                if thing > 0 then
                    --LOG(__blueprints[self.Data].Physics.BuildOnLayerCaps)
                    --This doesn't work. BuildOnLayerCaps gets replaced with a bitwise opperator. Need to actually parse the number.
                    --if __blueprints[self.Data].Physics.BuildOnLayerCaps['LAYER_' .. AssaultBot:GetCurrentLayer()]) then
                        local target = self:GetCurrentTargetPosition()
                        IssueMove( {AssaultBot},  {target[1] + Random(-3, 3), target[2], target[3]+ Random(-3, 3)} )
                        
                        -- For some reason this was causing warnings elsewhere. Maybe the game hates debuf health buffs
                        --[[local IvanDiscountMult = __blueprints.seb2404.Economy.BuilderDiscountMult or 1
                        if not Buffs['IvanHealthBuff'] and IvanDiscountMult != 1 then
                            BuffBlueprint {
                                Name = 'IvanHealthBuff',
                                DisplayName = 'IvanHealthBuff',
                                BuffType = 'IvanHealthBuff',
                                Stacks = 'ALWAYS',
                                Duration = -1,
                                Affects = {
                                    MaxHealth = {
                                        Add = 0,
                                        Mult = IvanDiscountMult,
                                    },
                                    Health = {
                                        Add = 0,
                                        Mult = IvanDiscountMult,
                                    },
                                },
                            }
                        end
                        Buff.ApplyBuff(AssaultBot, 'IvanHealthBuff')]]--
                    --else
                        --AssaultBot:Kill()
                    --end
                end
            elseif thing then
                AssaultBot:Kill()
            end
            --This is another piece of data that should get manually passed through,
            --But since I have no plans to make this used by anything other than the Ivan, I'm just going to hardlink it.
        else
            LOG("YOU GET NOTHING. GOOD DAY")
        end
        self:Kill()
    end,     
}

TypeClass = TIFDropPodArtilleryMechMarine
