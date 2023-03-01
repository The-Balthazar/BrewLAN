do
    local NewDummies = {}

    local function GetFoot(bp, axe) return math.ceil(bp.Footprint and bp.Footprint[axe] or bp[axe] or 1) end
    local function GetSkirt(bp, axe) return math.max((bp.Physics and bp.Physics['Skirt'..axe] or 1), GetFoot(bp, axe)) end
    local function GetOffset(bp, axe) return (bp.Physics and bp.Physics['SkirtOffset'..axe] or 0) end

    local function ReduceFoot(val)
        local modded = math.mod(val, 2)
        return modded == 0 and 2 or modded
    end

    local function NewOffset(offset, foot, reduced)
        return offset-(foot-reduced)/2
    end

    local nilMeshPath = '/mods/brewlan/meshes/nil_mesh'
    local function FindNilMesh(meshes)
        for id, bp in pairs(meshes) do
            if id:sub(-9) == '/nil_mesh' then
                nilMeshPath = id
                return
            end
        end
    end

    local function ModUnits(all_bps)
        for id, bp in pairs(all_bps) do
            if bp.Categories and not table.find(bp.Categories, 'DRAGBUILD') then
                table.insert(bp.Categories, 'DRAGBUILD')
            end
            if bp.Physics and bp.Physics.MotionType ~= 'RULEUMT_Air' then
                local FootX, FootZ = GetFoot(bp, 'SizeX'), GetFoot(bp, 'SizeZ')
                local SkirtX, SkirtZ = GetSkirt(bp, 'SizeX'), GetSkirt(bp, 'SizeZ')
                local ReducedFootX, ReducedFootZ = ReduceFoot(FootX), ReduceFoot(FootZ)

                local SOffsetX, SOffsetZ = NewOffset(GetOffset(bp, 'X'), FootX, ReducedFootX), NewOffset(GetOffset(bp, 'Z'), FootZ, ReducedFootZ)

                local DummyID = 'spawn_dummy_'..SkirtX..SkirtZ..'_'..SOffsetX..SOffsetZ..'_'..ReducedFootX..ReducedFootZ


                if not NewDummies[DummyID] then
                    NewDummies[DummyID] = {
                        BlueprintId = DummyID,
                        Categories = {
                            'DRAGBUILD',
                            'UNSPAWNABLE',
                        },
                        Display = {
                            BuildMeshBlueprint = nilMeshPath,
                            MeshBlueprint = nilMeshPath,
                            UniformScale = 0,
                            HideLifebars = true,
                        },
                        Physics = {
                            SkirtOffsetX = SOffsetX,
                            SkirtOffsetZ = SOffsetZ,
                            SkirtSizeX = SkirtX,
                            SkirtSizeZ = SkirtZ,
                            MotionType = 'RULEUMT_Air',
                            MaxSpeed = 0.5,
                        },
                        --ScriptClass = 'BrewLANFootprintDummyUnit',
                        --ScriptModule = '/lua/defaultunits.lua',
                        SizeX = ReducedFootX,
                        SizeY = 1,
                        SizeZ = ReducedFootZ,
                        Source = bp.Source,
                    }
                end
                bp.SpawnDummyId = DummyID
            else
                bp.SpawnDummyId = id -- Aircraft can be themselves.
            end
        end
        for id, bp in NewDummies do
            all_bps[id] = bp
        end
    end

    local OldModBlueprints = ModBlueprints

    function ModBlueprints(all_blueprints)
        OldModBlueprints(all_blueprints)
        FindNilMesh(all_blueprints.Mesh)
        ModUnits(all_blueprints.Unit)
    end

end
