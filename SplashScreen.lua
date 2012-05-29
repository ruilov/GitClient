import("LIB LUI")

SplashScreen = class(Panel)

function SplashScreen:init()
    Panel.init(self,0,0)
    
    -- the title
    local title = TextElem("Welcome to Gitty",WIDTH/2,HEIGHT-40,
        {fontSize = 70,textMode = CENTER})
    local h = select(2,title:textSize())
    title:translate(0,-h)
    self:add(title)
    
    -- the subtitle
    local title = TextElem("A GitHub client for codea",WIDTH/2,HEIGHT-60-h,
        {fontSize = 25,textMode = CENTER})
    local h = select(2,title:textSize())
    title:translate(0,-h)
    self:add(title)

    -- sync button    
    local syncBut = TextButton("Sync",WIDTH/2-125,450,255,60,
        {topColor=color(180,255,180,255),bottomColor=color(0,255,0,255)})
    syncBut.onEnded = function(b,t)
        TextButton.onEnded(b,t)
        screen = SyncScreen()
    end
    self:add(syncBut)
    
    -- checkout button
    local checkoutBut = TextButton("Checkout",WIDTH/2-125,350,255,60,
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
    local settingsBut = TextButton("Settings",WIDTH/2-125,150,255,60,
        {topColor=color(180,255,180,255),bottomColor=color(0,255,0,255)})
    settingsBut.onEnded = function(b,t)
        TextButton.onEnded(b,t)
        screen = SettingsScreen()
    end
    self:add(settingsBut)
end
