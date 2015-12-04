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
                    ['North'] = {
                        ent = {},
                        val = {false, 99 },
                    },
                    ['South'] = {
                        ent = {},
                        val = {false, 101},
                    },
                    ['East'] = {
                        ent = {},
                        val = {false, 97},
                    },
                    ['West'] = {
                        ent = {},
                        val = {false, 103},
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
           
        OnStopBeingBuilt = function(self,builder,layer)
            SuperClass.OnStopBeingBuilt(self,builder,layer)
            --This is here purely for the UEF ones, because it doesn't work OnCreate for them.
            self:BoneUpdate(self.Info.bones)
        end,
          
        OnAdjacentTo = function(self, adjacentUnit, triggerUnit)
            local dirs = { 'South', 'East', 'East', 'North', 'North', 'West', 'West', 'South'}
            local MyX, MyY, MyZ = unpack(self:GetPosition())
            local AX, AY, AZ = unpack(adjacentUnit:GetPosition())
            local cat = self:GetBlueprint().Display.AdjacencyConnection
        
            self.Info.ents[dirs[math.ceil(((math.atan2(MyX - AX, MyZ - AZ) * 180 / math.pi) + 180)/45)]].ent = adjacentUnit
            
            for k, v in self.Info.ents do              
                v.val[1] = EntityCategoryContains(categories[cat], v.ent)
            end      
            self:BoneCalculation() 
            SuperClass.OnAdjacentTo(self, adjacentUnit, triggerUnit) 
        end,
    
        --Old codes
        BoneCalculation = function(self)   
            local cat = self:GetBlueprint().Display.AdjacencyConnection
            local TowerCalc = 0
            for i, v in self.Info.ents do
                if v.val[1] == true then
                    TowerCalc = TowerCalc + v.val[2]
                    self:SetAllBones('bonetype', i, 'show')
                    self:SetAllBones('conflict', i, 'hide')
                else
                    self:SetAllBones('bonetype', i, 'hide')
                end 
            end
            if TowerCalc == 200 then
                self:SetAllBones('bonetype', 'Tower', 'hide')
            else
                self:SetAllBones('bonetype', 'Tower', 'show')
                self:SetAllBones('conflict', 'Tower', 'hide')
            end
            if self:GetBlueprint().Display.AdjacencyBeamConnections then
                for k1, v1 in self.Info.ents do
                    if v1.val[1] then
                        for k, v in self.Info.bones do
                            if v.bonetype == 'Beam' then
                                if self:IsValidBone(k) and v1.ent:IsValidBone(k) then
                                    v1.ent.Trash:Add(AttachBeamEntityToEntity(self, k, v1.ent, k, self:GetArmy(), v.beamtype))
                                end
                            end
                        end
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