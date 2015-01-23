--------------------------------------------------------------------------------
--  Summary:  Iyadesu Script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------

local SConstructionUnit = import('/lua/seraphimunits.lua').SConstructionUnit
local SLandUnit = import('/lua/seraphimunits.lua').SLandUnit
local WeaponsFile = import('/lua/seraphimweapons.lua')
local SDFAireauBolter = WeaponsFile.SDFAireauBolterWeapon
local SANUallCavitationTorpedo = WeaponsFile.SANUallCavitationTorpedo
local EffectUtil = import('/lua/EffectUtilities.lua')

SSL0403 = Class(SConstructionUnit) {
    Weapons = {
        Torpedo01 = Class(SANUallCavitationTorpedo) {},
        LeftTurret = Class(SDFAireauBolter) {},
        RightTurret = Class(SDFAireauBolter) {},
    },
    StartBeingBuiltEffects = function(self, builder, layer)
        SConstructionUnit.StartBeingBuiltEffects(self, builder, layer)
        self:ForkThread( EffectUtil.CreateSeraphimExperimentalBuildBaseThread, builder, self.OnBeingBuiltEffectsBag )
    end,     
          
    OnStartReclaim = function(self, target)
        if target.AssociatedBP then
            local work = {
                BuildCostMass = __blueprints[target.AssociatedBP].Economy.BuildCostMass - (target.MaxMassReclaim * 0.9),
                BuildCostEnergy = __blueprints[target.AssociatedBP].Economy.BuildCostEnergy - (target.MaxEnergyReclaim * 0.9),
                BuildTime = __blueprints[target.AssociatedBP].Economy.BuildTime,
            }
            LOG("Costs Mass: " .. work.BuildCostMass .. " Energy: " .. work.BuildCostEnergy .. " Build Time: " .. work.BuildTime) 
            local buildtime, energy, mass = import('/lua/game.lua').GetConstructEconomyModel(self, work)
            LOG("Calculated Mass: " .. mass .. " Energy: " .. energy .. " Build Time: " .. buildtime)
            target:SetMaxReclaimValues( target.ReclaimTimeMassMult, target.ReclaimTimeEnergyMult, target.MaxMassReclaim * 0.1, target.MaxEnergyReclaim * 0.1)
            target:SetReclaimValues( target.ReclaimTimeMassMult, target.ReclaimTimeEnergyMult, target.MassReclaim * 0.1, target.EnergyReclaim * 0.1)    
            self.WorkItem = {
                id = target.AssociatedBP,
                BuildCostMass = mass,
                BuildCostEnergy = energy,
                BuildTime = buildtime,
                pos = target:GetPosition(),
                ori = target:GetOrientation(),
                entid = target:GetEntityId(),
            }     
            self:SetActiveConsumptionActive()
        end     
        SConstructionUnit.OnStartReclaim(self, target)
    end,

    OnStopReclaim = function(self, target)    
        if not target and self.WorkItem.id then   
            local pos = self.WorkItem.pos   
            local wreckageID = self.WorkItem.entid  
            local dupecheck = self:GetAIBrain():GetUnitsAroundPoint( categories[self.WorkItem.id], pos, 10)
            local ABORT = false    
            if dupecheck and table.getn(dupecheck) > 0 then
                for i, v in dupecheck do
                    if v.OldWreckageID == wreckageID then
                        ABORT = true
                    end
                end
            end       
            if not ABORT then
                local ori = self.WorkItem.ori
                local rezzedGuy = CreateUnit(self.WorkItem.id, self:GetArmy(), pos[1], pos[2], pos[3], ori[1], ori[2], ori[3], ori[4])
                --rezzedGuy:SetHealth(self, 1 )
                --rezzedGuy.WreckMassMult = 0.01
                rezzedGuy.OldWreckageID = wreckageID
                local tc = 6
                if rezzedGuy:GetBlueprint().Transport.TransportClass then
                    tc = rezzedGuy:GetBlueprint().Transport.TransportClass
                end
                LOG(10 * tc)
                rezzedGuy:SetStunned(10 * tc)
                --IssueRepair({self},rezzedGuy)
                self.WorkItem = {}
            end 
        elseif self.WorkItem.id then    
            self.WorkItem = {}
        end   
        self:SetActiveConsumptionInactive()
        SConstructionUnit.OnStopReclaim(self, target)
    end,
    
    tprint = function(self, tbl, indent)
        if not indent then indent = 0 end
        for k, v in pairs(tbl) do
            formatting = string.rep("  ", indent) .. k .. ": "
            if type(v) == "table" then
                LOG(formatting)
                self:tprint(v, indent+1)
            elseif type(v) == 'boolean' then
                LOG(formatting .. tostring(v))		
            elseif type(v) == 'string' or type(v) == 'number' then
                LOG(formatting .. v)
            else
                LOG(formatting .. type(v))
            end
        end
    end,
}

TypeClass = SSL0403