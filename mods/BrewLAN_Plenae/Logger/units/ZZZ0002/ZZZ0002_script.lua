local AShieldStructureUnit = import('/lua/aeonunits.lua').AShieldStructureUnit

ZZZ0002 = Class(AShieldStructureUnit) {
    OnCreate = function(self)
        if self:BrewLANInstallationCheck() then
            self.DomeEntity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
            self.DomeEntity:AttachBoneTo( -1, self, 0 )
            self.DomeEntity:SetMesh('/mods/brewlan_plenae/logger/units/zzz0002/zzz0002_domes_mesh')
            self.DomeEntity:SetDrawScale(self:GetBlueprint().Display.UniformScale)
            self.DomeEntity:SetVizToAllies('Intel')
            self.DomeEntity:SetVizToNeutrals('Intel')
            self.DomeEntity:SetVizToEnemies('Intel')
            self.Trash:Add(self.DomeEntity)
        end
        AShieldStructureUnit.OnCreate(self)
    end,

    BrewLANInstallationCheck = function(self)
        local BrewLANPathFinder = function()
            for i, mod in __active_mods do
                if mod.name == "BrewLAN" then
                    return mod.location, mod.version
                end
            end
        end
        local BrewLANPath, BrewLANVer = BrewLANPathFinder()
        if BrewLANPath and BrewLANPath != "/mods/brewlan" then
            local message = {
                "BrewLAN "..BrewLANVer.." appears to be installed incorrectly.",
                "It is supposed to be installed at '/mods/brewlan'.",
                "However it is actually installed at '" .. BrewLANPath .. "'.",
            }
            if BrewLANPath == '/mods/brewlan-master/mods/brewlan' then
                table.cat(message, {
                    "You will also need to make sure that the contents of the gamedate folder is merged into the gamedata folder in the game directory.",
                    "Otherwise you'll be missing unit icons and strategic icons.",
                    "Check the installation instructions at github.com/The-Balthazar/BrewLAN#installation for details."
                })
            elseif BrewLANPath == '/mods/brewlan-master/brewlan-master/mods/brewlan' then
                table.cat(message, {
                    "It appears like you just dumped the github zip file in the mods folder.",
                    "That will break things.",
                    "Follow the installation instructions at github.com/The-Balthazar/BrewLAN#installation",
                })
                self:SendStaggeredMessages(message)
                return false
            end
        elseif not BrewLANPath then
            self:SendStaggeredMessages({"BrewLAN does not appear to be an active mod."})
            return false
        else
            self:SendStaggeredMessages({"BrewLAN "..BrewLANVer.." appears to be installed correctly."})
            return BrewLANPath
        end
    end,

    SendStaggeredMessages = function(self, array)
        self:ForkThread(function()
            for i, message in array do
                table.insert(Sync.AIChat, {group='all', text=message, sender=self:GetAIBrain().Nickname})
                WaitTicks(string.len(message))
            end
        end)
    end,
}

TypeClass = ZZZ0002
