git = {}

function git.loadFromCommit(identifier, repo, location)
    local tmpFilename = app.fs.joinPath(app.fs.tempPath, "aseprite-git-view" .. identifier .. ".ase")
    local tmp = assert(io.open(tmpFilename, "wb"))
    local cmd = "cd " .. repo .. " & git show " .. identifier .. ":" .. "\"" .. string.gsub(location, "\\", "/") .. "\""
    local out = os.capture(cmd, true)
    tmp:write(out)

    tmp:close()

    return tmpFilename
end

-- Gets the repository of the file (empty if not found).
-- Returns the repository path and the relative path of the given file.
function git.getRepo(file)
    local dir = app.fs.filePath(file)
    local cmd = "cd " .. dir .. " & git rev-parse --show-toplevel"
    local repo = os.capture(cmd, false)

    local relativeFile = string.sub(file, string.len(repo) + 2)

    return repo, relativeFile
end