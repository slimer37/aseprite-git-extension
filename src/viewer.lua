viewer = {}

function viewer.open(spriteFile)
    local repo, relFile = git.getRepo(spriteFile)

    if repo == "" then
        app.alert("The file is not in a git repository.")
        return
    end

    local dlg = Dialog{ title="View commit" }
        :label{ text="Enter the branch or first part of the commit SHA:" }
        :entry{ id="identifier" }
        :button{ id="go", text="Go" }

    local bounds = dlg.bounds
    dlg:show{
        bounds=Rectangle(100, 100, bounds.width + 50, bounds.height + 50)
    }

    local data = dlg.data

    if data.go then
        local frameNumber = app.activeFrame.frameNumber;

        local success, file = git.loadFromCommit(data.identifier, repo, relFile)
        
        if not success then
            app.alert{
                title="Invalid Identifier",
                text="'" .. data.identifier .. ":" .. relFile .. "' was not valid."
            }
            return
        end

        local sprite = app.open(file)
        os.delete(file)
        sprite.filename = data.identifier .. ">" .. app.fs.fileName(relFile)

        if (#app.activeSprite.frames >= frameNumber) then
            app.activeFrame = app.activeSprite.frames[frameNumber];
        end
    end
end