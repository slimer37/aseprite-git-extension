-- Replaces 'os.remove' which is unsupported in Aseprite
function os.delete(file)
    local isUnix = app.fs.pathSeparator == "/"

    if isUnix then
        os.execute("rm " .. file)
    else
        os.execute("del " .. file)
    end
end

-- https://gist.github.com/dukeofgaming/453cf950abd99c3dc8fc
-- Function to retrieve console output
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