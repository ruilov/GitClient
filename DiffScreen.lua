-- DiffScreen.lua

DiffScreen = class(AppleScreen)

function DiffScreen:init(filename,localConts,gitConts,prevScreen)
    local schema = {
        title = filename,
        backButton = {
            text = "Files",
            callback = function() screen = prevScreen end,
        },
        elems = {}
    }
    AppleScreen.init(self,schema)
    
    self.filename = filename
    
    if not localConts then localConts = "" end
    if not gitConts then gitConts = "" end
    
    local localFile = DiffScreen.splitLines(localConts)
    local gitFile = DiffScreen.splitLines(gitConts)

    local diff = Differ.diff(localFile,gitFile)
    
    --for idx,elem in ipairs(diff) do
      --  print(idx,elem)
    --end
    
    -- topY = 10 for example means that we start showing only from
    -- 10 on down
    self.tY = 0
    
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
    
    for i = lastGitIdx + 1,#gitFile do
        table.insert(self.textBlocks,{text=gitFile[i],col=color(255,0,0,255)})
    end
end

function DiffScreen.splitLines(str)
    local idx = str:find("\n")
    local ans = {}
    while idx do
        local prefix = str:sub(1,idx-1)
        if prefix:len() == 0 then prefix = " " end
        table.insert(ans,prefix)
        str = str:sub(idx+1)
        idx = str:find("\n")
    end
    
    if str:len() == 0 then str = " " end
    table.insert(ans,str)
    return ans
end

function DiffScreen:draw()
    AppleScreen.draw(self)
    
    pushStyle()
    
    noStroke()
    fill(0,0,0)
    rect(0,0,WIDTH,HEIGHT-50)
    
    font("AmericanTypewriter-Bold")
    
    textMode(CORNER)
    fontSize(15)
    local startH = HEIGHT-60
    local currentH = startH + self.tY
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
    AppleScreen.touched(self,touch)
    if touch.state == MOVING then
        self.tY = self.tY + touch.deltaY
        self.tY = math.max(self.tY,0)
    end
end
