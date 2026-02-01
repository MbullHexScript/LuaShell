-- parser.lua - Command line parsing

parser = {}

-- Parse input string into command and arguments
-- Supports quoted strings and basic escaping
function parser.parse(input)
    if not input or input == "" then
        return nil
    end

    -- Trim whitespace
    input = input:match("^%s*(.-)%s*$")

    if input == "" then
        return nil
    end

    local tokens = {}
    local current = ""
    local in_quote = false
    local quote_char = nil
    local i = 1

    while i <= #input do
        local c = input:sub(i, i)

        if c == "\\" and i < #input and not in_quote then
            -- Escape next character
            i = i + 1
            current = current .. input:sub(i, i)
        elseif (c == '"' or c == "'") then
            if not in_quote then
                in_quote = true
                quote_char = c
            elseif c == quote_char then
                in_quote = false
                quote_char = nil
            else
                current = current .. c
            end
        elseif c:match("%s") and not in_quote then
            if current ~= "" then
                table.insert(tokens, current)
                current = ""
            end
        else
            current = current .. c
        end

        i = i + 1
    end

    -- Add last token
    if current ~= "" then
        table.insert(tokens, current)
    end

    if #tokens == 0 then
        return nil
    end

    -- First token is command, rest are args
    local cmd = tokens[1]
    local args = {}
    for i = 2, #tokens do
        table.insert(args, tokens[i])
    end

    return {
        cmd = cmd,
        args = args,
        raw = input
    }
end

return parser
