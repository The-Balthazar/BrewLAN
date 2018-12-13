do
    local oldUnit = Unit
    local KnifeFightLocation = function()
        for i, mod in __active_mods do
            if mod.uid == "25D57D85-9JA7-D842-BREW-KNIVES000002" then
                return mod.location
            end
        end
    end

    Unit = Class(oldUnit) {
        OnStopBeingBuilt = function(self,builder,layer)
            oldUnit.OnStopBeingBuilt(self,builder,layer)
            local bp = self:GetBlueprint()
            local entity = import('/lua/sim/Entity.lua').Entity
            local pos = self:GetPosition()
            local unitsize = math.max((bp.SizeX or 1),(bp.SizeZ or 1),(bp.SizeY or 1))
            local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
            local knives = {
                KnifeFightLocation() .. '/effects/entities/knife_001/knife_001_mesh',
                KnifeFightLocation() .. '/effects/entities/knife_002/knife_002_mesh',
            }
            local chosenKnife = math.random(1, table.getn(knives))
            self.Knives = {}
            if bp.Weapon then
                for i, weapon in bp.Weapon do
                    if weapon.KNIFE then
                        if weapon.RackBones then
                            for ri, rack in weapon.RackBones do
                                if rack.MuzzleBones then
                                    for mi, muzzle in rack.MuzzleBones do
                                        table.insert(self.Knives, entity())
                                        local knife = self.Knives[table.getn(self.Knives)]
                                        self.Trash:Add(knife)
                                        knife:SetMesh(knives[chosenKnife])
                                        knife:AttachTo(self,muzzle)
                                        knife:SetDrawScale(0.025*(unitsize)*RandomFloat(0.925, 1.075))
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end,
    }
end
