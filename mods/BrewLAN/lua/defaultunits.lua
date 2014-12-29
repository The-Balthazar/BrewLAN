#****************************************************************************
#**
#**  Summary  :  BrewLAN multi-unit scripts.
#**
#****************************************************************************
                                                      
local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local CMobileKamikazeBombDeathWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombDeathWeapon 
local TIFCommanderDeathWeapon = import('/lua/terranweapons.lua').TIFCommanderDeathWeapon
local CLandFactoryUnit = import('/lua/cybranunits.lua').CLandFactoryUnit    

--------------------------------------------------------------------------------
-- Mine script
-------------------------------------------------------------------------------- 

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
-- Wall script
-------------------------------------------------------------------------------- 

CardinalWallScript = Class(CLandFactoryUnit) {        
    BuildAttachBone = 'WallNode',    
    OnCreate = function(self,builder,layer)      
        self:AddBuildRestriction(categories.ANTINAVY)
        self:AddBuildRestriction(categories.HYDROCARBON)
        CLandFactoryUnit.OnCreate(self,builder,layer)    
        self.Info = {
            ents = {
                northUnit = {
                    ent = {},
                    val = false,
                },
                southUnit = {
                    ent = {},
                    val = false,
                },
                eastUnit = {
                    ent = {},
                    val = false,
                },
                westUnit = {
                    ent = {},
                    val = false,
                },
            },
            bones = self:GetBlueprint().Display.AdjacencyConnectionInfo.Bones
        } 
        self:BoneUpdate(self.Info.bones)  
        self:CreateTarmac(true, true, true, false, false)
    end, 
          
    BoneCalculation = function(self)   
        local cat = self:GetBlueprint().Display.AdjacencyConnection
        for k, v in self.Info.ents do              
            v.val = EntityCategoryContains(categories[cat], v.ent)
        end      
        local TowerCalc = 0
        if self.Info.ents.northUnit.val then
            self:SetAllBones('bonetype', 'North', 'show')
            TowerCalc = TowerCalc + 99
        else
            self:SetAllBones('bonetype', 'North', 'hide')
        end 
        if self.Info.ents.southUnit.val then     
            self:SetAllBones('bonetype', 'South', 'show')
            TowerCalc = TowerCalc + 101 
        else
            self:SetAllBones('bonetype', 'South', 'hide')
        end 
        if self.Info.ents.eastUnit.val then     
            self:SetAllBones('bonetype', 'East', 'show')
            TowerCalc = TowerCalc + 97 
        else
            self:SetAllBones('bonetype', 'East', 'hide')
        end   
        if self.Info.ents.westUnit.val then     
            self:SetAllBones('bonetype', 'West', 'show')
            TowerCalc = TowerCalc + 103 
        else
            self:SetAllBones('bonetype', 'West', 'hide')
        end
        if TowerCalc == 200 then
            self:SetAllBones('bonetype', 'Tower', 'hide')
        else
            self:SetAllBones('bonetype', 'Tower', 'show')
            self:SetAllBones('conflict', 'Tower', 'hide')
            if self.Info.ents.northUnit.val then
                self:SetAllBones('conflict', 'North', 'hide')
            end 
            if self.Info.ents.southUnit.val then     
                self:SetAllBones('conflict', 'South', 'hide') 
            end 
            if self.Info.ents.eastUnit.val then     
                self:SetAllBones('conflict', 'East', 'hide') 
            end   
            if self.Info.ents.westUnit.val then     
                self:SetAllBones('conflict', 'West', 'hide')   
            end
        end
        if self:GetBlueprint().Display.AdjacencyBeamConnections then
            for k1, v1 in self.Info.ents do
                if v1.val then
                    --if not v1.ent:isDead() then 
                        for k, v in self.Info.bones do
                            if v.bonetype == 'Beam' then
                                if self:IsValidBone(k) and v1.ent:IsValidBone(k) then
                                    v1.ent.Trash:Add(AttachBeamEntityToEntity(self, k, v1.ent, k, self:GetArmy(), v.beamtype))
                                end
                            end
                        end
                    --end
                end
            end
        end
        self:BoneUpdate(self.Info.bones)  
    end,
    
    SetAllBones = function(self, check, bonetype, action)
        for k, v in self.Info.bones do
            if type(v[check]) == "table" then
                for i, vn in v[check] do
                    if vn == bonetype then
                        v.visibility = action 
                    end
                end
            else
                if v[check] == bonetype then
                    v.visibility = action
                end
            end
        end                                                
    end,   
             
    BoneUpdate = function(self, bones)
        for k, v in bones do
            if v.visibility == 'show' then   
                if self:IsValidBone(k) then
                    self:ShowBone(k, true)
                end
            else
                if self:IsValidBone(k) then   
                    self:HideBone(k, true) 
                end
            end
        end                                               
    end,   
    
    OnAdjacentTo = function(self, adjacentUnit, triggerUnit)
        local MyX, MyY, MyZ = unpack(self:GetPosition())
        local AX, AY, AZ = unpack(adjacentUnit:GetPosition())
        local cat = self:GetBlueprint().Display.AdjacencyConnection
        if EntityCategoryContains(categories[cat], adjacentUnit) then
            if MyX > AX then
                self.Info.ents.westUnit.ent = adjacentUnit
            end
            if MyX < AX then         
                self.Info.ents.eastUnit.ent = adjacentUnit
            end
            if MyZ > AZ then         
                self.Info.ents.northUnit.ent = adjacentUnit
            end
            if MyZ < AZ then   
                self.Info.ents.southUnit.ent = adjacentUnit
            end
        end      
        self:BoneCalculation() 
        --CLandFactoryUnit.OnAdjacentTo(self,builder,layer)  
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

--------------------------------------------------------------------------------
-- Gate script
-------------------------------------------------------------------------------- 

CardinalGateScript = Class(CardinalWallScript) {  
    OnCreate = function(self)
        CardinalWallScript.OnCreate(self)  
        self.Slider = CreateSlider(self, 0)   
        self.Trash:Add(self.Slider) 
    end,
         
    OnStopBeingBuilt = function(self,builder,layer)
        CardinalWallScript.OnStopBeingBuilt(self, builder, layer) 
        self:ToggleGate('open')
    end,
    
    ToggleGate = function(self, order)
        local depth = self:GetBlueprint().Display.GateOpenHeight or 40
        if order == 'open' then  
            self.Slider:SetGoal(0, depth, 0)   
            self.Slider:SetSpeed(200)
            if self.blocker then
               self.blocker:Destroy()
               self.blocker = nil
            end      
        end
        if order == 'close' then  
            self.Slider:SetGoal(0, 0, 0)      
            self.Slider:SetSpeed(200)
            if not self.blocker then
               local pos = self:GetPosition()
               self.blocker = CreateUnitHPR('ZZZ5301',self:GetArmy(),pos[1],pos[2],pos[3],0,0,0)
               self.Trash:Add(self.blocker)
            end      
        end
    end,      
    
    OnScriptBitSet = function(self, bit)
        if bit == 1 then                      
            self:ToggleGate('close')
        end
        CardinalWallScript.OnScriptBitSet(self, bit)
        if bit == 1 then                
            for k, v in self.Info.ents do
                if v.val then
                    v.ent:SetScriptBit('RULEUTC_WeaponToggle',true)
                end 
            end              
        end
    end,  
      
    OnScriptBitClear = function(self, bit)
        if bit == 1 then   
            self:ToggleGate('open')
        end
        CardinalWallScript.OnScriptBitClear(self, bit)
        if bit == 1 then   
            for k, v in self.Info.ents do
                if v.val then
                    v.ent:SetScriptBit('RULEUTC_WeaponToggle',false)
                end 
            end               
        end
    end,  
         
    --[[OnMotionVertEventChange = function( self, new, old )
        CardinalWallScript.OnMotionVertEventChange(self, new, old)
        LOG(new)
        if new == 'Top' then
            self:ToggleGate('close')
        elseif new == 'Down' then
            self:ToggleGate('open')
        end
    end,--]]
    
    OnKilled = function(self, instigator, type, overkillRatio)
        CardinalWallScript.OnKilled(self, instigator, type, overkillRatio)
        if self.blocker then
           self.blocker:Destroy()
        end      
    end,
}