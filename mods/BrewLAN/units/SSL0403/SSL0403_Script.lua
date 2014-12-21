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
		  SConstructionUnit.OnStartReclaim(self, target)
        self.RezTarget = {
            id = target.OldId,
            pos = target:GetPosition(),
            ori = target:GetOrientation(),
            entid = target:GetEntityId(),
        }
        --self:tprint(target:GetBlueprint())
        --LOG(target.OldId)
    end,

    OnStopReclaim = function(self, target)      
		  SConstructionUnit.OnStopReclaim(self, target)    
        local pos = self.RezTarget.pos   
        local wreckageID = self.RezTarget.entid  
        local dupecheck = self:GetAIBrain():GetUnitsAroundPoint( categories[self.RezTarget.id], pos, 10)
        local ABORT = false    
        if dupecheck and table.getn(dupecheck) > 0 then
            for i, v in dupecheck do
                if v.OldWreckageID == wreckageID then
                    ABORT = true
                end
            end
        end       
        if not target and self.RezTarget.id and not ABORT then
            local ori = self.RezTarget.ori
            local rezzedGuy = CreateUnit(self.RezTarget.id, self:GetArmy(), pos[1], pos[2], pos[3], ori[1], ori[2], ori[3], ori[4])
            rezzedGuy:SetHealth(self, 1 )
            rezzedGuy.WreckMassMult = 0.01
            rezzedGuy.OldWreckageID = wreckageID
            LOG(rezzedGuy:GetBlueprint().Economy.BuildTime / self:GetBlueprint().Economy.BuildRate)
            rezzedGuy:SetStunned(rezzedGuy:GetBlueprint().Economy.BuildTime / self:GetBlueprint().Economy.BuildRate or 10)
            IssueRepair({self},rezzedGuy)
        end 
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