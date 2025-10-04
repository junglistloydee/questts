--[[
    Events.lua
    - Handles all WoW API event registrations and logic.
--]]

local addonName, addon = ...
local QuestNarrator = LibStub("AceAddon-3.0"):GetAddon(addonName)

-- Called when the addon is enabled
function QuestNarrator:OnEnable()
    self:RegisterEvent("QUEST_ACCEPTED")
    self:RegisterEvent("PLAYER_LOGIN")
    self:RegisterEvent("QUEST_LOG_UPDATE")
end

-- Called when the addon is disabled
function QuestNarrator:OnDisable()
    self:UnregisterEvent("QUEST_ACCEPTED")
    self:UnregisterEvent("PLAYER_LOGIN")
    self:UnregisterEvent("QUEST_LOG_UPDATE")
end

-- Event handler for PLAYER_LOGIN
function QuestNarrator:PLAYER_LOGIN()
    self:Print("Player logged in. QuestNarrator is ready.")
end

-- Event handler for QUEST_ACCEPTED
-- This event fires with (questID, questTitle)
function QuestNarrator:QUEST_ACCEPTED(event, questID, questTitle)
    if not self.db.profile.autoAccept then return end

    -- Get the full quest text (description and objectives)
    local questDescription = GetQuestText()

    -- Format the text for speech
    local fullText = ("Quest Accepted: %s. %s"):format(questTitle, questDescription)

    -- Send the text to the communication variable
    self:WriteToComm(fullText)
end

-- Event handler for QUEST_LOG_UPDATE
function QuestNarrator:QUEST_LOG_UPDATE()
    -- This event fires when the quest log is opened or a quest is selected.
    -- We'll create our button here to ensure it's present.
    self:CreateQuestLogButton()

    -- Additionally, if the "auto-read in log" setting is enabled, we can read the quest text here.
    if self.db.profile.autoReadInLog then
        -- This logic is similar to the button's OnClick handler
        local questIndex = GetQuestLogSelection()
        if questIndex == 0 then return end

        local title = GetQuestLogTitle(questIndex)
        local description, objectives = GetQuestLogQuestText()

        if not title or not description or not objectives then return end

        local fullText = ("Quest: %s. %s %s"):format(title, description, objectives)

        self:WriteToComm(fullText)
    end
end