local UnitOld = Unit

Unit = Class(UnitOld) {
    OnStartBuild = function(self, unitBeingBuilt, order)
        local bp = self:GetBlueprint()
        if bp.General.UpgradesTo and unitBeingBuilt:GetUnitId() == bp.General.UpgradesTo and order == 'Upgrade' then
            if not bp.General.CommandCaps.RULEUCC_Stop then
                self:AddCommandCap('RULEUCC_Stop')
                self.CouldntStop = true
            end
        end
        if order == 'Repair' and unitBeingBuilt.WreckMassMult then
            self.Rezrepairing = true
        elseif self.Rezrepairing then      
            self.Rezrepairing = false        
        end       
        UnitOld.OnStartBuild(self, unitBeingBuilt, order)
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        if self.CouldntStop then
            self:RemoveCommandCap('RULEUCC_Stop')
            self.CouldntStop = false
        end                      
        if self.Rezrepairing then
            unitBeingBuilt.WreckMassMult = 0.9 * unitBeingBuilt:GetHealthPercent()
            LOG('Thing is: ',unitBeingBuilt.WreckMassMult)
        end           
        UnitOld.OnStopBuild(self, unitBeingBuilt)
    end,

    OnFailedToBuild = function(self)
        if self.CouldntStop then
            self:RemoveCommandCap('RULEUCC_Stop')
            self.CouldntStop = false
        end       
        UnitOld.OnFailedToBuild(self)
    end,
    
    CreateWreckageProp = function( self, overkillRatio )
        local bp = self:GetBlueprint()
        local wreck = bp.Wreckage.Blueprint
        if wreck then
            #LOG('*DEBUG: Spawning Wreckage = ', repr(wreck), 'overkill = ',repr(overkillRatio))
            local pos = self:GetPosition()
            local mass = bp.Economy.BuildCostMass * (bp.Wreckage.MassMult or 0)
            local energy = bp.Economy.BuildCostEnergy * (bp.Wreckage.EnergyMult or 0)
            local time = (bp.Wreckage.ReclaimTimeMultiplier or 1)
            if self:GetCurrentLayer() == 'Seabed' or self:GetCurrentLayer() == 'Land' then
                pos[2] = GetTerrainHeight(pos[1], pos[3]) + GetTerrainTypeOffset(pos[1], pos[3])
            else
                pos[2] = GetSurfaceHeight(pos[1], pos[3]) + GetTerrainTypeOffset(pos[1], pos[3])
            end
            
            local prop = CreateProp( pos, wreck )
            
            # We make sure keep only a bounded list of wreckages around so we don't get into perf issues when
            # we accumulate too many wreckages
            prop:AddBoundedProp(mass)
            
            prop:SetScale(bp.Display.UniformScale)
            prop:SetOrientation(self:GetOrientation(), true)
            prop:SetPropCollision('Box', bp.CollisionOffsetX, bp.CollisionOffsetY, bp.CollisionOffsetZ, bp.SizeX* 0.5, bp.SizeY* 0.5, bp.SizeZ * 0.5)
            prop:SetMaxReclaimValues(time, time, mass, energy)
            mass = (mass - (mass * (overkillRatio or 1))) * self:GetFractionComplete()     
            if self.WreckMassMult then
            mass = mass * self.WreckMassMult
            end
            energy = (energy - (energy * (overkillRatio or 1))) * self:GetFractionComplete()
            time = time - (time * (overkillRatio or 1))
            
            prop:SetReclaimValues(time, time, mass, energy)
            prop:SetMaxHealth(bp.Defense.Health)
            prop:SetHealth(self, bp.Defense.Health * (bp.Wreckage.HealthMult or 1))
            
            #FIXME: SetVizToNeurals('Intel') is correct here, so you can't see enemy wreckage appearing
            # under the fog. However the engine has a bug with prop intel that makes the wreckage
            # never appear at all, even when you drive up to it, so this is disabled for now.
            #prop:SetVizToNeutrals('Intel')
            if not bp.Wreckage.UseCustomMesh then
            prop:SetMesh(bp.Display.MeshBlueprintWrecked)
        end
        
        # Attempt to copy our animation pose to the prop. Only works if
        # the mesh and skeletons are the same, but will not produce an error
        # if not.
        TryCopyPose(self,prop,false)
        
        prop.AssociatedBP = self:GetBlueprint().BlueprintId
        
        # Create some ambient wreckage smoke
        explosion.CreateWreckageEffects(self,prop)
        prop.OldId = self:GetBlueprint().BlueprintId
        return prop
        else
            return nil
        end
    end, 
}

