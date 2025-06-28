local json = {}

-- === Robust JSON parser (embedded, no external dependencies) ===

local function skipWhitespace(s, i)
    while i <= #s and s:sub(i,i):match("%s") do
        i = i + 1
    end
    return i
end

local function parseNull(s, i)
    if s:sub(i,i+3) == "null" then
        return nil, i + 4
    else
        error("Expected 'null' at position "..i)
    end
end

local function parseBool(s, i)
    if s:sub(i,i+3) == "true" then
        return true, i + 4
    elseif s:sub(i,i+4) == "false" then
        return false, i + 5
    else
        error("Expected boolean at position "..i)
    end
end

local function parseNumber(s, i)
    local num_pattern = "^%-?%d+%.?%d*[eE]?[%+%-]?%d*"
    local match = s:sub(i):match(num_pattern)
    if not match then
        error("Invalid number at position "..i)
    end
    local n = tonumber(match)
    if not n then
        error("Invalid number format at position "..i)
    end
    return n, i + #match
end

local function parseString(s, i)
    if s:sub(i,i) ~= '"' then
        error("Expected string '\"' at position "..i)
    end
    i = i + 1
    local res = ""
    while i <= #s do
        local c = s:sub(i,i)
        if c == '"' then
            return res, i + 1
        elseif c == "\\" then
            i = i + 1
            local esc = s:sub(i,i)
            if esc == '"' then res = res .. '"'
            elseif esc == "\\" then res = res .. "\\"
            elseif esc == "/" then res = res .. "/"
            elseif esc == "b" then res = res .. "\b"
            elseif esc == "f" then res = res .. "\f"
            elseif esc == "n" then res = res .. "\n"
            elseif esc == "r" then res = res .. "\r"
            elseif esc == "t" then res = res .. "\t"
            elseif esc == "u" then
                -- Unicode \uXXXX escapes are ignored, just skip 4 chars
                i = i + 4
            else
                error("Invalid escape \\"..esc.." at position "..i)
            end
        else
            res = res .. c
        end
        i = i + 1
    end
    error("Unterminated string starting at "..i)
end

local function parseArray(s, i)
    if s:sub(i,i) ~= "[" then
        error("Expected '[' at position "..i)
    end
    i = i + 1
    local arr = {}
    i = skipWhitespace(s, i)
    if s:sub(i,i) == "]" then
        return arr, i + 1
    end
    while true do
        local val
        val, i = json.parseValue(s, i)
        table.insert(arr, val)
        i = skipWhitespace(s, i)
        local c = s:sub(i,i)
        if c == "]" then
            return arr, i + 1
        elseif c == "," then
            i = i + 1
        else
            error("Expected ',' or ']' at position "..i)
        end
        i = skipWhitespace(s, i)
    end
end

local function parseObject(s, i)
    if s:sub(i,i) ~= "{" then
        error("Expected '{' at position "..i)
    end
    i = i + 1
    local obj = {}
    i = skipWhitespace(s, i)
    if s:sub(i,i) == "}" then
        return obj, i + 1
    end
    while true do
        local key
        key, i = parseString(s, i)
        i = skipWhitespace(s, i)
        if s:sub(i,i) ~= ":" then
            error("Expected ':' at position "..i)
        end
        i = skipWhitespace(s, i + 1)
        local val
        val, i = json.parseValue(s, i)
        obj[key] = val
        i = skipWhitespace(s, i)
        local c = s:sub(i,i)
        if c == "}" then
            return obj, i + 1
        elseif c == "," then
            i = i + 1
        else
            error("Expected ',' or '}' at position "..i)
        end
        i = skipWhitespace(s, i)
    end
end

function json.parseValue(s, i)
    i = skipWhitespace(s, i)
    local c = s:sub(i,i)
    if c == "{" then
        return parseObject(s, i)
    elseif c == "[" then
        return parseArray(s, i)
    elseif c == '"' then
        return parseString(s, i)
    elseif c == "-" or c:match("%d") then
        return parseNumber(s, i)
    elseif c == "t" or c == "f" then
        return parseBool(s, i)
    elseif c == "n" then
        return parseNull(s, i)
    else
        error("Unexpected character '"..c.."' at position "..i)
    end
end

function json.parse(s)
    local res, pos = json.parseValue(s, 1)
    pos = skipWhitespace(s, pos)
    if pos <= #s then
        error("Unexpected trailing characters at position "..pos)
    end
    return res
end

-- === Utility functions ===

local function directoryExists(path)
    local ok, err, code = os.rename(path, path)
    if ok then return true end
    if code == 13 then return true end  -- Permission denied = path exists
    if code == 2 then return false end  -- Not found
    return false
end

local function exec(cmd)
    print("> " .. cmd)
    local res, exit_type, exit_code = os.execute(cmd)
    if type(res) == "number" then
        if res ~= 0 then
            error("Command failed: " .. cmd .. " (exit code: " .. tostring(res) .. ")")
        end
    else
        if exit_type ~= "exit" or exit_code ~= 0 then
            error("Command failed: " .. cmd .. " (exit type: " .. tostring(exit_type) .. ", code: " .. tostring(exit_code) .. ")")
        end
    end
end

local function safeClone(repo, path)
    if directoryExists(path) then
        print("Directory already exists: " .. path)
        return true
    end
    local ok, err = pcall(exec, "git clone --depth=1 " .. repo .. " " .. path)
    if not ok then
        print("Error cloning repo " .. repo .. ": " .. err)
        return false
    end
    return true
end

local function loadDeps()
    local f = io.open("deps.json", "r")
    if not f then return {} end
    local content = f:read("*a")
    f:close()
    return json.parse(content)
end

-- === Premake workspace and project definition ===

require("premake-ninja/ninja")

workspace "MyProject"
    configurations { "Debug", "Release" }
    location "build"

project "MyApp"
    kind "ConsoleApp"
    language "C++"
    targetdir "bin/%{cfg.buildcfg}"

    files { "src/**.cpp", "src/**.h" }
    includedirs { "src" }

    -- Dependency management from deps.json
    local deps = loadDeps()
    for _, dep in ipairs(deps) do
        local path = "external/" .. dep.name
        if not safeClone(dep.repo, path) then
            print("Warning: failed to clone " .. dep.name .. ", proceeding anyway")
        end
        includedirs { path .. "/" .. dep.includes }
    end

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"
