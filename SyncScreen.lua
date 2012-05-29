-- SyncScreen.lua
-- 

SyncScreen = class()

function SyncScreen:init()
    local map = IO.getProjectMap()
    self.list = ListChooser(10,10,WIDTH-20,600)
    for repo,proj in pairs(map) do
        local cb = function()
            screen = ProjectScreen(repo,proj)
        end
        self.list:add(repo.." (github) -> "..proj .. " (codea)",cb)
    end
end

function SyncScreen:draw()
    self.list:draw()
    
    pushStyle()
    font("AmericanTypewriter-Bold")
    fontSize(70)
    fill(255, 255, 255, 255)
    local tex = "Choose repository"
    local w,h = textSize(tex)
    textMode(CENTER)
    text(tex,WIDTH/2,HEIGHT-h-20)
    popStyle()
end

function SyncScreen:touched(touch)
    self.list:touched(touch)
end
