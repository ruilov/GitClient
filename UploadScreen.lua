-- UploadScreen.lua

import("LIB LUI")

UploadScreen = class(AppleScreen)

function UploadScreen:init(prevScreen)
    local schema = {
        title = "Upload",
        backButton = {
            text = "Menu",
            callback = function() screen = prevScreen end,
        },
        elems = {
            {type="block",elems = {
                {type="TextInput",label="Project",shadowText = "codea project",tag="project"},
                {type="TextInput",label="Password",protected=true,tag="password"},
            }},
            {type="blank",amount = 30},
            {type="text",text="Repos for "..GIT_CLIENT.username,tag="label"},
            {type="blank",amount = 5},
            {type="block",elems = {
            }},
        }
    }
    AppleScreen.init(self,schema)
    
    self.taggedElems.label:showHourGlass(true)
    
    -- now send a request for the repos
    local failcb = function(err)
        self.taggedElems.label:showHourGlass(false)
        print("FAILED\n",err)
    end
    GIT_CLIENT:listRepos(function(repos) self:listReposCB(repos) end,failcb )
end

function UploadScreen:listReposCB(repos)
    local lastBlock = self.schema.elems[#self.schema.elems]
    
    for _,repo in ipairs(repos) do
        local cb = function()
            -- clean out status on all repos
            for _,r in ipairs(repos) do
                self.taggedElems[r.name]:setRightText("")
            end
            -- retrieve the project name
            local projBox = self.taggedElems.project.textbox
            local projName = projBox.text
            if projBox.textIsShadow then projName = "" end
            
            local passBox = self.taggedElems.password.textbox
            local password = passBox.text
            
            -- see if the project exists
            if not ProjectLoader.exists(projName) then
                self.taggedElems[repo.name]:setRightText("Codea project above not found")
                return nil
            end
            
            GIT_CLIENT:setReponame(repo.name)
            GIT_CLIENT:setPassword(password)
            
            self.taggedElems[repo.name]:showHourGlass(true)
            self.active = false -- we'll wait for thee http request
            
            local projectContents = ProjectLoader.readAll(projName)
            
            local commitcb = function(info)
                self.active = true
                self.taggedElems[repo.name]:showHourGlass(false)
                self.taggedElems[repo.name]:setRightText("OK")
                IO.mapProjectRepo(projName,repo.name)
            end
                
            local failcb = function(err)
                self.active = true
                self.taggedElems[repo.name]:showHourGlass(false)
                self.taggedElems[repo.name]:setRightText("FAILED")
                GIT_CLIENT:removePassword()
                print("ERROR:\n",err)
            end
            
            GIT_CLIENT:commit(projectContents,"uploaded from codea's "..projName,commitcb,failcb)
        end
        
        local newElem = {type="SimpleArrow",text=repo.name,callback=cb,tag=repo.name}
        table.insert(lastBlock.elems,newElem)
    end
    
    -- note this also gets rid of the hour glass in the label
    self:rebuild()
end
