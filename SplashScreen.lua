import("LIB LUI")

SplashScreen = class()

function SplashScreen:init()
    self.b1 = Button2("Sync",vec2(WIDTH/2-125,450),250,60)
    self.b1.textColor = color(0, 0, 0, 255)
    self.b1:setColors(color(180,255,180,255),color(0,255,0,255),color(100,175,100,255),
        color(0,150,0,255))
    self.b1.onEnded = function(b,t)
        screen = SyncScreen()
    end
        
    self.b2 = Button2("Checkout",vec2(WIDTH/2-125,350),250,60)
    self.b2.textColor = color(0, 0, 0, 255)
    self.b2:setColors(color(180,255,180,255),color(0,255,0,255),color(100,175,100,255),
        color(0,150,0,255))
        
    self.b3 = Button2("Upload",vec2(WIDTH/2-125,250),250,60)
    self.b3.textColor = color(0, 0, 0, 255)
    self.b3:setColors(color(180,255,180,255),color(0,255,0,255),color(100,175,100,255),
        color(0,150,0,255))
    self.b3.onEnded = function(b,t)
        screen = UploadScreen()
    end
        
    self.b4 = Button2("Settings",vec2(WIDTH/2-125,150),250,60)
    self.b4.textColor = color(0, 0, 0, 255)
    self.b4:setColors(color(180,255,180,255),color(0,255,0,255),color(100,175,100,255),
        color(0,150,0,255))
    self.b4.onEnded = function(b,t)
        screen = SettingsScreen()
    end
        
    self.buttons = {self.b1,self.b2,self.b3,self.b4}
end

function SplashScreen:draw()
    for _,b in ipairs(self.buttons) do b:draw() end
    
    pushStyle()
    font("AmericanTypewriter-Bold")
    fontSize(70)
    fill(255, 255, 255, 255)
    local tex = "Welcome to Gitty"
    local w,h = textSize(tex)
    textMode(CENTER)
    text(tex,WIDTH/2,HEIGHT-h-40)
    
    fontSize(25)
    local tex = "A GitHub client for codea"
    local w,h2 = textSize(tex)
    text(tex,WIDTH/2,HEIGHT-h-h2-60)
    popStyle()
end

function SplashScreen:touched(t)
    for _,b in ipairs(self.buttons) do b:touched(t) end
end
