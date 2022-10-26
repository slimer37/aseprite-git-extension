viewer = {}

function viewer.open(spriteFile)
    local repo, relFile = git.getRepo(spriteFile)

    if repo == "" then
        app.alert("The file is not in a git repository.")
        return
    end

    local commits = git.getCommits(repo, relFile)
    local options = { "1. HEAD" }

    for i, v in ipairs(commits) do
        table.insert(options, tostring(i + 1) .. ". " .. string.sub(v.sha, 1, 5) .. string.gsub(" | $author: $message ($date)", "%$(%w+)", v))
    end

    local dlg = Dialog{ title="View commit" }
        :label{ text="Select the commit:" }
        :combobox{
            id="identifier",
            option="HEAD",
            options=options
        }
        :button{ id="go", text="Go" }

    dlg:show()

    local data = dlg.data

    if data.go then
        local idIndex = tonumber(string.sub(data.identifier, 1, 1)) - 1
        local identifier = "HEAD"
        
        if idIndex > 0 then
            identifier = commits[idIndex].sha
        end
        
        local success, file = git.loadFromCommit(identifier, repo, relFile)
        
        if not success then
            app.alert{
                title="Invalid Identifier",
                text="'" .. string.sub(identifier, 1, 5) .. ":" .. relFile .. "' was not valid."
            }
            return
        end

        local frameNumber = app.activeFrame.frameNumber;
        
        local sprite = app.open(file)
        os.delete(file)
        sprite.filename = string.sub(identifier, 1, 5) .. " > " .. app.fs.fileName(relFile)

        if (#app.activeSprite.frames >= frameNumber) then
            app.activeFrame = app.activeSprite.frames[frameNumber];
        end
    end
end