-- SyncScreen.lua
-- SyncScreen has the list of links that we have created from github repos to local projects

import("LIB LUI")

SyncScreen = class(AppleScreen)

function SyncScreen:init(prevScreen)
    local links = {}  
    local schema = {
        title = "Sync",
        backButton = {
            text = "Menu",
            callback = function() screen = prevScreen end,
        },
        elems = {
            {type="text",text="GitHub / Codea"},
            {type="blank",amount=5},
            {type="block",elems = links},
        }
    }
    
    local map = IO.getProjectMap()
    for _,elem in ipairs(map) do
        local repo = elem.repo
        local proj = elem.project
        local cb = function()
            screen = ProjectScreen(repo,proj,self)
        end
        table.insert(links,{type="SimpleArrow",text=repo.." / "..proj,
            callback = cb})
    end
    
    AppleScreen.init(self,schema)
end
