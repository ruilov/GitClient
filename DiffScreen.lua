DiffScreen = class()

function DiffScreen:init(filename,localConts,gitConts,projectScreen)
    self.filename = filename
    
    local localFile = DiffScreen.splitLines(localConts)
    local gitFile = DiffScreen.splitLines(gitConts)

    local diff = Differ.diff(localFile,gitFile)
    --[[
    for idx,elem in ipairs(diff) do
        print(idx,elem)
    end
    --]]
    
    self.backButton = Button2("BACK",vec2(10,HEIGHT-60),80,50)
    self.backButton.textColor = color(0, 0, 0, 255)
    self.backButton:setColors(color(180,255,180,255),color(0,255,0,255),color(100,175,100,255),
        color(0,150,0,255))
    self.backButton.onEnded = function(b,t)
        screen = projectScreen
    end
    
    -- topY = 10 for example means that we start showing only from
    -- 10 on down
    self.topY = 0
    
    self.textBlocks = {}
    
    local lastGitIdx=0
    for localIdx,gitIdx in ipairs(diff) do
        if gitIdx == 0 then
            -- this line has been added
            table.insert(self.textBlocks,{text=localFile[localIdx],col=color(0,255,0,255)})
        else
            if gitIdx - lastGitIdx > 1 then
                -- this line has been removed
                for idx = lastGitIdx + 1,gitIdx-1 do
                    table.insert(self.textBlocks,{text=gitFile[idx],col=color(255,0,0,255)})
                end
                lastGitIdx = gitIdx
            end
            -- this line stays the same
            table.insert(self.textBlocks,{text=localFile[localIdx],col=color(255,255,255,255)})
            lastGitIdx = gitIdx
        end
    end
end

function DiffScreen.splitLines(str)
    local idx = str:find("\n")
    local ans = {}
    while idx do
        table.insert(ans,str:sub(1,idx-1))
        str = str:sub(idx+1)
        idx = str:find("\n")
    end
    table.insert(ans,str)
    return ans
end

function DiffScreen:draw()
    self.backButton:draw()
    
    pushStyle()
    font("AmericanTypewriter-Bold")
    fontSize(40)
    fill(255, 255, 255, 255)
    local tex = self.filename
    local w,h = textSize(tex)
    textMode(CENTER)
    text(tex,WIDTH/2,HEIGHT-h-5)
    
    textMode(CORNER)
    fontSize(15)
    local startH = HEIGHT-h-30
    local currentH = startH + self.topY
    for _,block in ipairs(self.textBlocks) do
        local w,h = textSize(block.text)
        currentH = currentH - h
        if currentH + h <= startH then
            fill(block.col)
            text(block.text,10,currentH)
        end
    end
    popStyle()
end

function DiffScreen:touched(touch)
    self.backButton:touched(touch)
    if touch.state == MOVING then
        self.topY = self.topY + touch.deltaY
        self.topY = math.max(self.topY,0)
    end
end
