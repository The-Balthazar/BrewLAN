#****************************************************************************
#**
#**  Summary  :  Generic land mine script 
#**
#****************************************************************************
                                                      
local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local CMobileKamikazeBombDeathWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombDeathWeapon 
local TIFCommanderDeathWeapon = import('/lua/terranweapons.lua').TIFCommanderDeathWeapon

MineStructureUnit = Class(TStructureUnit) {
    Weapons = {
        DeathWeapon = Class(CMobileKamikazeBombDeathWeapon) {},
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