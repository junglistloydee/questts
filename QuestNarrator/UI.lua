--[[
    UI.lua
    - Manages the creation and logic for the "Speak" button in the quest log.
--]]

local addonName, addon = ...
local QuestNarrator = LibStub("AceAddon-3.0"):GetAddon(addonName)

function QuestNarrator:CreateQuestLogButton()
    -- Check if the button already exists to prevent creating it multiple times
    if self.questLogButton then
        return
    end

    -- Create the button using a standard template
    local button = CreateFrame("Button", "QuestNarratorSpeakButton", QuestLogDetailFrame, "UIPanelButtonTemplate")
    button:SetText("Speak")
    button:SetSize(90, 25)

    -- Anchor it relative to the close button on the quest log
    button:SetPoint("BOTTOMLEFT", QuestLogDetailFrame, "BOTTOMLEFT", 15, 80)

    -- Define the action to perform when the button is clicked
    button:SetScript("OnClick", function()
        -- Get the index of the currently selected quest
        local questIndex = GetQuestLogSelection()
        if questIndex == 0 then return end -- No quest is selected

        -- Get the title of the selected quest
        local title = GetQuestLogTitle(questIndex)

        -- Get the description and objectives of the selected quest
        local description, objectives = GetQuestLogQuestText()

        if not title or not description or not objectives then return end

        -- Format the text for speech, combining all parts
        local fullText = ("Quest: %s. %s %s"):format(title, description, objectives)

        -- Pass the formatted text to the core communication function
        QuestNarrator:WriteToComm(fullText)
    end)

    -- Store the button on the addon object so we can reference it later
    self.questLogButton = button
end