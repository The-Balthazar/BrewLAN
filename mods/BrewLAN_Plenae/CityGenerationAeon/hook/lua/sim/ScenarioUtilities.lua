if rawget(_G, 'CityData') then
    table.insert(CityData,
        {   --Aeon
            BlueprintId = 'Aeon_SquareBlockCity',
            FunctionName = 'CreateSquareBlockCity',
            BlockDummy = 'zzcityblock9',
            BlockSpacing = {10,10},
            CityRadius = {6,12},
            Wall = 'uab5101',
            Turrets = {
                {'uab2101', Weight = 1 },
                {'uab2104', Weight = 1 },
            },
            T1AA = 'uab2104',
            T2AA = 'uab2204',
            T1PD = 'uab2101',
            TMD = 'uab4201',
            Power = {
                'uab1301',--65 + cities
                'uab1201',--13 + cities
                'sab1201',--7 + cities (if exists)
                'uab1101',
            },
            Structures3x3 = {
                {'uac1101', Weight = 1 },
                {'uac1201', Weight = 1 },
                {'uac1301', Weight = 1 },
                {'uac1501', Weight = 1 },
            },
            Structures7x7 = {
                {'uac1401', Weight = 4 },
                {'xac2201', Weight = 3 },
                {'uac1901', Weight = 1 },
            },
            LargeStructureBlocks = {3, 2}, -- a 3rd to half of all full blocks
            RoadPath = '/mods/BrewLAN_Plenae/CityGeneration/env/UEF/Decals/UEF_Road_Black_',
            RoadSize = 10.66,
            RoadLOD = 500,
            RoadTiles = {
                --left right up down 1 2 4 8
                --[['0000']] [ 0] = {0,       '0W_01'}, --0 road
                --[['0001']] [ 1] = {0,       '1W_01'}, --1 way down
                --[['0010']] [ 2] = {math.pi, '1W_01'}, --1 way up
                --[['0011']] [ 3] = {1.57,    '2WS_01'},--stright |
                --[['0100']] [ 4] = {1.57,    '1W_01'}, --1 way right?
                --[['0101']] [ 5] = {0,       '2WC_01'},--corner bottom right
                --[['0110']] [ 6] = {1.57,    '2WC_01'},--corner up right
                --[['0111']] [ 7] = {1.57,    '3W_01'}, --3 way right (no path left)
                --[['1000']] [ 8] = {-1.57,   '1W_01'}, --1 way left?
                --[['1001']] [ 9] = {-1.57,   '2WC_01'},--corner bottom left
                --[['1010']] [10] = {math.pi, '2WC_01'},--corner top left
                --[['1011']] [11] = {-1.57,   '3W_01'}, --3 way left (no path right)
                --[['1100']] [12] = {0,       '2WS_01'},--stright --
                --[['1101']] [13] = {0,       '3W_01'}, --3 way down (no path up)
                --[['1110']] [14] = {math.pi, '3W_01'}, --3 way up (no path down)
                --[['1111']] [15] = {0,       '4W_01'}, --4 way intersection
            },
            Streetlight = '/env/aeon/Props/aeon_street_light_prop.bp',
            Vehicles = {
                {'/env/aeon/props/aeon_car_01_prop.bp', Weight = 4 },
                {'/env/aeon/props/aeon_car_02_prop.bp', Weight = 3 },
                {'/env/aeon/props/aeon_bus_prop.bp', Weight = 1 },
            },
        }
    )
end
