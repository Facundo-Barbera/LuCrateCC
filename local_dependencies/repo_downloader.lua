-- This is a library for downloading repositories from GitHub.

local httpAPIEnabled = http and true or false
local defaultBranch = "main" -- Adjust based on common usage, "master" or "main"

-- Check if HTTP API is enabled
function checkHTTPAPI()
    return httpAPIEnabled
end

-- Download File
function downloadFile(path, url, name)
    if not httpAPIEnabled then
        error("HTTP API is disabled.")
    end
    local dirPath = path:match('([%w%_%.% %-%+%,%;%:%*%#%=%/]+)/' .. name .. '$')
    if dirPath ~= nil and not fs.isDir(dirPath) then
        fs.makeDir(dirPath)
    end
    local content = http.get(url)
    if content then
        local file = fs.open(path, "w")
        file.write(content.readAll())
        file.close()
    else
        error("Failed to download file: " .. name)
    end
end

-- Get Directory Contents
function getGithubContents(user, repo, path, branch)
    if not httpAPIEnabled then
        error("HTTP API is disabled.")
    end
    local url = "https://api.github.com/repos/" .. user .. "/" .. repo .. "/contents/" .. (path or "") .. "?ref=" .. (branch or defaultBranch)
    local response = http.get(url)
    if response then
        local pType, pPath, pName = {}, {}, {}
        local result = response.readAll()
        for str in result:gmatch('"type":"(%w+)"') do table.insert(pType, str) end
        for str in result:gmatch('"path":"([^\"]+)"') do table.insert(pPath, str) end
        for str in result:gmatch('"name":"([^\"]+)"') do table.insert(pName, str) end
        return pType, pPath, pName
    else
        error("Error: Can't resolve URL " .. url)
    end
end

-- Download Repository Contents
function downloadRepository(user, repo, path, branch, localPath)
    local effectivePath = path or ""
    local effectiveBranch = branch or defaultBranch
    local effectiveLocalPath = localPath or "downloads/" .. repo
    local pType, pPath, pName = getGithubContents(user, repo, effectivePath, effectiveBranch)
    for i, type in ipairs(pType) do
        if type == "file" then
            local filePath = effectiveLocalPath .. "/" .. pName[i]
            local fileURL = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/" .. effectiveBranch .. "/" .. pPath[i]
            downloadFile(filePath, fileURL, pName[i])
        elseif type == "dir" then
            downloadRepository(user, repo, pPath[i], effectiveBranch, effectiveLocalPath .. "/" .. pName[i])
        end
    end
end
