UploadScreen = class()

function UploadScreen:init(x)
    GIT_CLIENT:listRepos(function(repos) self:listReposCB(repos) end )
    self.textbox = Textbox(265,556,400)
    self.textbox:setFontSize(35)
    self.list = ListChooser(50,10,400,480)
    
    self.buttons = {self.list}
end

function UploadScreen:listReposCB(repos)
    for _,r in ipairs(repos) do
        local cb = function()
            local projectName = self.textbox.text
            if not ProjectLoader.exists(projectName) then
                print("Project doesn't exist")
                return nil
            end
            
            local reponame = r.name
            GIT_CLIENT:setReponame(reponame)
            
            local cancelCB = function()
                --print("Cancel")
                self.dialogBox = nil
            end
            
            local okCB = function(password)
                GIT_CLIENT:setPassword(password)
                print("Uploading "..projectName.." to "..reponame)
                local projectContents = ProjectLoader.readAll(projectName)
                local cb = function(info)
                    print("Upload successful")
                    IO.mapProjectRepo(projectName,reponame)
                end
                
                local failcb = function(err)
                    print("FAILED")
                    print(err)
                end
                GIT_CLIENT:commit(projectContents,"uploaded from codea's"..projectName,cb,failcb)
                self.dialogBox = nil
            end
            
            self.dialogBox = DialogBox(100,400,600,150,okCB,cancelCB)
        end
        self.list:add(r.name,cb)
    end
end

function UploadScreen:draw()
    self.textbox:draw()
    for _,b in ipairs(self.buttons) do b:draw() end
    
    pushStyle()
    font("AmericanTypewriter-Bold")
    fontSize(70)
    fill(255, 255, 255, 255)
    local tex = "Upload"
    local w,h = textSize(tex)
    textMode(CENTER)
    text(tex,WIDTH/2,HEIGHT-h-20)
    
    textMode(CORNER)
    fontSize(30)
    fill(255, 255, 255, 255)
    local tex = "Project name:"
    text(tex,50,562)
    
    fontSize(30)
    fill(255, 255, 255, 255)
    local tex = "GitHub Repositories:"
    text(tex,50,500)
    popStyle()
    
    if self.dialogBox then
        self.dialogBox:draw()
    end
end

function UploadScreen:touched(touch)
    if self.dialogBox then
        self.dialogBox:touched(touch)
        return nil
    end
    
    local tt = self.textbox:touched(touch)
    if not tt then self.textbox:unselect() end
    
    for _,b in ipairs(self.buttons) do b:touched(touch) end
end

function UploadScreen:keyboard(key)
    if self.dialogBox then
        self.dialogBox:keyboard(key)
        return nil
    end
    self.textbox:keyboard(key)
end
