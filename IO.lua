IO = class()

function IO.saveUsername(username)
    saveLocalData("username",username)
end

function IO.loadUsername()
    return readLocalData("username")
end

function IO.mapProjectRepo(projectName,repoName)
    local mapStr = readLocalData("projectMap")
    if not mapStr then mapStr = "[]" end
    local map = Json.Decode(mapStr)
    
    -- see if this mapping already exists
    local exists = false
    for _,elem in ipairs(map) do
        if elem.project == projectName and elem.repo == repoName then
            exists = true
            break
        end
    end
    
    if exists then return nil end
    
    table.insert(map,1,{project=projectName,repo=repoName})
    local newMapStr = Json.Encode(map)
    saveLocalData("projectMap",newMapStr)
end

function IO.getProjectMap()
    local mapStr = readLocalData("projectMap")
    if not mapStr then mapStr = "[]" end
    local map = Json.Decode(mapStr)
    return map
end
