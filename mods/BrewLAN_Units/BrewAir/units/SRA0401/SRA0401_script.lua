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
        unitBuilding:AttachTo(self, 0)
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        CAirUnit.OnStopBuild(self, unitBeingBuilt)
        unitBeingBuilt:DetachFrom(true)
        self:RequestRefreshUI()
    end,
}

TypeClass = URA0401
