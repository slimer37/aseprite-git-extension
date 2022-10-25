viewer = {}

function viewer.open(spriteFile)
    local repo, relFile = git.getRepo(spriteFile)

    if repo == "" then
        app.alert("The file is not in a git repository.")
        return
    end

    local data = Dialog()
        :entry{ id="identifier", label="Commit Identifier:" }
        :button{ id="go", text="Go" }
        :show().data

    if data.go then
        app.open(git.loadFromCommit(data.identifier, repo, relFile))
    end
end