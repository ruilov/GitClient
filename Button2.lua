-- Button2.lua
-- by Vega from the codea forums

Button2 = class()

function Button2:init(text,location,width,height)
    self.state = "normal"
    self.text = text
    self.textColor = color(255,255,255,192)
    self.location = location
    self.width = width
    self.height = height
    self.visible = true
    self.fontSize = 28
    self.font = "ArialRoundedMTBold"
    self.color1 = color(255, 255, 255, 96)
    self.color2 = color(128,128,128,32)
    self.presscolor1 = color(192, 224, 224, 128)
    self.presscolor2 = color(96, 192, 224, 128)
    self.verts = self:createVerts(self.width, self.height)
    self.myMesh = mesh()
    self.myMesh.vertices = triangulate(self.verts)
    self.vertColor = {}
    self:recolor()
end

function Button2:setColors(c1,c2,p1,p2)
    self.color1 = c1
    self.color2 = c2
    self.presscolor1 = p1
    self.presscolor2 = p2
end

function Button2:textOptions(fn, sz, col)
    self.font = fn
    self.fontSize = sz
    self.textColor = col
end

function Button2:draw()
    if self.visible == true then
        self:recolor()
        pushMatrix()
        translate(self.location.x,self.location.y)
        self.myMesh:draw()
        fill(self.textColor)
        fontSize(self.fontSize)
        font(self.font)
        text(self.text, self.width/2,self.height/2)
        self:drawLines(self.verts)
        popMatrix()
    end
end

function Button2:onEnded(touch) end

function Button2:touched(touch)
    if self.visible then
        if touch.x >= self.location.x and 
            touch.x <= self.location.x + self.width and 
                touch.y >= self.location.y and touch.y <= self.location.y + self.height then
            if touch.state == BEGAN then
                self.state = "pressing"
            elseif touch.state == ENDED then
                if self.state == "pressing" then
                    self.state = "normal"
                    self:onEnded(touch)
                end
            end
        else
            self.state = "normal"
        end
    end
end

function Button2:createVerts(w,h)
    local r = math.max(round(math.min(w,h)/100),1)
    local v = {}

    v[1] = vec2(w,6*r)
    v[2] = vec2(w-r,4*r)
    v[3] = vec2(w-2*r,2*r)
    v[4] = vec2(w-4*r,r)
    v[5] = vec2(w-6*r,0)
    
    v[6] = vec2(6*r,0)
    v[7] = vec2(4*r,r)
    v[8] = vec2(2*r,2*r)
    v[9] = vec2(r,4*r)
    v[10] = vec2(0,6*r)
    
    v[11] = vec2(0,h-6*r)
    v[12] = vec2(r,h-4*r)
    v[13] = vec2(2*r,h-2*r)
    v[14] = vec2(4*r,h-r)
    v[15] = vec2(6*r,h)
    
    v[16] = vec2(w-6*r,h)
    v[17] = vec2(w-4*r,h-r)
    v[18] = vec2(w-2*r,h-2*r)
    v[19] = vec2(w-r,h-4*r)
    v[20] = vec2(w,h-6*r)
    return v
end

function Button2:drawLines(v)
    noSmooth()
    strokeWidth(1)
    stroke(0, 0, 0, 192)
    for i=1, #v-1 do
        line(v[i].x,v[i].y,v[i+1].x,v[i+1].y)
    end
    line(v[#v].x,v[#v].y,v[1].x,v[1].y)   
end

function Button2:recolor()
    local lt, dk
    if self.state == "normal" then 
        lt = self.color1
        dk = self.color2
    else
        lt = self.presscolor1
        dk = self.presscolor2
    end

    for i=1,3 * #self.verts - 6 do
        if self.myMesh.vertices[i].y > self.height/2 then
            self.vertColor[i] = lt
        else
            self.vertColor[i] = dk
        end
    end
    self.myMesh.colors = self.vertColor
end

function round(v)
    return math.floor(v + 0.5)
end
