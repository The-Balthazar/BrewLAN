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
        self:ToggleGate('open')
    end,
    
    ToggleGate = function(self, order)
        LOG(order)
        if order == 'open' then  
            self.Slider:SetGoal(0, -40, 0)   
            self.Slider:SetSpeed(120)
            if self.blocker then
               self.blocker:Destroy()
               self.blocker = nil
            end      
        end
        if order == 'close' then  
            self.Slider:SetGoal(0, 0, 0)      
            self.Slider:SetSpeed(120)
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
            self:ToggleGate('close')
        end
    end,  
      
    OnScriptBitClear = function(self, bit)
        CStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then      
            self:ToggleGate('open')
        end
    end,  
        
    OnKilled = function(self, instigator, type, overkillRatio)
        CStructureUnit.OnKilled(self, instigator, type, overkillRatio)
        if self.blocker then
           self.blocker:Destroy()
        end      
    end,
}

TypeClass = SRB5311