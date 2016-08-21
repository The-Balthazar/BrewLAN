local Creep = import('/mods/BrewLAN_Gameplay/TeaD/lua/CreepScript.lua').Creep    
local EffectTemplate = import('/lua/EffectTemplates.lua')

TEC0004 = Class(Creep) {
    OnCreate = function(self)
        Creep.OnCreate(self)
        for k, v in EffectTemplate.OthuyAmbientEmanation do
            ###XSL0402
            CreateAttachedEmitter(self,'Outer_Tentaclebase', self:GetArmy(), v)
        end
        self:HideBone(0,true)
    end,
}

TypeClass = TEC0004
