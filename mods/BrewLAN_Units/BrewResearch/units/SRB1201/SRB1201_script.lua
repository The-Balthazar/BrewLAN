local CEnergyCreationUnit = import('/lua/cybranunits.lua').CEnergyCreationUnit

SRB1201 = Class(CEnergyCreationUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        CEnergyCreationUnit.OnStopBeingBuilt(self,builder,layer)
        local army =  self:GetArmy()
        local dir = '/effects/emitters/cybran_t2power_ambient_0'
        for k, v in {dir..'1_emit.bp', dir..'1b_emit.bp'} do
            for i = 1, 2 do
                CreateAttachedEmitter(self, 'Effects' .. i, army, v):ScaleEmitter(0.80)
            end
        end
        ChangeState(self, self.ActiveState)
    end,

    ActiveState = State {
        Main = function(self)
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Activate then
                self:PlaySound(myBlueprint.Audio.Activate)
            end
        end,

        OnInActive = function(self)
            ChangeState(self, self.InActiveState)
        end,
    },

    InActiveState = State {
        Main = function(self)
        end,

        OnActive = function(self)
            ChangeState(self, self.ActiveState)
        end,
    },
}

TypeClass = SRB1201
