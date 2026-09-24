-- lua/yoce_de.lua
-- 德语输入：动态生成 ä ö ü ß 变体，英文释义来自 yoce_de.txt

local dict_loaded = false
local code_map = {}
local all_entries = {}

local function trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function utf8_chars(s)
    local chars = {}
    local i = 1
    while i <= #s do
        local c = s:byte(i)
        local len
        if c < 0x80 then len = 1
        elseif c < 0xE0 then len = 2
        elseif c < 0xF0 then len = 3
        else len = 4 end
        chars[#chars + 1] = s:sub(i, i + len - 1)
        i = i + len
    end
    return chars
end

local VOWEL_BASE = {
    ["a"] = "a", ["o"] = "o", ["u"] = "u",
    ["ä"] = "a", ["ö"] = "o", ["ü"] = "u",
    ["A"] = "A", ["O"] = "O", ["U"] = "U",
    ["Ä"] = "A", ["Ö"] = "O", ["Ü"] = "U",
}
local UMLAUT = { a = "ä", o = "ö", u = "ü", A = "Ä", O = "Ö", U = "Ü" }

local function tokenize(chars)
    local tokens = {}
    local i = 1
    while i <= #chars do
        local c = chars[i]
        local nxt = chars[i + 1] or ""
        local c_low = c:lower()
        local nxt_low = nxt:lower()

        if (c_low == "a" or c_low == "o" or c_low == "u") and nxt_low == "e" then
            local base = c_low
            if c == c:upper() then base = base:upper() end
            tokens[#tokens + 1] = { kind = "v", base = base }
            i = i + 2
        elseif c_low == "ä" or c_low == "ö" or c_low == "ü" then
            local base = VOWEL_BASE[c_low]
            if c == c:upper() then base = base:upper() end
            tokens[#tokens + 1] = { kind = "v", base = base }
            i = i + 1
        elseif c_low == "a" or c_low == "o" or c_low == "u" then
            local base = c_low
            if c == c:upper() then base = base:upper() end
            tokens[#tokens + 1] = { kind = "v", base = base }
            i = i + 1
        elseif c_low == "s" and nxt_low == "s" then
            tokens[#tokens + 1] = { kind = "s", upper = (c == c:upper()) }
            i = i + 2
        elseif c == "ß" or c == "ẞ" then
            tokens[#tokens + 1] = { kind = "s", upper = (c == "ẞ") }
            i = i + 1
        else
            tokens[#tokens + 1] = { kind = "c", ch = c }
            i = i + 1
        end
    end
    return tokens
end

local function variants_of_token(t)
    if t.kind == "v" then
        local b = t.base
        local u = UMLAUT[b] or UMLAUT[b:lower()] or b
        return { b, u, b .. "e", u .. "e" }
    elseif t.kind == "s" then
        if t.upper then return { "ẞ", "SS" } else return { "ß", "ss" } end
    else
        return { t.ch }
    end
end

local function default_form(t)
    if t.kind == "v" then return t.base
    elseif t.kind == "s" then return t.upper and "ẞ" or "ß"
    else return t.ch end
end

local function gen_variants(s)
    local tokens = tokenize(utf8_chars(s))
    local var_pos = {}
    for i, t in ipairs(tokens) do
        if t.kind == "v" or t.kind == "s" then
            var_pos[#var_pos + 1] = i
        end
    end
    local effective = {}
    for i = 1, math.min(#var_pos, 3) do
        effective[var_pos[i]] = true
    end

    local results, seen = {}, {}
    local function rec(idx, cur)
        if idx > #tokens then
            if not seen[cur] then
                seen[cur] = true
                results[#results + 1] = cur
            end
            return
        end
        if effective[idx] then
            for _, r in ipairs(variants_of_token(tokens[idx])) do
                rec(idx + 1, cur .. r)
            end
        else
            rec(idx + 1, cur .. default_form(tokens[idx]))
        end
    end
    rec(1, "")
    return results
end

local function load_dict()
    if dict_loaded then return end
    dict_loaded = true

    local paths, path_seen = {}, {}
    local function add_path(path)
        if path and path ~= "" and not path_seen[path] then
            path_seen[path] = true
            paths[#paths + 1] = path
        end
    end

    if rime_api and rime_api.get_user_data_dir then
        local d = rime_api.get_user_data_dir()
        if d then add_path(d .. "/yoce_de.txt") end
    end
    if rime_api and rime_api.get_shared_data_dir then
        local d = rime_api.get_shared_data_dir()
        if d then add_path(d .. "/yoce_de.txt") end
    end
    add_path("yoce_de.txt")
    add_path("lua/yoce_de.txt")

    local f
    for _, p in ipairs(paths) do
        f = io.open(p, "r")
        if f then break end
    end
    if not f then return end

    for line in f:lines() do
        line = trim(line)
        if line ~= "" and not line:match("^#") then
            local de, en = line:match("^(.-)[	 ]+(.*)$")
            if de and de ~= "" then
                de = trim(de)
                en = trim(en or "")
                local entry = { de = de, en = en }
                all_entries[#all_entries + 1] = entry
                for _, code in ipairs(gen_variants(de)) do
                    if not code_map[code] then code_map[code] = {} end
                    code_map[code][#code_map[code] + 1] = entry
                    local lower_code = code:lower()
                    if lower_code ~= code then
                        if not code_map[lower_code] then code_map[lower_code] = {} end
                        code_map[lower_code][#code_map[lower_code] + 1] = entry
                    end
                end
            end
        end
    end
    f:close()
end

local function collect_entries_for_text(text)
    local entries, seen = {}, {}
    local function add_entry(e)
        local key = e.de .. "\t" .. e.en
        if not seen[key] then
            seen[key] = true
            entries[#entries + 1] = e
        end
    end

    for _, v in ipairs(gen_variants(text)) do
        local list = code_map[v]
        if list then
            for _, e in ipairs(list) do
                add_entry(e)
            end
        end
    end

    for _, e in ipairs(all_entries) do
        if e.de == text then
            add_entry(e)
        end
    end

    return entries
end

local function phrase_candidates_for(input)
    local chars = utf8_chars(input)
    local results, seen = {}, {}

    local function dfs(pos, parts, comments)
        if pos > #chars then
            if #parts > 0 then
                local text = table.concat(parts, " ")
                local comment = table.concat(comments, " / ")
                local key = text .. "\t" .. comment
                if not seen[key] then
                    seen[key] = true
                    results[#results + 1] = { text = text, comment = comment }
                end
            end
            return
        end

        for i = #chars, pos, -1 do
            local seg = ""
            for j = pos, i do
                seg = seg .. chars[j]
            end
            local entries = collect_entries_for_text(seg)
            if #entries > 0 then
                for _, e in ipairs(entries) do
                    local next_parts = {}
                    for _, p in ipairs(parts) do
                        next_parts[#next_parts + 1] = p
                    end
                    next_parts[#next_parts + 1] = e.de

                    local next_comments = {}
                    for _, c in ipairs(comments) do
                        next_comments[#next_comments + 1] = c
                    end
                    next_comments[#next_comments + 1] = e.en

                    dfs(i + 1, next_parts, next_comments)
                end
            end
        end
    end

    dfs(1, {}, {})
    return results
end

local function prefix_candidates_for(input, limit)
    local results, seen = {}, {}
    local input_lower = input:lower()
    for _, e in ipairs(all_entries) do
        for _, code in ipairs(gen_variants(e.de)) do
            if code:lower():sub(1, #input_lower) == input_lower then
                if not seen[e.de] then
                    seen[e.de] = true
                    results[#results + 1] = e
                    if #results >= limit then return results end
                end
                break
            end
        end
    end
    return results
end

local M = {}

function M.init(env)
    env.name_space = env.name_space:gsub('^*', '')
end

function M.func(input, seg, env)
    if input == "" then return end
    load_dict()

    local seen = {}
    local function emit(text, comment)
        if seen[text] then return end
        seen[text] = true
        local cand = Candidate(env.name_space, seg.start, seg._end, text, comment)
        cand.comment = comment or ""
        cand.quality = comment ~= "" and 1 or 0
        yield(cand)
    end

    local variants = gen_variants(input)

    local dict_seen = {}
    for _, v in ipairs(variants) do
        local list = code_map[v]
        if list then
            for _, e in ipairs(list) do
                if not dict_seen[e.de] then
                    dict_seen[e.de] = true
                    emit(e.de, e.en)
                end
            end
        end
    end

    for _, e in ipairs(prefix_candidates_for(input, 20)) do
        emit(e.de, e.en)
    end

    local phrase_seen = {}
    for _, p in ipairs(phrase_candidates_for(input)) do
        if not phrase_seen[p.text] then
            phrase_seen[p.text] = true
            emit(p.text, p.comment)
        end
    end

    for _, v in ipairs(variants) do
        emit(v, "")
    end
end

return M