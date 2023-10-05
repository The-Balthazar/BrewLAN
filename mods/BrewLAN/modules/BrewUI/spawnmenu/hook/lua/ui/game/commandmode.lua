local oldEldCommandMode = EndCommandMode
function EndCommandMode(isCancel)
    if modeData and modeData.cheat and modeData.selection then
        SelectUnits(modeData.selection)-- regain selection if we were cheating in units
    end

    oldEldCommandMode(isCancel)
end

local function CheatSpawn(command, data)
    SimCallback({
        Func = data.prop and 'BoxFormationProp' or 'CheatSpawnUnit',
        Args = {

            army = data.army,
            pos = command.Target.Position,
            bpId = data.unit or data.prop or command.Blueprint,
            count = data.count,
            yaw = data.yaw,
            rand = data.rand,
            veterancy = data.vet,
            CreateTarmac = data.CreateTarmac,
            MeshOnly = data.MeshOnly,
            ShowRaisedPlatforms = data.ShowRaisedPlatforms,
            UnitIconCameraMode = data.UnitIconCameraMode,
        }
    }, true)
end

local OldOnCommandIssued = OnCommandIssued
function OnCommandIssued(command)
    if modeData.cheat and command.CommandType == "BuildMobile" and (not command.Units[1]) then
        CheatSpawn(command, modeData)
        command.Units = {}
        return false
    end
    OldOnCommandIssued(command)
end
