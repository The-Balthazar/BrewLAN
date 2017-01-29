do
    local UnitOld = Unit

    Unit = Class(UnitOld) {
        OnCreate = function(self)
            --Should this have legs?
            if  not self:IsValidBone('Floatation')
                and self:GetCurrentLayer() == 'Water'
                and EntityCategoryContains(categories.STRUCTURE * categories.GIVEMELEGS, self )
            then
                --Leg entity script
                local LEGS = function(self, floatation, size)
                    self.Floatation = import('/lua/sim/Entity.lua').Entity({Owner = self,})
                    Warp(self.Floatation,self:GetPosition())
                    --self.Floatation:AttachBoneTo( -1, self, 0 )
                    self.Floatation:SetMesh('/mods/BrewLAN_Gameplay/Waterlag/effects/entities/' .. floatation .. '/' .. floatation ..'_mesh')
                    self.Floatation:SetDrawScale(size)
                    self.Floatation:SetVizToAllies('Intel')
                    self.Floatation:SetVizToNeutrals('Intel')
                    self.Floatation:SetVizToEnemies('Intel')
                    self.Trash:Add(self.Floatation)
                end
                --Which legs?
                if EntityCategoryContains(categories.UEF, self) then
                    if self:GetBlueprint().Footprint.SizeX >= 3.5 and self:GetBlueprint().Footprint.SizeZ >= 3.5 then
                        LEGS(self, 'UEF_SIZE16_Floatation', 0.083)
                    else
                        LEGS(self, 'UEF_SIZE4_Floatation', 0.083)
                    end
                elseif EntityCategoryContains(categories.CYBRAN, self) then
                    if self:GetBlueprint().Footprint.SizeX >= 5 and self:GetBlueprint().Footprint.SizeZ >= 5 then
                        LEGS(self, 'CYBRAN_SIZE16_Floatation', 0.1)
                    elseif self:GetBlueprint().Footprint.SizeX >= 3 and self:GetBlueprint().Footprint.SizeZ >= 3 then
                        LEGS(self, 'CYBRAN_SIZE12_Floatation', 0.1)
                    else
                        LEGS(self, 'CYBRAN_SIZE4_Floatation', 0.1)
                    end
                elseif EntityCategoryContains(categories.AEON, self) then
                    --SOMETHING
                elseif EntityCategoryContains(categories.SERAPHIM, self) then
                    --SOMETHING
                end
            end
            return UnitOld.OnCreate(self)
        end,
    }
end
