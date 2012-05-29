-- Main.lua
USERNAME = "ruilov"
PASSWORD = "ruilov1"

function setup()
    TOUCHES = {}
    screen = SplashScreen()
    
    local username = IO.loadUsername()
    if username then
        GIT_CLIENT = GitClient(username)
    end
    --screen = UploadScreen()
    
    
    --client = GitClient(USERNAME)
    --client:listRepos(repoListCB)
    --client:setReponame("Codea-GitClient")
    --client:setPassword(PASSWORD)
    --client:getMasterBranch(masterBranchCB)
    --client:listFiles(fileListCB)
    
    --[[
    local projectContents = ProjectLoader.readAll("LIB LUI")
    for f,c in pairs(projectContents) do
        print(f)
    end
    local cb = function(info)
        print("Commited!")
        print("tree = "..info.tree)
        print("commit = "..info.commit)
    end
    client:commit(projectContents,"first project! with touch",cb)
    --]]
end

function draw()
    background(0)
    screen:draw()
    
    pushStyle()
    
    noStroke()
    ellipseMode(CENTER)
    local newTouches = {}
    local lifeT = .3
    for _,elem in ipairs(TOUCHES) do
        local dt = ElapsedTime - elem.time
        local alpha = math.max((1-dt/lifeT),0)*255
        fill(255, 0, 0, alpha)
        ellipse(elem.touch.x,elem.touch.y,50,50)
        
        if dt < lifeT then
            table.insert(newTouches,elem)
        end
    end
    TOUCHES = newTouches
    popStyle()
end

function touched(t)
    table.insert(TOUCHES,{touch=t,time=ElapsedTime})
    screen:touched(t)
end

function keyboard(key)
    if screen.keyboard then screen:keyboard(key) end
end

function repoListCB(repos)
    for _,repo in ipairs(repos) do
        print(repo.name)
    end
end

function fileListCB(fileList)
    for _,elem in ipairs(fileList) do
        print(elem.path)
        client:fileContents(elem.sha,fileCB)
    end
end

function fileCB(data)
    print(data)
end
