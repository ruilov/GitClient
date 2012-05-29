IO = class()

function IO.saveUsername(username)
    saveLocalData("username",username)
end

function IO.loadUsername()
    return readLocalData("username")
end

function IO.mapProjectRepo(projectName,repoName)
    local mapStr = readLocalData("projectMap")
    if not mapStr then mapStr = "{}" end
    local map = Json.Decode(mapStr)
    map[repoName]=projectName
    local newMapStr = Json.Encode(map)
    saveLocalData("projectMap",newMapStr)
end

function IO.getProjectMap()
    local mapStr = readLocalData("projectMap")
    if not mapStr then mapStr = "{}" end
    local map = Json.Decode(mapStr)
    return map
end

function IO.getRepoProject(repoName)
    local mapStr = readLocalData("projectMap")
    if not mapStr then mapStr = "{}" end
    local map = Json.Decode(mapStr)
    return map[repoName]
end 
