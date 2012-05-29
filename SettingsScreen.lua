-- Settings.lua
-- in the settings screen you can change the username
import("LIB LUI")

SettingsScreen = class(Panel)

function SettingsScreen:init()
    Panel.init(self,0,0)
    
    -- the title
    local title = TextElem("Settings",WIDTH/2,HEIGHT-20,
        {fontSize = 70,textMode = CENTER})
    local h = select(2,title:textSize())
    title:translate(0,-h)
    self:add(title)
    
    -- username label
    local userLabel = TextElem("Username:",150,400,{fontSize=30,textMode=CENTER})
    self:add(userLabel)
    
    -- username textbox
    local textbox = Textbox(250,374,400)
    textbox:setFontSize(35)
    local savedName = IO.loadUsername()
    if savedName then textbox.text = savedName end
    self:add(textbox)
    
        -- ok button
    local okBut = TextButton("OK",WIDTH/2-125,100,255,60,
        {topColor=color(180,255,180,255),bottomColor=color(0,255,0,255)})
    okBut.onEnded = function(b,t)
        TextButton.onEnded(b,t)
        IO.saveUsername(textbox.text)
        GIT_CLIENT = GitClient(textbox.text)
        screen = SplashScreen()
    end
    self:add(okBut)
end
