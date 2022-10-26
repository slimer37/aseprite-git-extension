git = {}

function git.loadFromCommit(identifier, repo, location)
    local tmpFilename = app.fs.joinPath(app.fs.tempPath, "aseprite-git-view" .. identifier .. ".ase")
    local cmd = "cd " .. repo .. " & git show --raw " .. identifier .. ":" .. "\"" .. string.gsub(location, "\\", "/") .. "\" > " .. tmpFilename
    local success = os.execute(cmd)

    return success, tmpFilename
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

-- http://lua-users.org/wiki/StringRecipes
function string.starts(string, start)
    return string.sub(string, 1, #start) == start
end

-- Runs 'git log --follow' on the file and returns a table of objects with sha, author, message, and date properties.
function git.getCommits(repo, location)
    local cmd = "cd " .. repo .. " & git log --follow " .. location
    local output = os.capture(cmd, true)

    local lines = {}
    for s in output:gmatch("[^\r\n]+") do
        table.insert(lines, s)
    end

    local commits = {}
    local sha = nil

    for i, line in ipairs(lines) do
        if string.starts(line, "commit") then
            sha = string.sub(line, #"commit " + 1)
            table.insert(commits, {})
            commits[#commits].sha = sha
        elseif string.starts(line, "Author:") then
            -- Trim email portion with regex
            commits[#commits].author = string.sub(line, #"Author: " + 1, string.find(line, " <.*@.*>") - 1)
        elseif string.starts(line, "Date:") then
            commits[#commits].date = string.sub(line, #"Date:   " + 1, string.find(line, "-") - 2)
        elseif line ~= "" and commits[#commits].message == nil then
            -- Trim space at beginning of commit message
            commits[#commits].message = string.sub(line, 5)
        end
    end

    return commits
end