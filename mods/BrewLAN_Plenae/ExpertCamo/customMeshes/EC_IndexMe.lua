--[[
    The contents of this file is unimportant;
    if it is in a folder called '/TerrainMeshes'
    or '/CustomMeshes' in an active mod,
    Expert Camo will index that folder and
    attempt to use the textures and models within.
    The capitalisation is unimportant.

    The expected filename formats are:
    unitid_skinname_lod0.scm
    unitid_skinname_albedo.dds
    unitid_skinname_specteam.dds
    unitid_skinname_normalsts.dds
    unitid_skinname_lodN.scm
    unitid_skinname_lodN_albedo.dds
    unitid_skinname_lodN_specteam.dds
    unitid_skinname_lodN_normalsts.dds

    Units with an underscore in their ID will get
    skipped entirely, and if another unit with an
    ID that = that units id up to before the
    underscore then it will probably break.
    So don't do that.

    It accepts LOD's to the Nth degree. However
    many LOD's the original unit has, it will loop
    through them and check for files that have LOD
    number = to iterations - 1. For default units
    that is basically lod0 (only shown on the
    model path), and lod1.
]]--