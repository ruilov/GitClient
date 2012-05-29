-- SplashScreen.lua
-- Splash screen is where the program starts

import("LIB LUI")

SplashScreen = class(BaseScreen)

function SplashScreen:init()
    BaseScreen.init(self,"Welcome to Gitty")

    -- the subtitle
    local title = TextElem("A GitHub client for codea",WIDTH/2,self.title.y-20,
        {fontSize = 25,textMode = CENTER})
    local h = select(2,title:textSize())
    title:translate(0,-h)
    self:add(title)

    -- sync button    
    local syncBut = TextButton("Sync",WIDTH/2-125,500,255,60,
        {topColor=color(180,255,180,255),bottomColor=color(0,255,0,255)})
    syncBut.onEnded = function(b,t)
        TextButton.onEnded(b,t)
        screen = SyncScreen()
    end
    self:add(syncBut)
    
    -- checkout button
    local checkoutBut = TextButton("Checkout",WIDTH/2-125,375,255,60,
        {topColor=color(180,255,180,255),bottomColor=color(0,255,0,255)})
    self:add(checkoutBut)
    
    -- Upload button
    local uploadBut = TextButton("Upload",WIDTH/2-125,250,255,60,
        {topColor=color(180,255,180,255),bottomColor=color(0,255,0,255)})
    uploadBut.onEnded = function(b,t)
        TextButton.onEnded(b,t)
        screen = UploadScreen()
    end
    self:add(uploadBut)
    
    -- settings button
    local settingsBut = TextButton("Settings",WIDTH/2-125,125,255,60,
        {topColor=color(180,255,180,255),bottomColor=color(0,255,0,255)})
    settingsBut.onEnded = function(b,t)
        TextButton.onEnded(b,t)
        screen = SettingsScreen(self)
    end
    self:add(settingsBut)
end
