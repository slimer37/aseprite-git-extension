function init(plugin)
    if (not app.isUIAvailable) then
        return
    end

    if (os.execute("git --version")) then
        print("Git installation detected")
    else
        print("Git not found")
        app.alert{
            title="Git Not Found",
            text="No Git installation detected. Please install Git to use Git Viewer.",
            buttons="OK"
        }
        return
    end

    plugin:newCommand{
        id="ViewGitHistory",
        title="View Git History",
        group="file_open",
        onclick=function()
            viewer.open(app.activeSprite.filename)
        end,
        onenabled=function()
            return app.activeImage ~= nil;
        end
    }
end
  
function exit(plugin)
    print("Aseprite is closing my plugin, MyFirstCommand was called "
        .. plugin.preferences.count .. " times")
end