function init(plugin)
    print("Aseprite is initializing my plugin")
    print(io.tmpfile())

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
  
    --
    plugin:newCommand{
        id="MyFirstCommand",
        title="My First Command",
        group="cel_popup_properties",
        onclick=function()
            plugin.preferences.count = plugin.preferences.count+1
        end
    }
end
  
function exit(plugin)
    print("Aseprite is closing my plugin, MyFirstCommand was called "
        .. plugin.preferences.count .. " times")
end