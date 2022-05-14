if rawget(_G, 'CityData') then
    table.insert(CityData,
        {   --Cybran
            BlueprintId = 'Cybran_SquareBlockCity',
            FunctionName = 'CreateSquareBlockCity',
            BlockDummy = 'zzcityblock9',
            BlockSpacing = {10,10},
            CityRadius = {6,12},
            Wall = 'urb5101',
            Turrets = {
                {'urb2101', Weight = 1 },
                {'urb2104', Weight = 1 },
            },
            T1AA = 'urb2104',
            T2AA = 'urb2204',
            T1PD = 'urb2101',
            TMD = 'urb4201',
            Power = {
                'urb1301',--65 + cities
                'urb1201',--13 + cities
                'srb1201',--7 + cities (if exists)
                'urb1101',
            },
            Structures3x3 = {
                {'urc1101', Weight = 4 },
                {'urc1201', Weight = 2 },
                {'urc1301', Weight = 2 },
                {'urc1501', Weight = 2 },
                {'urc1902', Weight = 1 },
            },
            Structures7x7 = {
                {'urc1401', Weight = 4 },
                {'urc1901', Weight = 3 },
                {'xrc2201', Weight = 1 },
            },
            LargeStructureBlocks = {5, 4}, -- a 6th to a 5th of all full blocks
            RoadPath = '/mods/BrewLAN_Plenae/CityGeneration/env/cybran/Decals/tech',
            RoadSize = 10.66,
            RoadLOD = 500,
            RoadTiles = {
                --left right up down 1 2 4 8
                --[['0000']] [ 0] = {0,       ''}, --0 road
                --[['0001']] [ 1] = {0,       ''}, --1 way down
                --[['0010']] [ 2] = {math.pi, ''}, --1 way up
                --[['0011']] [ 3] = {1.57,    ''},--stright |
                --[['0100']] [ 4] = {1.57,    ''}, --1 way right?
                --[['0101']] [ 5] = {0,       ''},--corner bottom right
                --[['0110']] [ 6] = {1.57,    ''},--corner up right
                --[['0111']] [ 7] = {1.57,    ''}, --3 way right (no path left)
                --[['1000']] [ 8] = {-1.57,   ''}, --1 way left?
                --[['1001']] [ 9] = {-1.57,   ''},--corner bottom left
                --[['1010']] [10] = {math.pi, ''},--corner top left
                --[['1011']] [11] = {-1.57,   ''}, --3 way left (no path right)
                --[['1100']] [12] = {0,       ''},--stright --
                --[['1101']] [13] = {0,       ''}, --3 way down (no path up)
                --[['1110']] [14] = {math.pi, ''}, --3 way up (no path down)
                --[['1111']] [15] = {0,       ''}, --4 way intersection
            },
            Streetlight = '/env/cybran/Props/Cybran_Street_Light_prop.bp',
            Vehicles = {
                {'/env/cybran/props/Cybran_Car_prop.bp', Weight = 2 },
                {'/env/cybran/props/Cybran_Bus_prop.bp', Weight = 1 },
                {'/env/cybran/props/Cybran_Car2_prop.bp', Weight = 2 },
            }
        }
    )
end
