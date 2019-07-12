do
    local OldUpdateDialog = UpdateDialog

    function UpdateDialog(beatNumber, strings)
        if __blueprints.saa0105.Desync then
            return OldUpdateDialog(beatNumber, __blueprints.saa0105.Desync)
        else
            return OldUpdateDialog(beatNumber, strings)
        end
    end
end
