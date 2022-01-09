--------------------------------------------------------------------------------
-- Summary: Reinforcement beacon unit script
--          Base class with no defined time to call reinforcements
--  Author: Sean "Balthazar" Wheeldon
--------------------------------------------------------------------------------
ReinforcementBeacon = Class(StructureUnit) {
    ----------------------------------------------------------------------------
    -- NOTE: Call this function to start call the reinforcements
    -- Inputs: self, the unit type requested
    ----------------------------------------------------------------------------
    CallReinforcement = function(self, unitID, transportID, quantity, exitOpposite)
        --Sanitise inputs
        unitID = unitID or 'uel0106'
        transportID = transportID or 'uea0107'
        quantity = math.max(quantity or 1, 1)

        --Get positions
        local pos = self.CachePosition or self:GetPosition()
        local BorderPos, OppBorPos

        local x, z = pos[1] / ScenarioInfo.size[1] - 0.5, pos[3] / ScenarioInfo.size[2] - 0.5

        if math.abs(x) <= math.abs(z) then
            BorderPos = {pos[1], nil, math.ceil(z) * ScenarioInfo.size[2]}
            OppBorPos = {pos[1], nil, BorderPos[3]==0 and ScenarioInfo.size[2] or 0}
            x, z = 1, 0
        else
            BorderPos = {math.ceil(x) * ScenarioInfo.size[1], nil, pos[3]}
            OppBorPos = {BorderPos[1]==0 and ScenarioInfo.size[1] or 0, nil, pos[3]}
            x, z = 0, 1
        end

        BorderPos[2] = GetTerrainHeight(BorderPos[1], BorderPos[3])
        OppBorPos[2] = GetTerrainHeight(OppBorPos[1], OppBorPos[3])

        --Get blueprints
        local unitBP = __blueprints[unitID]
        local transportBP = __blueprints[transportID]

        --Bone data
        local attachbone = {
            'Attachpoint',
            'Attachpoint_Med',
            'Attachpoint_Lrg',
        }
        attachbone = attachbone[ (unitBP.Transport and unitBP.Transport.TransportClass or 1) ]

        --Entity data
        local transports = {} -- Temporary, for this cycle
        if self.SingleUse then
            self.transports = {} -- so a single use beacon can call multiple types of unit
        end
        local created = 0
        local tpn = 0
        local army = self:GetArmy()

        while created < quantity do
            tpn = tpn + 1
            transports[tpn] = CreateUnitHPR(
                transportID,
                army,
                BorderPos[1] + (math.random(-quantity,quantity) * x), BorderPos[2], BorderPos[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
            table.insert(self.transports, transports[tpn])

            for i = 1, transports[tpn]:GetBoneCount() do
                local bonename = transports[tpn]:GetBoneName(i)
                if bonename then
                    if string.find(bonename, attachbone) and created < quantity then
                        local bonepos = transports[tpn]:GetPosition(bonename)
                        local unit = CreateUnitHPR(
                            unitID,
                            army,
                            bonepos[1], bonepos[2], bonepos[3],
                            0, 0, 0
                        )
                        transports[tpn]:OnTransportAttach( bonename, unit )
                        unit:AttachBoneTo(
                            ( unit:IsValidBone('AttachPoint') and 'AttachPoint' or 0 ),
                            transports[tpn], bonename
                        )
                        created = created + 1
                    elseif created >= quantity then
                        break
                    end
                end
            end
        end

        IssueTransportUnload(transports, pos)
        for i, trans in transports do
            if exitOpposite then
                IssueMove({trans}, {OppBorPos[1] + (math.random(-quantity,quantity) * x), OppBorPos[2], OppBorPos[3] + (math.random(-quantity,quantity) * z)})
            else
                IssueMove({trans}, {BorderPos[1] + (math.random(-quantity,quantity) * x), BorderPos[2], BorderPos[3] + (math.random(-quantity,quantity) * z)})
            end
            trans.DeliveryThread = self.DeliveryThread
            trans:ForkThread(trans.DeliveryThread, self)
        end
        if self.SingleUse then
            self:ForkThread(self.TransportSurvivalCheckThread)
        end
    end,

    DeliveryThread = function(self, beacon)
        self:SetUnSelectable(true)
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then
                --Transport on the way
                coroutine.yield(50)
            elseif orders == 1 then
                -- Transport has dropped off
                if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
                coroutine.yield(10)
            elseif orders == 0 then
                -- Transport has arrived back at the edge of the map
                if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
                self:Destroy()
                coroutine.yield(100) --shouldn't matter, but just in case
            end
        end
    end,

    TransportSurvivalCheckThread = function(self)
        if self.SingleUse then --  double check just in case something called this and shouldn't have
            while not self.Dead do
                local KYS = true
                for i, tran in self.transports do
                    if tran and not tran.Dead then
                        KYS = false
                        break
                    end
                end
                if KYS then
                    self:Destroy()
                end
                coroutine.yield(100)
            end
        end
    end,

}

--------------------------------------------------------------------------------
-- Summary: Single use reinforcement beacon unit script
--          Calls reinforcements on stop being built. Destroys resolved.
--  Author: Sean "Balthazar" Wheeldon
--  Inputs: Expects blueprint table bp.Economy.Reinforcements with values for the
--          keys: [Unit = id string], [Transport = id string], [Quantity = intager]
--          for example:
--[[
    Economy = {
        BuildCostEnergy = 50,
        BuildCostMass = 5,
        BuildTime = 50,
        Reinforcements = {
            Unit = 'ual0106',
            Transport = 'uaa0107',
            Quantity = 30,
            ExitOpposite = true,
        }
    },
]]
--------------------------------------------------------------------------------
SingleUseReinforcementBeacon = Class(ReinforcementBeacon) {

    SingleUse = true,

    OnStopBeingBuilt = function(self, builder, layer)
        ReinforcementBeacon.OnStopBeingBuilt(self, builder, layer)

        local bpR = (__blueprints[self.BpId] or self:GetBlueprint() ).Economy.Reinforcements
        self:CallReinforcement(bpR.Unit, bpR.Transport, bpR.Quantity, bpR.ExitOpposite)
    end,
}
