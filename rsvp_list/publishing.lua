List.Publishing = T{}

List.Publishing.Chat_Index = 1
List.Publishing.Chat_Mode = Ashita.Chat.Modes[1] -- Party

------------------------------------------------------------------------------------------------------
-- Creates a dropdown menu to chat mode options for publishing.
------------------------------------------------------------------------------------------------------
List.Publishing.Chat_Selection = function()
    local list = Ashita.Chat.Modes
    local flags = ImGuiComboFlags_None
    if list[1] then
        UI.SetNextItemWidth(Ashita.Chat.Selection.Width)
        if UI.BeginCombo(Ashita.Chat.Selection.Title, list[List.Publishing.Chat_Index].Name, flags) then
            for n = 1, #list, 1 do
                local is_selected = Ashita.Chat.Selection.Index == n
                if UI.Selectable(list[n].Name, is_selected) then
                    List.Publishing.Chat_Index = n
                    List.Publishing.Chat_Mode = list[n]
                end
                if is_selected then
                    UI.SetItemDefaultFocus()
                end
            end
            UI.EndCombo()
        end
    else
        if UI.BeginCombo(Ashita.Chat.Selection.Title, Ashita.Enum.Chat.PARTY, flags) then
            UI.EndCombo()
        end
    end
end