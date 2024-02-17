-- This file will install the package manager and all of its dependencies.
-- It will also create all and any necessary files and directories.

-- TODO: install Github Repo Downloader
-- NOTE: This is a library which downloads a github repository and all of its files.
-- This is useful since it will allow users to distribute their packages via github (which is the idea).
-- Get the file from the github repository "lucratecc" and place it in the "install" directory.

-- TODO: get the package "lucratecc" from github
-- NOTE: Yes, lucratecc is a package in itself. This is to allow for easy updating of the package manager.

--- Start of the installer
local package_repo = "https://github.com/Facundo-Barbera/LuCrateCC/"
local raw_package_repo = "https://raw.githubusercontent.com/Facundo-Barbera/LuCrateCC/main/"

-- Test if HTTP is enabled
if not http then
    print("HTTP is not enabled. Please enable it and try again.")
    return
end

-- Install Github Repo Downloader from the lucratecc repository
-- This file is inside "local_dependencies/github_repo_downloader.lua"
local repo_downloader = "local_dependencies/repo_downloader.lua"

-- Download the file
local repo_downloader_url = raw_package_repo .. repo_downloader
local repo_downloader_request = http.get(repo_downloader_url)
if not repo_downloader_request then
    print("Failed to download Repo Downloader.")
    return
end

-- Write the file
local repo_downloader_file = fs.open(repo_downloader, "w")
repo_downloader_file.write(repo_downloader_request.readAll())
repo_downloader_file.close()
