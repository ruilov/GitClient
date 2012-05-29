DialogBox = class()

function DialogBox:init(x,y,w,h,okcb,cancelcb)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.back = Button2("",vec2(self.x,self.y),self.w,self.h)
    local backColor = color(0, 130, 255, 255)
    self.back:setColors(backColor,backColor,backColor,backColor)
    
    self.ok = Button2("OK",vec2(self.x+self.w-110,self.y+10),100,60)
    local backColor = color(27, 27, 145, 255)
    self.ok:setColors(backColor,backColor,backColor,backColor)
    self.ok.onEnded = function(o,t)
        if okcb then okcb(self.textbox.text) end
    end
    
    self.cancel = Button2("Cancel",vec2(self.x+self.w-220,self.y+10),100,60)
    local backColor = color(27, 27, 145, 255)
    self.cancel:setColors(backColor,backColor,backColor,backColor)
    self.cancel.onEnded = function(o,t)
        if cancelcb then cancelcb() end
    end
    
    self.textbox = Textbox(self.x+180,self.y+self.h-60,self.w-200)
    self.textbox:setFontSize(35)
    self.textbox.protected = true
    self.textbox:select()
end

function DialogBox:draw()
    self.back:draw()
    self.ok:draw()
    self.cancel:draw()
    self.textbox:draw()
    
    pushStyle()
    font("AmericanTypewriter-Bold")
    fontSize(70)
    fill(255, 255, 255, 255)
    
    textMode(CORNER)
    fontSize(30)
    fill(255, 255, 255, 255)
    local tex = "Password:"
    text(tex,self.x+15,self.y+self.h-55)
    popStyle()
end

function DialogBox:touched(touch)
    local tt = self.textbox:touched(touch)
    if not tt then self.textbox:unselect() end
    
    self.ok:touched(touch)
    self.cancel:touched(touch)
end

function DialogBox:keyboard(key)
    self.textbox:keyboard(key)
end
