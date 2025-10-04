--[[
    Core.lua
    - Initializes the addon
    - Provides the core function for writing text to the communication variable
--]]

-- Get the addon object
local addonName, addon = ...
local QuestNarrator = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0")

-- Initialize the database
function QuestNarrator:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("QuestNarratorDB", {
        profile = {
            enabled = true,
            autoAccept = true,
            autoReadInLog = false,
            voice = "Default",
            rate = 1,
            volume = 1,
        }
    })

    -- Initialize the communication variable. This is separate from the main DB
    -- to ensure it's simple for the external app to read.
    if QuestNarratorComm == nil then
        QuestNarratorComm = {
            text = "",
            timestamp = 0
        }
    end

    self:Print("Initialized.")
end

-- Function to write text to the communication variable
function QuestNarrator:WriteToComm(text)
    if not self.db.profile.enabled then return end

    -- Update the communication variable
    QuestNarratorComm.text = text
    -- Use a timestamp to ensure the file is always modified
    QuestNarratorComm.timestamp = GetServerTime()

    self:Print("Wrote to comm: " .. text)
end

-- A simple test function
function QuestNarrator:Test()
    self:WriteToComm("This is a test.")
end