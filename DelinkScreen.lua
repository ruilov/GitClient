-- DelinkScreen.lua

DelinkScreen = class(AppleScreen)

function DelinkScreen:init(prevScreen)
    local links = {}  
    local schema = {
        title = "De-link",
        backButton = {
            text = "Menu",
            callback = function() screen = prevScreen end,
        },
        elems = {
            {type="text",text="Remove the link between a project and a repo"},
            {type="blank",amount=30},
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
            local ok = IO.delink(proj,repo)
            if ok then
                self.taggedElems[repo..proj]:setRightText("DELETED")
            else
                self.taggedElems[repo..proj]:setRightText("Failed")
            end
        end
        table.insert(links,{type="SimpleArrow",text=repo.." / "..proj,
            callback = cb, tag = repo..proj})
    end
    
    AppleScreen.init(self,schema)
end

