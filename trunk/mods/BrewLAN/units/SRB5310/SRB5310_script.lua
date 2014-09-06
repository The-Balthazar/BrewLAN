#****************************************************************************
#** 
#**  Cybran Wall: With cordinal scripting
#** 
#****************************************************************************
local CLandFactoryUnit = import('/lua/cybranunits.lua').CLandFactoryUnit

SRB5310 = Class(CLandFactoryUnit) {        
    BuildAttachBone = 'WallNode',    
    OnCreate = function(self,builder,layer)             
        self:AddBuildRestriction(categories.ANTINAVY)
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
            bones = {
                North = {
                    visibility = 'hide',
                    bonetype = 'North',
                    conflict = nil,
                },
                South = {
                    visibility = 'hide',  
                    bonetype = 'South',
                    conflict = nil,
                }, 
                East = {
                    visibility = 'hide',  
                    bonetype = 'East',
                    conflict = nil,
                }, 
                West = {
                    visibility = 'hide',  
                    bonetype = 'West',
                    conflict = nil,
                },
                North_Buttress =  {
                    visibility = 'hide',   
                    bonetype = 'North',
                    conflict = 'Tower',
                },
                South_Buttress = {
                    visibility = 'hide',  
                    bonetype = 'South',
                    conflict = 'Tower',
                },
                East_Buttress = {
                    visibility = 'hide',  
                    bonetype = 'East',
                    conflict = 'Tower',
                },  
                West_Buttress = {
                    visibility = 'hide', 
                    bonetype = 'West',
                    conflict = 'Tower',
                },
                Tower = {
                    visibility = 'show',  
                    bonetype = 'Tower',
                    conflict = nil,
                },    
                TowerButtressN = {
                    visibility = 'show', 
                    bonetype = 'Tower',
                    conflict = 'North',
                },  
                TowerButtressS = {
                    visibility = 'show', 
                    bonetype = 'Tower',
                    conflict = 'South',
                },  
                TowerButtressE = {
                    visibility = 'show', 
                    bonetype = 'Tower',
                    conflict = 'East',
                },
                TowerButtressW = {
                    visibility = 'show',
                    bonetype = 'Tower',
                    conflict = 'West',
                },
            },
        }
        self:BoneUpdate(self.Info.bones)  
        self:CreateTarmac(true, true, true, false, false)
    end, 
          
    BoneCalculation = function(self)
        for k, v in self.Info.ents do
            v.val = EntityCategoryContains(categories.srb5310, v.ent)
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
        self:BoneUpdate(self.Info.bones)  
    end,
    
    SetAllBones = function(self, check, bonetype, action)
        for k, v in self.Info.bones do
            if v[check] == bonetype then
                v.visibility = action
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
        if EntityCategoryContains(categories.srb5310, adjacentUnit) then
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
        self:DestroyBuildRotator()
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
            if self.AttachedUnit:IsDead() then
                self:DetachAll(self:GetBlueprint().Display.BuildAttachBone or 0)
                self:DestroyBuildRotator()
            end
            --self:DoTakeDamage(instigator, amount, vector, damageType)
        end
    end,
}

TypeClass = SRB5310