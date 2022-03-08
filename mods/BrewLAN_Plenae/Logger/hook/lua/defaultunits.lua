local function LOC(s)
    if s and string.sub(s, 1, 4)=='<LOC' then
        local i = string.find(s,">")
        if i then
            s = string.sub(s, i+1)
        end
    end
    return s
end

local function spacedString(n)
    local function sp(n) return string.rep(' ', n) end
    local r = math.random(0, 9)
    return sp(r)..n..sp(9-r)
end

DPSTestUnit = Class(Unit) {

    DoTakeDamage = function(self, instigator, amount, vector, damageType)
        local header = {
            [1] = "Game tick",
            [2] = "Tick",
            [3] = "ID",
            [4] = "Weapon",
            [5] = "Name",
            [6] = "Dmg",
            [7] = "DPS",
            [8] = "Burst",
            [9] = "Note",
        }

        if instigator and not instigator.DPSData then
            _ALERT(unpack(header))
            instigator.DPSData = {
                start = GetGameTick(),
                total = 0,
            }
        end

        local dataline = function()
            local bp, total, start, dps, burst
            local ctick = GetGameTick()

            if instigator then
                bp = instigator:GetBlueprint()
                total = instigator.DPSData.total
                start = instigator.DPSData.start
                instigator.DPSData.total = total + amount
                duration = (ctick - start) / 10
                dps = math.floor(total / duration + 0.5)
                burst = math.floor((total + amount) / duration + 0.5)
            end

            return {
                [1] = ctick,
                [2] = instigator and ctick - start,
                [3] = bp and bp.BlueprintId,
                [4] = damageType,
                [5] = bp and LOC( bp.General.UnitName or bp.Description ),
                [6] = amount,
                [7] = dps,
                [8] = burst,
                [9] = not instigator and "Damage instance has no instigator"
                or ctick == start and "First damage instance"
                or dps == burst and "Sustain and burst converged" or '',
            }
        end
        _ALERT(unpack(dataline()))

        pcall(FloatingEntityText, instigator.Sync.id or self.Sync.id, spacedString(amount) )
    end,
}
