viewer = {}

local function loadFromCommit(identifier, repo, location)
    local tmpFilename = app.fs.joinPath(app.fs.tempPath, "aseprite-git-view" .. identifier .. ".ase")
    local tmp = assert(io.open(tmpFilename, "wb"))
    local cmd = "cd " .. repo .. " & git show " .. identifier .. ":" .. "\"" .. string.gsub(location, "\\", "/") .. "\""
    local out = os.capture(cmd, true)
    app.alert(cmd .. "\n" .. out)
    tmp:write(out)

    tmp:close()

    return tmpFilename
end

function viewer.open(spriteFile)
    local dir = app.fs.filePath(spriteFile)
    local cmd = "cd " .. dir .. " & git rev-parse --show-toplevel"
    local repo = os.capture(cmd, false)
    app.alert(repo)

    spriteFile = string.sub(spriteFile, string.len(repo) + 2)

    app.alert(spriteFile)

    local data = Dialog()
        :entry{ id="identifier", label="Commit Identifier:" }
        :button{ id="go", text="Go" }
        :show().data

    if data.go then
        local tmpFile = loadFromCommit(data.identifier, repo, spriteFile)
        app.open(tmpFile)
    end
end

-- https://gist.github.com/dukeofgaming/453cf950abd99c3dc8fc
-- Function to retrieve console output
-- 
function os.capture(cmd, raw)
    local handle = assert(io.popen(cmd, 'r'))
    local output = assert(handle:read('*a'))

    handle:close()

    if raw then
        return output
    end

    output = string.gsub(
        string.gsub(
            string.gsub(output, '^%s+', ''),
            '%s+$',
            ''
        ), 
        '[\n\r]+',
        ' '
    )

   return output
end