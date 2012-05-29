-- ListChooser.lua

ListChooser = class()

function ListChooser:init(x,y,w,h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.items = {}
end

function ListChooser:add(itemName,cb)
    local buttonH = 40
    local y = self.y + self.h - (#self.items + 1) * buttonH - 3 * #self.items
    local item = Button2(itemName,vec2(self.x,y),self.w,buttonH)
    item.textColor = color(0, 0, 0, 255)
    item:setColors(color(255,255,0,255),color(255,255,255,255),color(175,175,175,255),
        color(175,175,175,255))

    item.onEnded = function(b,t)
        if cb then cb() end
    end

    table.insert(self.items,item)
end

function ListChooser:draw()
    pushStyle()
    --[[
    fill(255,255,255,255)
    noStroke()
    rectMode(CORNER)
    rect(self.x,self.y,self.w,self.h)
    --]]
    for _,item in ipairs(self.items) do
        item:draw()
    end
    
    popStyle()
end

function ListChooser:translate(dx,dy)
    for _,item in ipairs(self.items) do
        item.location = vec2(item.location.x+dx,item.location.y+dy)
    end
end

function ListChooser:touched(touch)
    for _,item in ipairs(self.items) do
        item:touched(touch)
    end
end
