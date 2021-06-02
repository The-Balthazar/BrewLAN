local TRadarUnit = import('/lua/terranunits.lua').TRadarUnit

SEB3101 = Class(TRadarUnit) {

    RadarThread = function(self)
        local spinner = CreateRotator(self, 'Spinner04', 'x', nil, 0, 30, -45)
        while true do
            WaitFor(spinner)
            spinner:SetTargetSpeed(-45)
            WaitFor(spinner)
            spinner:SetTargetSpeed(45)
        end
    end,

    OnStopBeingBuilt = function(self, builder,layer)
        TRadarUnit.OnStopBeingBuilt(self, builder,layer)
        self:ForkThread(self.RadarThread)
        self.Trash:Add(CreateRotator(self, 'Spinner01', 'y', nil, 45, 0, 0))
        self.Trash:Add(CreateRotator(self, 'Spinner02', 'y', nil, -35, 0, 0))
        self.Trash:Add(CreateRotator(self, 'Spinner03', 'y', nil, -30, 0, 0))
    end,
}

TypeClass = SEB3101
