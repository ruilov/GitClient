-- ProjectScreen.lua

ProjectScreen = class(AppleScreen)

function ProjectScreen:init(repo,proj,prevScreen,isDownloadScreen)
    self.fileSchema = {}
    self.repoFiles = {}
    self.isDownloadScreen = isDownloadScreen
    self.repo = repo
    self.proj = proj
    
    local schema = {
        title = "Files",
        backButton = {
            text = "Sync",
            callback = function() screen = prevScreen end,
        },
        elems = {
            {type="text",text="Files",tag="label"},
            {type="blank",amount=5},
            {type="block",elems = self.fileSchema}
        }
    }
    
    if self.isDownloadScreen then
        local continuecb = function() self:downloadIt() end
        table.insert(schema.elems,1,{type="block",elems={
            {type="SimpleArrow",text="Continue",callback = continuecb,tag="continue"},
        }})
        
        table.insert(schema.elems,2,{type="blank",amount=40})
    end
       
    self.projectFiles = ProjectLoader.readAll(proj)
    for file,localConts in pairs(self.projectFiles) do
        local cb = function()
            screen = DiffScreen(file,self.projectFiles[file],self.repoFiles[file],self)
        end
        local newElem = {type="SimpleArrow",text=file,tag=file,callback=cb}
        table.insert(self.fileSchema,newElem)
    end
    
    AppleScreen.init(self,schema)
    self.taggedElems.label:showHourGlass(true)
    self.active = false
    
    local failcb = function(err)
        self.taggedElems.label:showHourGlass(false)
        self.active = true
        print("FAILED\n",err)
    end
    
    GIT_CLIENT:setReponame(repo)
    GIT_CLIENT:listFiles(function(files) self:gotFiles(files) end,failcb)
end

function ProjectScreen:downloadIt()
    ProjectLoader.save(self.repoFiles,self.proj)
    IO.mapProjectRepo(self.proj,self.repo)
    self.taggedElems.continue:setRightText("OK")
end

function ProjectScreen:gotFiles(files)
    local remoteList = {}
    -- first recreate the schema
    for _,k in ipairs(files) do
        local filename = k.path
        remoteList[filename] = 1
        
        if self.projectFiles[filename] == nil then
            local cb = function()
                screen = DiffScreen(filename,self.projectFiles[filename],
                    self.repoFiles[filename],self)
            end
            local newElem = {type="SimpleArrow",text=filename,tag=filename,callback=cb}
            table.insert(self.fileSchema,1,newElem)
        end
    end
    self:rebuild()
    self.taggedElems.label:showHourGlass(true)
    
    for file,_ in pairs(self.projectFiles) do
        if remoteList[file] == nil then
            --print("NEW FILE")
            -- this is a new file
            local arrow = self.taggedElems[file]
            
            if self.isDownloadScreen then 
                arrow:setColors(color(255,0,0),color(255,0,0))
                arrow:setRightText("Missing")
            else 
                arrow:setColors(color(0,0,255),color(0,0,255))
                arrow:setRightText("Added") 
            end
        end
    end

    -- now get the contents of each file
    local nfiles = #files
    local countFiles = 0
    for _,k in ipairs(files) do
        local filename = k.path

        local cb = function(conts)
            self.repoFiles[filename]=conts
            countFiles = countFiles + 1
            if countFiles == nfiles then 
                self.taggedElems.label:showHourGlass(false)
                self.active = true
            end
            
            local arrow = self.taggedElems[filename]
            
            local localConts = self.projectFiles[filename]
            
            if not localConts then
                -- this file only exists in the repo
                if self.isDownloadScreen then
                    arrow:setColors(color(0,0,255),color(0,0,255))
                    arrow:setRightText("New") 
                else
                    arrow:setColors(color(255,0,0),color(255,0,0))
                    arrow:setRightText("Deleted") 
                end
            else
                if localConts ~= conts then
                    -- this file was changed
                    arrow:setColors(color(255,255,0),color(255,255,0))
                    arrow:setRightText("Changed")
                end
            end
        end
        
        GIT_CLIENT:fileContents(k.sha,cb)
    end
end
