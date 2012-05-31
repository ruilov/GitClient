-- SplashScreen.lua
-- Splash screen is where the program starts

import("LIB LUI")

SplashScreen = class(AppleScreen)

function SplashScreen:init()
    local schema = {
        title = "Gitty - a GitHub client for Codea",
        elems = {
            {type="block",elems = {
                {type="SimpleArrow", text = "Sync", 
                    callback = function() screen = SyncScreen(self) end },
            }},
            {type="blank",amount=30},
            {type="block",elems = {
                {type="SimpleArrow", text = "Download"},
                {type="SimpleArrow", text = "Upload",
                    callback = function() screen = UploadScreen(self) end}
            }},
            {type="blank",amount=30},
            {type="block",elems = {
                {type="TextInput",label="Username",startText=IO.loadUsername(),
                    keycallback = function(str)
                        IO.saveUsername(str)
                        GIT_CLIENT:setUsername(str)
                    end},
            }},
        }
    }
    AppleScreen.init(self,schema)
end
