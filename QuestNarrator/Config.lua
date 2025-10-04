--[[
    Config.lua
    - Creates the options panel in the Interface > Addons menu.
--]]

local addonName, addon = ...
local QuestNarrator = LibStub("AceAddon-3.0"):GetAddon(addonName)

-- This function is called to create the options panel
function QuestNarrator:CreateOptions()
    -- Get the AceConfig-3.0 and AceConfigDialog-3.0 libraries
    local AceConfig = LibStub("AceConfig-3.0")
    local AceConfigDialog = LibStub("AceConfigDialog-3.0")

    -- Define the options table that will be used to build the settings menu
    local options = {
        name = addonName,
        handler = QuestNarrator,
        type = "group",
        args = {
            general = {
                type = "group",
                name = "General Settings",
                args = {
                    enabled = {
                        type = "toggle",
                        name = "Enable Addon",
                        desc = "Globally enables or disables the addon.",
                        get = function(info) return QuestNarrator.db.profile.enabled end,
                        set = function(info, value) QuestNarrator.db.profile.enabled = value end,
                        order = 1,
                    },
                    autoAccept = {
                        type = "toggle",
                        name = "Enable on Quest Accept",
                        desc = "Automatically read quest text when a quest is accepted.",
                        get = function(info) return QuestNarrator.db.profile.autoAccept end,
                        set = function(info, value) QuestNarrator.db.profile.autoAccept = value end,
                        order = 2,
                    },
                    autoReadInLog = {
                        type = "toggle",
                        name = "Enable Auto-Read in Quest Log",
                        desc = "Automatically read quest text when a quest is selected in the log.",
                        get = function(info) return QuestNarrator.db.profile.autoReadInLog end,
                        set = function(info, value) QuestNarrator.db.profile.autoReadInLog = value end,
                        order = 3,
                    },
                },
            },
            tts = {
                type = "group",
                name = "Text-to-Speech",
                args = {
                    voice = {
                        type = "select",
                        name = "Voice",
                        desc = "Select the voice for the text-to-speech engine. (Requires restart of external app)",
                        values = {["Default"] = "Default", ["Female"] = "Female", ["Male"] = "Male"},
                        get = function(info) return QuestNarrator.db.profile.voice end,
                        set = function(info, value) QuestNarrator.db.profile.voice = value end,
                        order = 1,
                    },
                    rate = {
                        type = "range",
                        name = "Speech Rate",
                        desc = "Adjust the speed of the speech.",
                        min = 0.5, max = 2, step = 0.1,
                        get = function(info) return QuestNarrator.db.profile.rate end,
                        set = function(info, value) QuestNarrator.db.profile.rate = value end,
                        order = 2,
                    },
                    volume = {
                        type = "range",
                        name = "Volume",
                        desc = "Adjust the volume of the speech.",
                        min = 0, max = 1, step = 0.1,
                        get = function(info) return QuestNarrator.db.profile.volume end,
                        set = function(info, value) QuestNarrator.db.profile.volume = value end,
                        order = 3,
                    },
                    test = {
                        type = "execute",
                        name = "Test",
                        desc = "Say a test phrase using the current settings.",
                        func = function() QuestNarrator:Test() end,
                        order = 4,
                    },
                },
            },
        },
    }

    -- Register the options table with AceConfig
    AceConfig:RegisterOptionsTable("QuestNarrator", options)

    -- Create the options frame
    AceConfigDialog:AddToBlizOptions("QuestNarrator", "QuestNarrator")
end

-- Hook the OnInitialize function to create the options panel
QuestNarrator:HookScript("OnInitialize", QuestNarrator.CreateOptions)