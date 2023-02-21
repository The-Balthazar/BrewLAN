local CAirUnit = import('/lua/cybranunits.lua').CAirUnit

URA0401 = Class(CAirUnit) {
    MovementAmbientExhaustBones = {
		'Exhaust_001',
        'Exhaust_002',
        'Exhaust_003',
        'Exhaust_004',
        'Exhaust_005',
        'Exhaust_006',
        'Exhaust_007',
        'Exhaust_008',
    },

    OnStartBuild = function(self, unitBuilding, order)
        CAirUnit.OnStartBuild(self, unitBuilding, order)
        local ubp = unitBuilding:GetBlueprint()
        if ubp.Physics.MotionType == 'RULEUMT_Air' and ubp.Transport.TransportClass == 5 then
            unitBuilding:AttachTo(self, 0)
        end
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        CAirUnit.OnStopBuild(self, unitBeingBuilt)
        unitBeingBuilt:DetachFrom(true)
        self:RequestRefreshUI()
    end,
}

TypeClass = URA0401
