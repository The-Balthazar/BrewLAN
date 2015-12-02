--------------------------------------------------------------------------------
-- Seraphim Optics Tracking Facility script.
-- Spererate from the units actual script for reasons.
--------------------------------------------------------------------------------
function CardinalWallUnit(SuperClass)
    return Class(SuperClass) {
        OnCreate = function(self)
            SuperClass.OnCreate(self)
            self.Info = {
                ents = {
                    ['northUnit'] = {
                        ent = {},
                        val = false,
                    },
                    ['southUnit'] = {
                        ent = {},
                        val = false,
                    },
                    ['eastUnit'] = {
                        ent = {},
                        val = false,
                    },
                    ['westUnit'] = {
                        ent = {},
                        val = false,
                    },
                },
                bones = {}
            }
            for i, v in self:GetBlueprint().Display.AdjacencyConnectionInfo.Bones do
                self.Info.bones[i] = {}
                for j, k in v do
                    self.Info.bones[i][j] = k                 
                end
            end
            
            self:BoneUpdate(self.Info.bones)   
        end,
             
        OnAdjacentTo = function(self, adjacentUnit, triggerUnit)
            local dirs = { 'southUnit', 'eastUnit', 'eastUnit', 'northUnit', 'northUnit', 'westUnit', 'westUnit', 'southUnit'}
            local MyX, MyY, MyZ = unpack(self:GetPosition())
            local AX, AY, AZ = unpack(adjacentUnit:GetPosition())
            local cat = self:GetBlueprint().Display.AdjacencyConnection
        
            self.Info.ents[dirs[math.ceil(((math.atan2(MyX - AX, MyZ - AZ) * 180 / math.pi) + 180)/45)]].ent = adjacentUnit
            
            for k, v in self.Info.ents do              
                v.val = EntityCategoryContains(categories[cat], v.ent)
            end      
            self:BoneCalculation() 
            SuperClass.OnAdjacentTo(self, adjacentUnit, triggerUnit) 
        end,
    
        --Old codes
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
    }    
end