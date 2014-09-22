#****************************************************************************
#** 
#**  Cybran Wall: With cordinal scripting
#** 
#****************************************************************************
local CStructureUnit = import('/mods/BrewLAN/units/srb5310/srb5310_script.lua').SRB5310

SRB5311 = Class(CStructureUnit) {  
    OnCreate = function(self)
        CStructureUnit.OnCreate(self)  
        self.Slider = CreateSlider(self, 0)    
    end,
         
    OnStopBeingBuilt = function(self,builder,layer)
        CStructureUnit.OnStopBeingBuilt(self, builder, layer) 
        self:ToggleGate('open')
    end,
    ToggleGate = function(self, order)
        local depth = self:GetBlueprint().Display.GateOpenHeight or 40
        --LOG(order)
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
        CStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then                      
            --[[if self.Time then
                if self.Time + .5 > GetGameTimeSeconds() then
                    return
                end
            end
            self.Time = GetGameTimeSeconds()--]]
            self:ToggleGate('close')
            for k, v in self.Info.ents do
                if v.val then
                    v.ent:SetScriptBit('RULEUTC_WeaponToggle',true)
                end 
            end              
        end
    end,  
      
    OnScriptBitClear = function(self, bit)
        CStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then   
            --[[if self.Time then
                if self.Time + .5 > GetGameTimeSeconds() then
                    return
                end
            end
            self.Time = GetGameTimeSeconds()--]]     
            self:ToggleGate('open')
            for k, v in self.Info.ents do
                if v.val then
                    v.ent:SetScriptBit('RULEUTC_WeaponToggle',false)
                end 
            end               
        end
    end,  
         
    --[[OnMotionVertEventChange = function( self, new, old )
        CStructureUnit.OnMotionVertEventChange(self, new, old)
        LOG(new)
        if new == 'Top' then
            self:ToggleGate('close')
        elseif new == 'Down' then
            self:ToggleGate('open')
        end
    end,--]]
    
    OnKilled = function(self, instigator, type, overkillRatio)
        CStructureUnit.OnKilled(self, instigator, type, overkillRatio)
        if self.blocker then
           self.blocker:Destroy()
        end      
    end,
}

TypeClass = SRB5311