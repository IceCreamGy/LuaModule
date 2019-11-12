
function GetPanelName(panelPath)
    local prefix = string.match(panelPath, '.*/')
    local panelName = string.sub(panelPath, string.len(prefix) + 1)
    return panelName
end