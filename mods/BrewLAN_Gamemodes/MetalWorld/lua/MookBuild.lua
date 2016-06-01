function AiTrix(SuperClass)
    return Class(SuperClass) {
        OnStopBeingBuilt = function(self,builder,layer)
            SuperClass.OnStopBeingBuilt(self,builder,layer)     
            local aiBrain = self:GetAIBrain()
            if aiBrain.BrainType != 'Human' then 
                local fI = aiBrain:GetFactionIndex()
                local powerfabs = {
                    'ueb1101',
                    'uab1101',
                    'urb1101',
                    'xsb1101',
                }    
                self:ForkThread(
                    function()
                        self.MookBuild(self,builder, powerfabs[fI])
                    end
                )
            end
        end,
        
        MookBuild = function(self, mook, building, distance)   
            local pos = self:GetPosition()  
            local bp = self:GetBlueprint()
            local aiBrain = self:GetAIBrain()
         
            local x = bp.Physics.SkirtSizeX / 2 + (distance or 1)
            local z = bp.Physics.SkirtSizeZ / 2 + (distance or 1)
            local sign = -1 + 2 * math.random(0, 1)     
            local BuildGoalX = 0
            local BuildGoalZ = 0       
            if math.random(0, 1) > 0 then
                BuildGoalX = sign * x
                BuildGoalZ = math.random(math.ceil(-z/2),math.ceil(z/2))*2
            else
                BuildGoalX = math.random(math.ceil(-x/2),math.ceil(x/2))*2
                BuildGoalZ = sign * z
            end 
            CreateUnitHPR(building, self:GetArmy(), pos[1], pos[2], pos[3], 3.1415926535926535, 0, 0)
            --aiBrain:BuildStructure(mook, building, {pos[1]+BuildGoalX, pos[3]+BuildGoalZ, 0})
        end,
    }
end
