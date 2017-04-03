local TArtilleryAntiMatterProjectile = import('/lua/terranprojectiles.lua').TArtilleryAntiMatterProjectile02
local utilities = import('/lua/utilities.lua')
local BrewLANPath = import( '/lua/game.lua' ).BrewLANPath()
local Buff = import(BrewLANPath .. '/lua/legacy/VersionCheck.lua').Buff
local GetTerrainAngles = import(BrewLANPath .. '/lua/TerrainUtils.lua').GetTerrainSlopeAnglesDegrees
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
            if self.Data then
                DamageArea(self, self:GetPosition(), self.DamageData.DamageRadius, __blueprints[self.Data[1]].Economy.BuildCostMass * (self.Data[2] or 1) , 'Normal', self.DamageData.DamageFriendly)
            end
            --self.DropUnit(self,true)
        else
            TArtilleryAntiMatterProjectile.OnImpact(self, TargetType, TargetEntity)
            self.DropUnit(self)
        end
    end,

    DropUnit = function(self, hitshield)
        local pos = self:GetPosition()
        if self.Data[1] then
            local DroppedUnit = CreateUnitHPR(self.Data[1],self:GetArmy(),pos[1], pos[2], pos[3],0, math.random(0,360), 0)
            if
            not hitshield and
            (
                -- If we are on land                           and they say land                                             or the bitwise string is odd
                DroppedUnit:GetCurrentLayer() == "Land" and (__blueprints[self.Data[1]].Physics.BuildOnLayerCaps == "Land" or math.mod(tonumber(__blueprints[self.Data[1]].Physics.BuildOnLayerCaps), 2) == 1)
                or --or if we are not on land              and the unit doesn't say land                                then it will survive anywhere else since the other options are all "in or on the water"
                DroppedUnit:GetCurrentLayer() != "Land" and __blueprints[self.Data[1]].Physics.BuildOnLayerCaps != "Land"
            )
            then
                local target = self:GetCurrentTargetPosition()
                IssueMove( {DroppedUnit},  {target[1] + Random(-3, 3), target[2], target[3]+ Random(-3, 3)} )
                if self.Data[2] and type(self.Data[2]) == "number" and self.Data[2] != 1 then
                    local buffname = 'IvanHealthBuff' .. self.Data[2]
                    if not Buffs[buffname] then
                        BuffBlueprint {
                            Name = buffname,
                            DisplayName = 'IvanHealthBuff',
                            BuffType = 'IvanHealthBuff',
                            Stacks = 'ALWAYS',
                            Duration = -1,
                            Affects = {
                                MaxHealth = {
                                    Add = 0,
                                    Mult = self.Data[2],
                                },
                                --Health = {   --The 'Health' buff is both unnessessary and bugged
                                --    Add = 0,
                                --    Mult = self.Data[2],
                                --},
                            },
                        }
                    end
                    --DroppedUnit:SetHealth(self, DroppedUnit:GetMaxHealth() * self.Data[2] )
                    --DroppedUnit:SetMaxHealth(DroppedUnit:GetMaxHealth() * self.Data[2] )
                    Buff.ApplyBuff(DroppedUnit, buffname)
                end
            else
                --Its landed somewhere it says it shouldn't be
                DroppedUnit:Kill()
            end
        else
            --we were never told what the thing was
            LOG("YOU GET NOTHING. GOOD DAY")
        end
        --LOG(GetTerrainType(pos[1],pos[3]) )
        CreateLightParticle(self, -1, self:GetArmy(), 10, 3, 'flare_lens_add_03', 'ramp_white_07' )
        local Angles = GetTerrainAngles(pos, 3)
        local rotation = 0
        if Angles[1] == 0 and Angles[2] == 0 then
            rotation = math.random(1,360)
        end
        CreatePropHPR(
            import( '/lua/game.lua' ).BrewLANPath() .. '/env/uef/props/UEF_Ivan_Droppod_Remains_prop.bp',
            pos[1], GetTerrainHeight(pos[1],pos[3]), pos[3],
            rotation, Angles[2], -Angles[1]
        )
        self:Kill()
    end,
}

TypeClass = TIFDropPodArtilleryMechMarine
