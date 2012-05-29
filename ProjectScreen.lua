ProjectScreen = class()

function ProjectScreen:init(repo,proj)
    print("Comparing to repo")
    self.repo = repo
    self.proj = proj
    
    GIT_CLIENT:setReponame(repo)
    GIT_CLIENT:listFiles(function(files) self:gotFiles(files) end)
    
    self.projectFiles = ProjectLoader.readAll(proj)
    self.list = ListChooser(20,0,WIDTH-40,HEIGHT-200)
    self.listButtons = {}
    for file,localConts in pairs(self.projectFiles) do
        local cb = function()
            if self.repoFiles[file] then
                screen = DiffScreen(file,localConts,self.repoFiles[file],self)
            end
        end
        self.list:add(file,cb)
        local item = self.list.items[#self.list.items]
        item:setColors(color(255,0,0,255),color(255,255,255,255),color(175,175,175,255),
        color(175,175,175,255))
        self.listButtons[file]=item
    end
end

function ProjectScreen:gotFiles(files)
    self.repoFiles = {}
    for _,k in ipairs(files) do
        local filename = k.path
        local cb = function(conts)
            self.repoFiles[filename]=conts
            local item = self.listButtons[filename]
            if item then
                -- do a diff
                local localConts = self.projectFiles[filename]
                if localConts == conts then 
                    item:setColors(color(0,255,0,255),color(255,255,255,255),
                    color(175,175,175,255),color(175,175,175,255))
                else
                    item:setColors(color(255,255,0,255),color(255,255,255,255),
                    color(175,175,175,255),color(175,175,175,255))
                end
            else
                self.list:add(filename)
                local item = self.list.items[#self.list.items]
                item:setColors(color(0,0,255,255),color(255,255,255,255),color(175,175,175,255),
                color(175,175,175,255))
                self.listButtons[filename]=item
            end
        end
        
        GIT_CLIENT:fileContents(k.sha,cb)
    end
end

function ProjectScreen:draw()
    self.list:draw()
    
    if self.neededFiles and self.neededFiles == 0 and (not DEBUG) then
        for file,repoCont in pairs(self.repoFiles) do
            local codeaCont = self.projectFiles[file]
            
            local equal = true
            if codeaCont == nil or repoCont:len() ~= codeaCont:len() then
                equal = false
            else
                for c = 1,repoCont:len() do
                    if repoCont:sub(c,c) ~= codeaCont:sub(c,c) then
                        equal = false
                        break
                    end
                end
            end
            
            print(file,equal)
        end
        DEBUG = true
    end
end

function ProjectScreen:touched(touch)
    self.list:touched(touch)
end
