#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB3202/UAB3202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Long Range Sonar Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SSonarUnit = import('/lua/seraphimunits.lua').SSonarUnit

SSS0305 = Class(SSonarUnit) {
    TimedSonarTTIdleEffects = {
        {
            Bones = {
                0,
            },
            Type = 'SonarBuoy01',
        },
    },
}

TypeClass = SSS0305
