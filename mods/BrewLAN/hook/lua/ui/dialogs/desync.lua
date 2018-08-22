do
    local OldUpdateDialog = UpdateDialog

    function UpdateDialog(beatNumber, strings)
        if __blueprints.zzz2220.Desync then
            return OldUpdateDialog(beatNumber, __blueprints.zzz2220.Desync)
        else
            return OldUpdateDialog(beatNumber, strings)
        end
    end
end
