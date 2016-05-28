--------------------------------------------------------------------------------
-- Summary  :  BrewLAN multi-unit scripts.
--------------------------------------------------------------------------------                                                      

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local TIFCommanderDeathWeapon = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/sim/defaultweapons.lua').DeathNukeWeapon
local CLandFactoryUnit = import('/lua/cybranunits.lua').CLandFactoryUnit    

--------------------------------------------------------------------------------
-- Mine script
-------------------------------------------------------------------------------- 

MineStructureUnit = Class(TStructureUnit) {
    Weapons = {
        --DeathWeapon = Class(CMobileKamikazeBombDeathWeapon) {},
        Suicide = Class(CMobileKamikazeBombWeapon) {      
            OnFire = function(self)			
                self.unit:SetDeathWeaponEnabled(false)
                CMobileKamikazeBombWeapon.OnFire(self)
            end,
        },
    },

    OnCreate = function(self,builder,layer)
        TStructureUnit.OnCreate(self)
        ### enable cloaking and stealth 
        self:EnableIntel('Cloak')
        self:EnableIntel('RadarStealth')
        self:EnableIntel('SonarStealth')
        local pos = self:GetPosition()
        self.blocker = CreateUnitHPR('ZZZ2220',self:GetArmy(),pos[1],pos[2],pos[3],0,0,0)
        self.Trash:Add(self.blocker)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
        local bp = self:GetBlueprint()    
        if self:GetCurrentLayer() == 'Water' then
            self.Trash:Add(CreateSlider(self, 0, 0, -20, 0, 5))
        end
        if self.blocker then
            --This tricks the engine into thinking the area is clear:
            --Removing a building with an overlapping footprint from the same layer.
            self.blocker:Destroy()
        end      
    end,

    OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
            self:GetWeaponByLabel('Suicide'):FireWeapon()
        end
    end,
}

--------------------------------------------------------------------------------
-- Nuke Mine script
-------------------------------------------------------------------------------- 

NukeMineStructureUnit = Class(MineStructureUnit) {
    Weapons = {
        DeathWeapon = Class(TIFCommanderDeathWeapon) {},
        Suicide = Class(TIFCommanderDeathWeapon) {
            OnFire = function(self)			
                self.unit:SetWeaponEnabledByLabel('DeathWeapon', false)
                TIFCommanderDeathWeapon.OnFire(self)
            end,
        },
    },

    OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
            self:GetWeaponByLabel('Suicide'):Fire()
        end
    end,
}

--------------------------------------------------------------------------------
-- Wall scripts
-------------------------------------------------------------------------------- 

StackingBuilderUnit = Class(CLandFactoryUnit) {
        
    BuildAttachBone = 'WallNode', 
       
    OnCreate = function(self,builder,layer)      
        self:AddBuildRestriction(categories.ANTINAVY)
        self:AddBuildRestriction(categories.HYDROCARBON)
        CLandFactoryUnit.OnCreate(self,builder,layer)    
    end, 
    
    CreateBlinkingLights = function(self, color)
    end, 
      
    FinishBuildThread = function(self, unitBeingBuilt, order )
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationFinishBuildLand
        --self:DestroyBuildRotator()
        if order != 'Upgrade' then
            ChangeState(self, self.RollingOffState)
        else
            self:SetBusy(false)
            self:SetBlockCommandQueue(false)
        end
        self.AttachedUnit = unitBeingBuilt
    end,
         
    StartBuildFx = function(self, unitBeingBuilt)
    end,  
    
    OnDamage = function(self, instigator, amount, vector, damageType)    
        CLandFactoryUnit.OnDamage(self, instigator, amount, vector, damageType)
        if self.AttachedUnit and not self.AttachedUnit:IsDead() then
            local amountR = amount * .5
            self.AttachedUnit:OnDamage(instigator, amountR, vector, damageType)
            --if self.AttachedUnit:IsDead() then
            --    self:DetachAll(self:GetBlueprint().Display.BuildAttachBone or 0)
            --    self:DestroyBuildRotator()
            --end
            --self:DoTakeDamage(instigator, amount, vector, damageType)
        end
    end,   
    
    OnScriptBitSet = function(self, bit)
        CLandFactoryUnit.OnScriptBitSet(self, bit)
        if bit == 7 then
            if self.AttachedUnit then
                self.AttachedUnit:Destroy() 
            end 
            self:SetScriptBit('RULEUTC_SpecialToggle',false) 
            IssueClearCommands({self})
        end
    end,
    
    UpgradingState = State(CLandFactoryUnit.UpgradingState) {
        Main = function(self)
            CLandFactoryUnit.UpgradingState.Main(self)
        end,
        
        OnStopBuild = function(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 then
                if self.AttachedUnit then
                    self.AttachedUnit:Destroy() 
                end
            end
            CLandFactoryUnit.UpgradingState.OnStopBuild(self, unitBuilding) 
                --unitBuilding.Info.ents = self.Info.ents
                --unitBuilding:BoneCalculation()  
        end,
    }
}