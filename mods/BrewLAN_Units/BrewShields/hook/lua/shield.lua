--------------------------------------------------------------------------------
-- Projected shield script
-- Author: Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local OldShield = Shield

    Shield = Class(OldShield) {

        ProjectorRecursionFilter = function(self, pCount, projectors, noreturn)

            if noreturn then
                local checked = {}
                local checkcount = 0

                for entid, v in projectors do
                    checked[entid] = v
                    checkcount = checkcount + 1
                end

                for entid, v in noreturn do
                    if checked[entid] then
                        checked[entid] = nil
                        checkcount = checkcount - 1
                    end
                end

                for entid, v in projectors do
                    noreturn[entid] = v
                end

                projectors = checked
                pCount = checkcount
            else
                noreturn = {}

                for entid, v in projectors do
                    noreturn[entid] = v
                end
                
                projectors[self.Owner.Sync.id] = nil
                pCount = pCount - 1
            end

            return pCount, projectors, noreturn

        end,

        SetDamageSplitFunction = function(self)

            self.OnDamage = function(self, instigator, amount, vector, type, noreturn)

                local pCount, projectors = self:CheckProjectors()
                pCount, projectors, noreturn = self:ProjectorRecursionFilter(pCount, projectors, noreturn)

                if pCount == 0 then
                    OldShield.OnDamage(self, instigator, amount, vector, type)

                else
                    local divAmount = amount / ( pCount + 1 )

                    OldShield.OnDamage(self, instigator, divAmount, vector, type)

                    for entid, v in projectors do
                        ForkThread(self.CreateDistroBeam, self, v)
                        v.MyShield:OnDamage(instigator, divAmount, Vector(0, -3.95, 0), type, noreturn)
                    end
                end
            end

        end,

        ClearProjection = function(self)
            self.OnDamage = OldShield.OnDamage
        end,

        CheckProjectors = function(self)
            local pCount = 0
            local projectors = {}
            if self.Owner.Projectors then
                for entid, projector in self.Owner.Projectors do
                    if IsUnit(projector) and projector.MyShield and projector.MyShield:GetHealth() > 0 then
                        pCount = pCount + 1
                        projectors[entid] = projector
                    end
                end
            end
            return pCount, projectors
        end,

        CreateDistroBeam = function(self, Pillar)
            local beam = AttachBeamEntityToEntity(self, -2, Pillar, 'Gem', self:GetArmy(), ( __blueprints[Pillar.BpId] or Pillar:GetBlueprint() ).Defense.Shield.ShieldTargetBeam)
            coroutine.yield(5)
            beam:Destroy()
        end,

    }

    ProjectedShield = Class(Shield) {

        OnDamage = function(self, instigator, amount, vector, type, noreturn)

            local pCount, projectors = self:CheckProjectors()
            pCount, projectors, noreturn = self:ProjectorRecursionFilter(pCount, projectors, noreturn)

            if pCount == 0 then
                self.Owner:DestroyShield()

            else
                local divAmount = amount

                for entid, v in projectors do
                    ForkThread(self.CreateDistroBeam, self, v)
                    v.MyShield:OnDamage(instigator, divAmount, vector, type, noreturn)

                end
            end
        end,

        OnState = State {
            Main = function(self) self:CreateShieldMesh() end,
            IsOn = function(self) return true end,
        },

        OffState = State {
            Main = function(self) self:RemoveShield() end,
        },

        ActivateProjection = function(self)
            self:TurnOn()
        end,

        ClearProjection = function(self)
            self:TurnOff()
        end,

        SetDamageSplitFunction = nil,

    }

end
