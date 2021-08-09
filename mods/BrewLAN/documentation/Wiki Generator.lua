--------------------------------------------------------------------------------
-- Supreme Commander mod automatic unit wiki generation script for Github wikis
-- By Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
dofile(string.sub(debug.getinfo(1).source, 2, -14)..'Inputs.lua')
dofile(string.sub(debug.getinfo(1).source, 2, -14)..'Utils.lua')

local sidebarData = {}
local categoryData = {}

--------------------------------------------------------------------------------

function LoadModFilesMakeUnitPagesGatherData(ModDirectory, modsidebarindex)

    local modinfo = {}
    do
        local pass, msg = pcall(dofile, ModDirectory..'/mod_info.lua')
        assert(pass, 'mod_info.lua not found')
        modinfo.name = name
        modinfo.description = description
        modinfo.author = author
        modinfo.version = version
        modinfo.icon = icon and true -- A bool because I'm not committing to the dir structure of the mod(s) for the wiki files.
    end

    print('Locating blueprints in '..modinfo.name)

    local BlueprintPathsArray = {}
    do
        local dirsearch
        dirsearch = function(dir, p)
            for line in io.popen('dir "'..dir..'" /b '..(p or '')):lines() do
                if string.sub(line, 1, 1) ~= '.' then -- filter out .git and other .folders
                    if string.sub(line,-8,-1) == '_unit.bp'
                    and string.upper(string.sub(line,1,1)) ~= 'Z' then
                        table.insert(BlueprintPathsArray, {dir,line})
                    else
                        dirsearch(dir..'/'..line)
                    end
                end
            end
        end

        dirsearch(ModDirectory.."/units", '/ad')
        assert(#BlueprintPathsArray > 0, 'No unit blueprints found')
        print("Found "..#BlueprintPathsArray.." blueprint files")
    end

    ----------------------------------------------------------------------------

    for name, filedir in pairs({
        ['Build descriptions'] = '/hook/lua/ui/help/unitdescription.lua',
           ['US localisation'] = '/hook/loc/US/strings_db.lua',
                  ['Tooltips'] = '/hook/lua/ui/help/tooltips.lua',
    }) do
        local pass, mgs = pcall(dofile, ModDirectory..filedir)
        print( (pass and 'Loaded: ' or 'Not found: ') .. name)
    end

    print("Creating wiki pages")

    for i, fdir in ipairs(BlueprintPathsArray) do
        local bp
        ----------------------------------------------------------------------------
        UnitBlueprint = function(a) bp = a end
        Sound = function(a) return a end
        ----------------------------------------------------------------------------
        local pass, msg = pcall(dofile, fdir[1]..'/'..fdir[2])
        if not pass then
            print(msg)--else print(bp)
        end
        ----------------------------------------------------------------------------
        --local bp = all_bps[fdir[2]]
        local bpid = string.sub(fdir[2],1,-9)
        print(bpid)
        ----------------------------------------------------------------------------

        local unitTdesc = LOC(bp.Description)
        local unitTlevel

        if arrayfind(bp.Categories, 'EXPERIMENTAL') then
            unitTlevel = 'Experimental'
        else
            for i = 1, 3 do
                if arrayfind(bp.Categories, 'TECH'..i) then
                    unitTlevel = 'Tech '..i
                    unitTdesc = unitTlevel..' '..LOC(bp.Description)
                    break
                end
            end
        end

        ------------------------------------------------------------------------

        local infoboxdata = {
            {'', "Note: Several units have stats defined at the<br />start of the game based on the stats of others."},
            {'Source:', '<a href="'..stringSanitiseFile(modinfo.name)..'">'..modinfo.name..'</a>'},
            {'Unit ID:', '<code>'..string.lower(bpid)..'</code>',},
            {'Faction:', (bp.General and bp.General.FactionName)},
            {''},
            {'Health:',
                (
                    not arrayfind(bp.Categories, 'INVULNERABLE')
                    and iconText(
                        'Health',
                        bp.Defense.MaxHealth,
                        (bp.Defense.RegenRate and ' (+'..bp.Defense.RegenRate ..'/s)')
                    )
                    or 'Invulnerable'
                )
            },
            {'Armour:', (not arrayfind(bp.Categories, 'INVULNERABLE') and bp.Defense.ArmorType and '<code>'..bp.Defense.ArmorType..'</code>')},
            {'Shield health:',
                iconText(
                    'Shield',
                    bp.Defense.Shield and bp.Defense.Shield.ShieldMaxHealth,
                    (bp.Defense.Shield and bp.Defense.Shield.ShieldRegenRate and ' (+'..bp.Defense.Shield.ShieldRegenRate..'/s)')
                )
            },
            {'Shield radius:', (bp.Defense.Shield and bp.Defense.Shield.ShieldSize)},
            {'Flags:',
                (
                    arrayfind(bp.Categories, 'UNTARGETABLE') or
                    (arrayfind(bp.Categories, 'UNSELECTABLE') or not arrayfind(bp.Categories, 'SELECTABLE') ) or
                    (bp.Display and bp.Display.HideLifebars or bp.LifeBarRender == false) or
                    (bp.Defense and bp.Defense.Shield and (bp.Defense.Shield.AntiArtilleryShield or bp.Defense.Shield.PersonalShield))
                ) and
                (arrayfind(bp.Categories, 'UNTARGETABLE') and 'Untargetable<br />' or '')..
                ( (arrayfind(bp.Categories, 'UNSELECTABLE') or not arrayfind(bp.Categories, 'SELECTABLE') ) and 'Unselectable<br />' or '')..
                ((bp.Display and bp.Display.HideLifebars or bp.LifeBarRender == false) and 'Lifebars hidden<br />' or '' )..
                (bp.Defense and bp.Defense.Shield and bp.Defense.Shield.AntiArtilleryShield and 'Artillery shield<br />' or '')..
                (bp.Defense and bp.Defense.Shield and bp.Defense.Shield.PersonalShield and 'Personal shield<br />' or '')
            },
            {''},
            {'Energy cost:', iconText('Energy', bp.Economy and bp.Economy.BuildCostEnergy)},
            {'Mass cost:', iconText('Mass', bp.Economy and bp.Economy.BuildCostMass)},
            {'Build time:', iconText('Time-but-not', bp.Economy and bp.Economy.BuildTime, arraySubfind(bp.Categories, 'BUILTBY') and ' (<a href="#construction">Details</a>)' or '' )}, --I don't like the time icon for this, it looks too much and it's also not in real units
            {'Maintenance cost:', iconText('Energy', bp.Economy and bp.Economy.MaintenanceConsumptionPerSecondEnergy,'/s')},
            --{''},
            {'Build rate:', iconText('Build', bp.Economy and bp.Economy.BuildRate)},
            {'Energy production:', iconText('Energy', bp.Economy and bp.Economy.ProductionPerSecondEnergy, '/s')},
            {'Mass production:', iconText('Mass', bp.Economy and bp.Economy.ProductionPerSecondMass, '/s')},
            {'Energy storage:', iconText('Energy', bp.Economy and bp.Economy.StorageEnergy)},
            {'Mass storage:', iconText('Mass', bp.Economy and bp.Economy.StorageMass)},
            {''},
            {'Vision radius:', (bp.Intel and bp.Intel.VisionRadius or 10)},
            {'Water vision radius:', (bp.Intel and bp.Intel.WaterVisionRadius or 10)},
            {'Radar radius:', (bp.Intel and bp.Intel.RadarRadius)},
            {'Sonar radius:', (bp.Intel and bp.Intel.SonarRadius)},
            {'Omni radius:', (bp.Intel and bp.Intel.OmniRadius)},
            {'Jammer blips (radii):',
                (bp.Intel and bp.Intel.JamRadius)
                and
                (bp.Intel.JammerBlips or 0)..' ('..
                (bp.Intel.JamRadius.Min)..'‒'..
                (bp.Intel.JamRadius.Max)..')'
            },
            {'Cloak radius:', (bp.Intel and bp.Intel.CloakFieldRadius)},
            {'Radar stealth radius:', (bp.Intel and bp.Intel.RadarStealthFieldRadius)},
            {'Sonar stealth radius:', (bp.Intel and bp.Intel.SonarStealthFieldRadius)},
            {'Flags:',
                (bp.Intel and (bp.Intel.Cloak or bp.Intel.RadarStealth or bp.Intel.SonarStealth))
                and
                (bp.Intel.Cloak and 'Cloak<br />' or '')..
                (bp.Intel.RadarStealth and 'Radar stealth<br />' or '')..
                (bp.Intel.SonarStealth and 'Sonar stealth<br />' or '')
            },
            {''},
            {'Motion type:', bp.Physics.MotionType and ('<code>'..bp.Physics.MotionType..'</code>')},
            {'Buildable layers:', (bp.Physics.MotionType == 'RULEUMT_None') and BuildableLayer(bp.Physics)},
            {'Movement speed:', (bp.Air and bp.Air.MaxAirspeed or bp.Physics.MaxSpeed)},
            {'Fuel:', (bp.Physics.FuelUseTime and iconText('Fuel', string.format('%02d:%02d', math.floor(bp.Physics.FuelUseTime/60), math.floor(bp.Physics.FuelUseTime % 60)), '') )},
            {'Elevation:', (bp.Air and bp.Physics.Elevation)},
            {'Transport class:', (
                (
                    bp.Physics.MotionType ~= 'RULEUMT_None' and (
                        bp.General and bp.General.CommandCaps and (
                            bp.General.CommandCaps.RULEUCC_CallTransport or bp.General.CommandCaps.RULEUCC_Dock
                        )
                    )
                ) and iconText('Attached',
                    bp.Transport and bp.Transport.TransportClass or 1
                )
            ), 'The space this occupies on transports or on air staging. No units can accommodate greater than class 3.'},
            {'Class 1 capacity:', iconText('Attached', bp.Transport and bp.Transport.Class1Capacity), 'The number of class 1 units this can carry. For class 2 and 3 estimates, half or quarter this number; actual numbers will vary on how the attach points are arranged.'},
            {''},
            {'Misc radius:', arrayfind(bp.Categories, 'OVERLAYMISC') and bp.AI and bp.AI.StagingPlatformScanRadius, 'Defined by the air staging radius value. Often used to indicate things without a dedicated range rings.' },
            {'Weapons:', bp.Weapon and #bp.Weapon..' (<a href="#weapons">Details</a>)'},
        }

        ------------------------------------------------------------------------

        local infoboxstring = InfoboxHeader(
            'main-right',
            string.format(
                '<img align="left" title="%s unit icon" src="%s_icon.png" />%s<br />%s',
                (LOC(bp.General.UnitName) or 'The'),
                unitIconRepo..bpid,
                (LOC(bp.General.UnitName) or '<i>Unnamed</i>'),
                (unitTdesc or [[<i>No description</i>]])
            )
        )

        for i, field in ipairs(infoboxdata) do
            local irowstring = InfoboxRow(field[1], field[2], field[3])

            if irowstring then
                infoboxstring = infoboxstring .. irowstring
            end
        end

        infoboxstring = infoboxstring .. InfoboxEnd('main-right')

        ------------------------------------------------------------------------

        local headerstring = (bp.General.UnitName and '"'..LOC(bp.General.UnitName)..'": ' or '')..unitTdesc.."\n----\n"

        ------------------------------------------------------------------------

        local bodytext = (bp.General.UnitName and '"'..LOC(bp.General.UnitName)..'" is a'
        or 'This unamed unit is a')..(bp.General and bp.General.FactionName == 'Aeon' and 'n ' or ' ') -- a UEF, an Aeon ect.
        ..(bp.General and bp.General.FactionName..' ')..(bp.Physics.MotionType and motionTypes[bp.Physics.MotionType][1] or 'structure')..' unit included in *'..modinfo.name.."*.\n"
        ..(unitTdesc and 'It is classified as a '..string.lower(unitTdesc) or 'It is an unclassified'..(unitTlevel and ' '..string.lower(unitTlevel) ) )..' unit'..(not unitTlevel and ' with no defined tech level' or '')..'.'

        if Description[string.lower(bpid)] then
            if arraySubfind(bp.Categories, 'BUILTBY') then
                bodytext = bodytext.."\nThe build description for this unit is:\n\n<blockquote>"..LOC(Description[string.lower(bpid)]).."</blockquote>\n"
            else
                bodytext = bodytext.."\nThis unit has no defined build categories, however the build description for it is:\n\n<blockquote>"..LOC(Description[string.lower(bpid)]).."</blockquote>\n"
            end
        else
            if arraySubfind(bp.Categories, 'BUILTBY') then
                bodytext = bodytext.." It has no defined build description.\n"
            else
                bodytext = bodytext.." It has no defined build description, and no build categories.\n"
            end
        end

        ------------------------------------------------------------------------
        -- Body content
        ------------------------------------------------------------------------

        local BodyTextSections = {
            {
                'Abilities',
                check = bp.Display and bp.Display.Abilities and #bp.Display.Abilities > 0,
                Data = function()
                    bodytext = bodytext.."Hover over abilities to see effect descriptions.\n"
                    for i, ability in ipairs(bp.Display.Abilities) do
                        bodytext = bodytext.."\n* "..abilityTitle(LOC(ability))
                    end
                end
            },
            {
                'Adjacency',
                check = arraySubfind(bp.Categories, 'SIZE') or bp.Adjacency,
                Data = function()
                    local sizecat = arraySubfind(bp.Categories, 'SIZE')
                    local sizecatno = sizecat and tonumber(string.sub(sizecat,5))

                    local sizeX = math.max(bp.Footprint and bp.Footprint.SizeX or bp.SizeX or 1, bp.Physics.SkirtSizeX or 0)
                    if math.floor(bp.Physics.SkirtOffsetX or 0) ~= (bp.Physics.SkirtOffsetX or 0) - 0.5 then sizeX = sizeX - 1 end
                    sizeX = math.floor(sizeX / 2) * 2

                    local sizeZ = math.max(bp.Footprint and bp.Footprint.SizeZ or bp.SizeZ or 1, bp.Physics.SkirtSizeZ or 0)
                    if math.floor(bp.Physics.SkirtOffsetZ or 0) ~= (bp.Physics.SkirtOffsetZ or 0) - 0.5 then sizeZ = sizeZ - 1 end
                    sizeZ = math.floor(sizeZ / 2) * 2

                    local actualsize = math.max(2, sizeX) + math.max(2, sizeZ)

                    bodytext = bodytext..(sizecat and "This unit counts as `"..
                    sizecat.."` for adjacency effects from other structures. This theoretically means that it can be surrounded by exactly "..
                    string.sub(sizecat,5).." structures the size of a standard tech 1 power generator"..(
                    actualsize and (
                        actualsize == sizecatno
                        and ', which is accurate; meaning it can get the maximum intended buff effects'
                        or actualsize > sizecatno
                        and ', however it is actually larger; meaning it receives '..string.format('%.1f', (actualsize / sizecatno - 1) * 100)..'% better buffs than would normally be afforded it'
                        or actualsize < sizecatno
                        and ', however it is actually smaller; meaning it receives '..string.format('%.1f', (1 - actualsize / sizecatno) * 100)..'% weaker buffs than a standard structure of the same skirt size'
                    ) or '')..'. ' or '')

                    if bp.Adjacency then
                        bodytext = bodytext..[[The adjacency bonus `]]..bp.Adjacency..[[` is given by this unit.]]
                    end
                end
            },
            {
                'Construction',
                check = arraySubfind(bp.Categories, 'BUILTBY'),
                Data = function()
                    bodytext = bodytext.."The estimated build times for this unit on the Steam/retail version of the game are as follows; Note: This only includes hard-coded builders; some build categories are generated on game launch."..BuilderList(bp)
                end
            },
            {
                'Order capabilities',
                check = bp.General and ( CheckCaps(bp.General.CommandCaps) or CheckCaps(bp.General.ToggleCaps) ),
                Data = function()
                    local ordersarray = {}
                    for i, hash in ipairs({bp.General.CommandCaps or {}, bp.General.ToggleCaps or {}}) do
                        for order, val in pairs(hash) do
                            if val then
                                table.insert(ordersarray, order)
                            end
                        end
                    end
                    table.sort(ordersarray, function(a, b) return (defaultOrdersTable[a].preferredSlot or 99) < (defaultOrdersTable[b].preferredSlot or 99) end)

                    bodytext = bodytext.."The following orders can be issued to the unit:\n<table>\n"
                    local slot = 99
                    for i, v in ipairs(ordersarray) do
                        local orderstring, order = orderButtonImage(v, bp.General.OrderOverrides)
                        if order then
                            if (slot <= 6 and order.preferredSlot >= 7) then
                                bodytext = bodytext.."<tr>\n"
                            end
                            slot = order.preferredSlot
                        end
                        bodytext = bodytext .. "<td>"..orderstring.."</td>\n"
                    end
                    bodytext = bodytext .."</table>"
                end
            },
            {
                'Engineering',
                check = bp.Economy and bp.Economy.BuildRate and
                (
                    bp.Economy.BuildableCategory or bp.General and bp.General.CommandCaps and
                    (
                        bp.General.CommandCaps.RULEUCC_Capture or
                        bp.General.CommandCaps.RULEUCC_Reclaim or
                        bp.General.CommandCaps.RULEUCC_Repair or
                        bp.General.CommandCaps.RULEUCC_Sacrifice
                    )
                ),
                Data = function()
                    local eng = {}
                    if bp.General and bp.General.CommandCaps then
                        local eng2 = {
                            {'capture', bp.General.CommandCaps.RULEUCC_Capture},
                            {'reclaim', bp.General.CommandCaps.RULEUCC_Reclaim},
                            {'repair', bp.General.CommandCaps.RULEUCC_Repair},
                            {'sacrifice', bp.General.CommandCaps.RULEUCC_Sacrifice},
                        }
                        for i, v in ipairs(eng2) do
                            if v[2] then
                                table.insert(eng, v)
                            end
                        end
                    end
                    if #eng > 0 then
                        bodytext = bodytext..'The engineering capabilties of this unit consist of the ability to '
                        for i = 1, #eng do
                            bodytext = bodytext..eng[i][1]
                            if i < #eng then
                                bodytext = bodytext..', '
                            end
                            if i + 1 == #eng then
                                bodytext = bodytext..'and '
                            end
                            if i == #eng then
                                bodytext = bodytext..".\n"
                            end
                        end
                    end

                    if bp.Economy.BuildableCategory then
                        if #bp.Economy.BuildableCategory == 1 then
                            bodytext = bodytext..'It has the build category <code>'..bp.Economy.BuildableCategory[1].."</code>.\n"
                        elseif #bp.Economy.BuildableCategory > 1 then
                            bodytext = bodytext.."It has the build categories:\n"
                            for i, cat in ipairs(bp.Economy.BuildableCategory) do
                                bodytext = bodytext.."* <code>"..cat.."</code>\n"
                            end
                        end
                    end
                end
            },
            {
                'Enhancements',
                check = bp.Enhancements,
                Data = function()
                    local EnhacementsSorted = {}
                    for key, enh in pairs(bp.Enhancements) do
                        local SearchForRquisits
                        SearchForRquisits = function(enhancements, req)
                            for key, enh in pairs(enhancements) do
                                if req == enh.Prerequisite then
                                    table.insert(EnhacementsSorted, {key, enh})
                                    SearchForRquisits(enhancements, key)
                                end
                            end
                        end
                        if not enh.Prerequisite then
                            table.insert(EnhacementsSorted, {key, enh})
                            SearchForRquisits(bp.Enhancements, key)
                        end
                    end
                    for i, enh in ipairs(EnhacementsSorted) do
                        local key = enh[1]
                        local enh = enh[2]
                        if key ~= 'Slots' and string.sub(key, -6, -1) ~= 'Remove' then
                            bodytext = bodytext..InfoboxHeader('detail-left', (enh.Name and LOC(enh.Name) or 'error:name') )
                            ..InfoboxRow('Description:', (LOC(Description[string.lower(bpid..'-'..enh.Icon)]) or 'error:description') )
                            ..InfoboxRow('Energy cost:', iconText('Energy', enh.BuildCostEnergy or 'error:energy') )
                            ..InfoboxRow('Mass cost:', iconText('Mass', enh.BuildCostMass or 'error:mass') )
                            ..InfoboxRow('Build time:', iconText('Time', enh.BuildTime and bp.Economy and bp.Economy.BuildRate and math.ceil(enh.BuildTime / bp.Economy.BuildRate) or 'error:time').." seconds" )
                            ..InfoboxRow('Prerequisite:', (enh.Prerequisite and LOC(bp.Enhancements[enh.Prerequisite].Name) or 'None') )
                            ..InfoboxEnd('detail-left')
                        end
                    end
                end
            },
            {
                'Weapons',
                check = bp.Weapon,
                Data = function()
                    local compiledWeaponsTable = {}

                    for i, wep in ipairs(bp.Weapon) do
                        weapontable = {}
                        table.insert(weapontable, {'Target type:', WepTarget(wep, bp)})
                        table.insert(weapontable, {'DPS estimate:', DPSEstimate(wep, bp), "Note: This only counts listed stats."})
                        table.insert(weapontable, {
                            'Damage:',
                            (wep.NukeInnerRingDamage or wep.Damage),
                            ( not (IsDeathWeapon(wep) and not wep.FireOnDeath) and "Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.")
                        })
                        table.insert(weapontable, {'Damage to shields:', (wep.DamageToShields or wep.ShieldDamage) })
                        table.insert(weapontable, {'Damage radius:', (wep.NukeInnerRingRadius or wep.DamageRadius)})
                        table.insert(weapontable, {'Outer damage:', wep.NukeOuterRingDamage})
                        table.insert(weapontable, {'Outer radius:', wep.NukeOuterRingRadius})
                        do
                            local s = WepProjectiles(wep, bp)
                            if s and s > 1 then
                                if wep.BeamCollisionDelay then
                                    s = tostring(s)..' beams'
                                else
                                    s = tostring(s)..' projectiles'
                                end
                            else
                                s = ''
                            end
                            local dot = wep.DoTPulses
                            if dot and dot > 1 then
                                if s ~= '' then
                                    s = s..'<br />'
                                end
                                s = s..dot.. ' DoT pulses'
                            end
                            if (wep.BeamLifetime and wep.BeamLifetime > 0) and wep.BeamCollisionDelay then
                                if s ~= '' then
                                    s = s..'<br />'
                                end
                                s = math.ceil( (wep.BeamLifetime or 1) / (wep.BeamCollisionDelay + 0.1) )..' beam collisions'
                            end
                            if s == '' then s = nil end
                            table.insert(weapontable, {'Damage instances:', s})
                        end
                        table.insert(weapontable, {'Damage type:', wep.DamageType and '<code>'..wep.DamageType..'</code>'})
                        table.insert(weapontable, {'Max range:', not IsDeathWeapon(wep) and wep.MaxRadius})
                        table.insert(weapontable, {'Min range:', wep.MinRadius})
                        if not IsDeathWeapon(wep) and wep.RateOfFire and not (wep.BeamLifetime == 0 and wep.BeamCollisionDelay) then
                            table.insert(weapontable, {
                                'Firing cycle:',
                                ('Once every '..tostring(math.floor(10 / wep.RateOfFire + 0.5)/10)..'s' ),
                                "Note: This doesn't count additional delays such as charging, reloading, and others."
                            })
                        elseif not IsDeathWeapon(wep) and (wep.BeamLifetime == 0 and wep.BeamCollisionDelay) then
                            table.insert(weapontable, {
                                'Firing cycle:',
                                'Continuous beam<br />Once every '..((wep.BeamCollisionDelay or 0) + 0.1)..'s',
                                'How often damage instances occur.'
                            })
                        end
                        table.insert(weapontable, {'Firing cost:',
                            iconText(
                                'Energy',
                                wep.EnergyRequired and wep.EnergyRequired ~= 0 and
                                (
                                    wep.EnergyRequired ..
                                        (wep.EnergyDrainPerSecond and ' ('..wep.EnergyDrainPerSecond..'/s for '..(math.ceil((wep.EnergyRequired/wep.EnergyDrainPerSecond)*10)/10)..'s)' or '')
                                    )
                                )
                            }
                        )
                        table.insert(weapontable, {'Flags:', (wep.ArtilleryShieldBlocks and 'Artillery <span title="Blocked by artillery shield">(<u>?</u>)</span>' or nil)})
                        table.insert(weapontable, {'Projectile storage:', (wep.MaxProjectileStorage and (wep.InitialProjectileStorage or 0)..'/'..(wep.MaxProjectileStorage) )})
                        if wep.Buffs then
                            local buffs = ''
                            for i, buff in ipairs(wep.Buffs) do
                                if buff.BuffType then
                                    if buffs ~= '' then
                                        buffs = buffs..'<br />'
                                    end
                                    buffs = buffs..'<code>'..buff.BuffType..'</code>'
                                end
                            end
                            if buffs == '' then
                                buffs = nil
                            end
                            table.insert(weapontable, {'Buffs:', buffs})
                        end

                        local CWTn = #compiledWeaponsTable
                        if compiledWeaponsTable[1] and arrayequal(compiledWeaponsTable[CWTn][3], weapontable) then
                            compiledWeaponsTable[CWTn][2] = compiledWeaponsTable[CWTn][2] + 1
                        else
                            table.insert(compiledWeaponsTable, {(wep.DisplayName or wep.Label or '<i>Dummy Weapon</i>'), 1, weapontable})
                        end

                    end

                    for i, wepdata in ipairs(compiledWeaponsTable) do
                        local weapontable = wepdata[3]
                        bodytext = bodytext..InfoboxHeader('detail-left', wepdata[1]..(wepdata[2] == 1 and '' or ' (×'..tostring(wepdata[2])..')') )

                        if wepdata[2] ~= 1 then
                            bodytext = bodytext..InfoboxRow('', 'Note: Stats are per instance of the weapon.')
                        end

                        for i, data in ipairs(weapontable) do
                            if data[2] then
                                bodytext = bodytext..InfoboxRow(data[1], data[2], data[3])
                            end
                        end
                        bodytext = bodytext..InfoboxEnd('detail-left')
                    end
                end
            },
            {
                'Veteran levels',
                check = bp.Veteran and bp.Veteran.Level1,
                Data = function()
                    if not bp.Weapon or (bp.Weapon and #bp.Weapon == 1 and IsDeathWeapon(bp.Weapon[1])) then
                        bodytext = bodytext .. "This unit has defined veteran levels, despite not having any weapons. Other effects can still give experience towards those levels though, which are as follows; note they replace each other by default:\n"
                    else
                        bodytext = bodytext .. "Note: Each veteran level buff replaces the previous by default; values are shown here as written.\n"
                    end

                    for i = 1, 5 do
                        local lev = 'Level'..i
                        if bp.Veteran[lev] then
                            bodytext = bodytext .. "\n"..i..'. '..bp.Veteran[lev]..' kills gives: '..iconText('Health', bp.Defense and bp.Defense.MaxHealth and '+'..(bp.Defense.MaxHealth / 10 * i) )
                            for buffname, buffD in pairs(bp.Buffs) do
                                if buffD[lev] then
                                    if buffname == 'Regen' then
                                        bodytext = bodytext..' (+'..buffD[lev]..'/s)'
                                    else
                                        bodytext = bodytext..' '..buffname..': '..buffD[lev]
                                    end
                                end
                            end
                        end
                    end
                end
            },
        }

        ------------------------------------------------------------------------
        -- Table of contents
        ------------------------------------------------------------------------

        do
            local sections = 0

            for i, v in ipairs(BodyTextSections) do
                if v.check then
                    sections = sections + 1
                end
            end

            if sections >= 3 then
                bodytext = bodytext .. "\n<details>\n<summary>Contents</summary>\n\n"
                local index = 0
                for i, v in ipairs(BodyTextSections) do
                    if v.check then
                        index = index + 1
                        bodytext = bodytext .. index..". – <a href=#" .. string.lower(string.gsub(v[1], ' ', '-')).." >"..v[1].."</a>\n"
                    end
                end
                bodytext = bodytext .. "</details>\n"
            end
        end

        ------------------------------------------------------------------------
        -- Assemble body content sections
        ------------------------------------------------------------------------

        for i, sectionData in ipairs(BodyTextSections) do
            if sectionData.check then
                bodytext = bodytext..MDHead(sectionData[1])
                sectionData.Data()
                bodytext = bodytext.."\n"
            end
        end

        ------------------------------------------------------------------------

        local UnitInfo = {
            bpid = bpid,
            name = LOC(bp.General.UnitName),
            desc = unitTdesc,
        }

        ------------------------------------------------------------------------

        local categoriesForFooter = {
            'UEF',
            'AEON',
            'CYBRAN',
            'SERAPHIM',

            'TECH1',
            'TECH2',
            'TECH3',
            'EXPERIMENTAL',

            'MOBILE',

            'ANTIAIR',
            'ANTINAVY',

            'AIR',
            'LAND',
            'NAVAL',

            'HOVER',

            'ECONOMIC',

            'SHIELD',
            'BOMBER',
            'TORPEDOBOMBER',
            'MINE',
            'COMMAND',
            'SUBCOMMANDER',
            'ENGINEER',
            'FIELDENGINEER',
            'SILO',
            'FACTORY',
            'ARTILLERY',

            'STRUCTURE',
        }

        bodytext = bodytext.."\n<table align=center>\n<td>Categories : "

        local cattext = ''

        for i, cat in ipairs(categoriesForFooter) do
            if arrayfind(bp.Categories, cat) then

                if not categoryData[cat] then
                    categoryData[cat] = {}
                end

                table.insert(categoryData[cat], {UnitInfo = UnitInfo, modinfo = modinfo})

                if cattext ~= '' then
                    cattext = cattext..' · '
                end

                cattext = cattext..'<a href="_categories.'..cat..'">'..cat..'</a>'
            end
        end

        ------------------------------------------------------------------------

        local md = io.open(WikiRepoDir..'/'..bpid..'.md', "w")
        md:write(headerstring..infoboxstring..bodytext..cattext.."\n")
        md:close()

        ------------------------------------------------------------------------
        -- Sidebar stuff
        ------------------------------------------------------------------------

        if not sidebarData[modsidebarindex] then
            sidebarData[modsidebarindex] = {modinfo = modinfo, [2] = {} }
        end

        local faction = FactionIndexes[bp.General and bp.General.FactionName] or 5

        if not sidebarData[modsidebarindex][2][faction] then
            sidebarData[modsidebarindex][2][faction] = {}
        end

        table.insert(sidebarData[modsidebarindex][2][faction], {bpid, LOC(bp.General.UnitName) or bpid, unitTdesc or bpid})


    end

    print("Complete")

end

--------------------------------------------------------------------------------
-- ACTUALLY DO THE THING

for i, dir in ipairs(ListOfModDirectories) do
    local suc, msg = pcall(LoadModFilesMakeUnitPagesGatherData, dir, i)
    if not suc then print(msg); break end
end

--------------------------------------------------------------------------------
-- Do the sidebar stuff

do
    local suc, msg = pcall(function()
        print("starting sidebar stuff")

        local sortData = function(sorttable, sort)
            for modindex, moddata in ipairs(sorttable) do
                --local modname = moddata[1]
                for i = 1, 5 do--faction, unitarray in pairs(moddata[2]) do
                    local faction = FactionsByIndex[i]
                    local unitarray = moddata[2][i]
                    if unitarray then
                        table.sort(unitarray, function(a,b)
                            --return a[3] < b[3]
                            local g

                            if sort == 'TechDescending-DescriptionAscending' then
                                g = { ['Experi'] = 1, ['Tech 3'] = 2, ['Tech 2'] = 3, ['Tech 1'] = 4 }
                                return (g[string.sub(a[3], 1, 6)] or 5)..a[3] < (g[string.sub(b[3], 1, 6)] or 5)..b[3]

                            elseif sort == 'TechAscending-IDAscending' then
                                g = { ['Tech 1'] = 1, ['Tech 2'] = 2, ['Tech 3'] = 3, ['Experi'] = 4 }
                                return (g[string.sub(a[3], 1, 6)] or 5)..a[1] < (g[string.sub(b[3], 1, 6)] or 5)..b[1]

                            end
                        end)
                    end
                end
            end
        end

        sortData(sidebarData, 'TechDescending-DescriptionAscending')

        local sidebarstring = ''

        for modindex, moddata in ipairs(sidebarData) do
            local modname = moddata[1]

            sidebarstring = sidebarstring .. "<details markdown=\"1\">\n<summary>[Show] <a href=\""..stringSanitiseFile(moddata.modinfo.name)..[[">]]..moddata.modinfo.name.."</a></summary>\n<p>\n<table>\n<tr>\n<td>\n\n"
            for i = 1, 5 do--faction, unitarray in pairs(moddata[2]) do
                local faction = FactionsByIndex[i]
                local unitarray = moddata[2][i]
                if unitarray then
                    sidebarstring = sidebarstring .. "<details>\n<summary>"..faction.."</summary>\n<p>\n\n"
                    for unitI, unitData in ipairs(unitarray) do

                        sidebarstring = sidebarstring .. "* <a title=\""..unitData[2]..[[" href="]]..unitData[1]..[[">]]..unitData[3].."</a>\n"

                    end
                    sidebarstring = sidebarstring .. "</p>\n</details>\n"
                end
            end
            sidebarstring = sidebarstring .. "\n</td>\n</tr>\n</table>\n</p>\n</details>\n"
        end

        local md = io.open(WikiRepoDir..'/_Sidebar.md', "w")
        md:write(sidebarstring)
        md:close()

        print("Sidebar done")

        sortData(sidebarData, 'TechAscending-IDAscending')

        for modindex, moddata in ipairs(sidebarData) do

            local InfoboxString = InfoboxHeader(
                'mod-right',
                moddata.modinfo.name,
                '<img src="'..ImageRepo..'mods/'..stringSanitiseFile(moddata.modinfo.name, true, true)..'.png" width="256px" />')
            .. InfoboxRow( 'Author:', moddata.modinfo.author )
            .. InfoboxRow( 'Version:', moddata.modinfo.version )
            .. InfoboxEnd('main-right')

            local mulString = '***'..moddata.modinfo.name..'*** is a mod by '..(moddata.modinfo.author or 'an unknown author')
            ..". Its mod menu description is:\n"
            .."<blockquote>"..(moddata.modinfo.description or 'No description.').."</blockquote>\nVersion "
            ..moddata.modinfo.version.." contains the following units:\n"

            for i = 1, 5 do--faction, unitarray in pairs(moddata[2]) do
                local faction = FactionsByIndex[i]
                local unitarray = moddata[2][i]
                if unitarray then
                    local curtechi = 0
                    local thash = {
                        ['Tech 1'] = {1, 'Tech 1'},
                        ['Tech 2'] = {2, 'Tech 2'},
                        ['Tech 3'] = {3, 'Tech 3'},
                        ['Experi'] = {4, 'Experimental'},
                        ['Other']  = {5, 'Other'},
                    }

                    mulString = mulString .. MDHead(faction,2)

                    for unitI, unitData in ipairs(unitarray) do
                        local tech = thash[string.sub(unitData[3], 1, 6)] or thash['Other']
                        if tech[1] > curtechi then
                            curtechi = tech[1]
                            mulString = mulString ..MDHead(tech[2])
                        end

                        mulString = mulString .. [[<a title="]]..unitData[2]..[[" href="]]..unitData[1]..[["><img src="]]..unitIconRepo..unitData[1].."_icon.png\" /></a>\n"
                    end
                end
            end

            md = io.open(WikiRepoDir..'/'..stringSanitiseFile(moddata.modinfo.name)..'.md', "w")
            md:write(InfoboxString..mulString)
            md:close()

        end

        print("Mod-pages done")

        for cat, datum in pairs(categoryData) do
            table.sort(datum, function(a,b)
                g = { ['Tech 1'] = 1, ['Tech 2'] = 2, ['Tech 3'] = 3, ['Experi'] = 4 }
                return (g[string.sub(a.UnitInfo.desc, 1, 6)] or 5)..a.UnitInfo.bpid < (g[string.sub(b.UnitInfo.desc, 1, 6)] or 5)..b.UnitInfo.bpid
            end)

            local catstring = 'Units with the <code>'..cat.."</code> category.\n<table>\n"
            for i, data in ipairs(datum) do
                catstring = catstring
                ..'<tr><td><a href="'..data.UnitInfo.bpid ..'"><img src="'..unitIconRepo..data.UnitInfo.bpid..'_icon.png" width="21px" /></a>'
                ..'<td><code>'..data.UnitInfo.bpid..'</code>'
                ..'<td><a href="'.. stringSanitiseFile(data.modinfo.name) ..'"><img src="'..IconRepo..'mods/'..stringSanitiseFile(data.modinfo.name, true, true)..'.png" width="21px" /></a>'
                ..'<td><a href="'..data.UnitInfo.bpid..'">'

                local switch = {
                    [0] = (data.UnitInfo.bpid),
                    [1] = (data.UnitInfo.name or '')..(data.UnitInfo.desc or ''),
                    [2] = (data.UnitInfo.name or '')..': '..(data.UnitInfo.desc or ''),
                }

                catstring = catstring..switch[BinaryCounter(data.UnitInfo.name, data.UnitInfo.desc)].."</a>\n"
            end

            md = io.open(WikiRepoDir..'/_categories.'..cat..'.md', "w")
            md:write(catstring)
            md:close()
        end

        print("Categories done")
    end)
    if not suc then print(msg) end
end

--[[TODO:
Built by (dynamic)
Upgrade info
Adjacency.
    Buff details
Hide 0 radius?
pathing footprint?
strategic icons
Loyalist death weapon. Too specific scripted?

top level mod pages
]]
