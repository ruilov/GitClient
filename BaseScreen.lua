-- BaseScreen.lua

import("LIB LUI")

BaseScreen = class(Panel)

function BaseScreen:init(titleStr,prevScreen)
    Panel.init(self,0,0)
    
    self.title = TextElem(titleStr,WIDTH/2,HEIGHT,
        {fontSize = 70,textMode = CENTER})
    local h = select(2,self.title:textSize())
    self.title:translate(0,-h*.5)
    self:add(self.title)

    if prevScreen then
        local backBut = TextButton("BACK",10,HEIGHT-70,100,50,
        {topColor=color(180,255,180,255),bottomColor=color(0,255,0,255)})
        backBut.onEnded = function(b,t)
            TextButton.onEnded(b,t)
            screen = prevScreen
        end
        self:add(backBut)
    end    
end
