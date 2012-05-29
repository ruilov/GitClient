SettingsScreen = class()

function SettingsScreen:init()
    self.textbox = Textbox(250,374,400)
    self.textbox:setFontSize(35)
    
    local savedName = IO.loadUsername()
    if savedName then self.textbox.text = savedName end
    
    self.b1 = Button2("OK",vec2(WIDTH/2-125,100),250,60)
    self.b1.textColor = color(0, 0, 0, 255)
    self.b1:setColors(color(180,255,180,255),color(0,255,0,255),color(100,175,100,255),
        color(0,150,0,255))
    self.b1.onEnded = function(b,t)
        IO.saveUsername(self.textbox.text)
        GIT_CLIENT = GitClient(self.textbox.text)
        screen = SplashScreen()
    end
        
    self.buttons = {self.b1}
end

function SettingsScreen:draw()
    for _,b in ipairs(self.buttons) do b:draw() end
    self.textbox:draw()
    
    pushStyle()
    font("AmericanTypewriter-Bold")
    fontSize(70)
    fill(255, 255, 255, 255)
    local tex = "Settings"
    local w,h = textSize(tex)
    textMode(CENTER)
    text(tex,WIDTH/2,HEIGHT-h-20)
    
    fontSize(30)
    fill(255, 255, 255, 255)
    local tex = "Username:"
    text(tex,150,400)
    popStyle()
    
    --sprite()
end

function SettingsScreen:touched(touch)
    local tt = self.textbox:touched(touch)
    if not tt then self.textbox:unselect() end
    for _,b in ipairs(self.buttons) do b:touched(touch) end
end

function SettingsScreen:keyboard(key)
    self.textbox:keyboard(key)
end
