-- This is a library for downloading repositories from GitHub.
local http = require("socket.http")
local https = require("ssl.https")
local lfs = require("lfs")

-- Function to download a file
function downloadFile(url, path)
    local body, code = https.request(url)
    if code ~= 200 then
        error("Failed to download file: " .. code)
    end

    local file = assert(io.open(path, "wb"))
    file:write(body)
    file:close()
end

-- Function to download a GitHub repository
function downloadRepo(user, repo, branch)
    local url = string.format("https://github.com/%s/%s/archive/refs/heads/%s.zip", user, repo, branch)
    local path = string.format("%s-%s.zip", repo)

    -- Download the zip file
    downloadFile(url, path)

    -- TODO: Extract the zip file

    -- Delete the zip file
    lfs.remove(path)
end