do
    local UnitOld = Unit

    Unit = Class(UnitOld) {
        OnStopBeingBuilt = function(self,builder,layer, ...)
            UnitOld.OnStopBeingBuilt(self,builder,layer, unpack(arg))
            local pos = self:GetPosition()
            local ori = self:GetOrientation()
            LOG("['UNIT_" .. self:GetEntityId() .. "'] = {" )
            LOG("    type = '" .. self:GetBlueprint().BlueprintId .. "',")
            LOG("    orders = '',")
            LOG("    platoon = '',")
            LOG("    Position = {" .. pos[1] .. "," .. pos[2] .. "," .. pos[3] .. "},")
            LOG("    Orientation = {" .. ori[1] .. "," .. ori[2] .. "," .. ori[3] .. "},")
            LOG("},")
        end,

        OnCreate = function(self, ...)
            UnitOld.OnCreate(self, unpack(arg))
            --[[local bp = self:GetBlueprint().Intel
            if bp then
                local Buff = import('/lua/sim/Buff.lua')
                for i, v in {'RadarRadius','OmniRadius','SonarRadius'} do
                    if not Buffs['Map' .. v .. 'Mult'] then
                        BuffBlueprint {
                            Name = 'Map' .. v .. 'Mult',
                            DisplayName = 'Map' .. v .. 'Mult',
                            BuffType = 'MapIntelMult',
                            Stacks = 'ALWAYS',
                            Duration = -1,
                            Affects = {
                                [v] = {
                                    Add = 0,
                                    Mult = ScenarioInfo.size[1] / 1024,
                                },
                            },
                        }
                    end
                    if bp[v] and bp[v] > 0 then
                        Buff.ApplyBuff(self, 'Map' .. v .. 'Mult')
                    end
                end
            end]]--
        end,
    }
end
