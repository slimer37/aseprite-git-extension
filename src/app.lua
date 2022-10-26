function app.clearMostRecentFile()
    local configPath = app.fs.joinPath(app.fs.userConfigPath, "aseprite.ini")
    local iniFile = assert(io.open(configPath, "r"))
    local contents = iniFile:read("a")

    local startPattern = "0000 = "
    local endPattern = "0001 = "

    local fileLineStart = string.find(contents, startPattern) - 2
    local fileLineEnd = string.find(contents, endPattern, fileLineStart) - 1

    local pathLineStart = string.find(contents, startPattern, fileLineEnd) - 2
    local pathLineEnd = string.find(contents, endPattern, pathLineStart) - 1

    iniFile:close()

    iniFile = assert(io.open(configPath, "w"))

    iniFile:write(string.sub(contents, 1, fileLineStart) .. string.sub(contents, fileLineEnd, pathLineStart) .. string.sub(contents, pathLineEnd))

    iniFile:close()
end