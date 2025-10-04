local tr = aegisub.gettext

script_name = tr"Simplified No Karaoke Furigana"
script_description = tr"简洁化非卡拉OK注音"
script_author = "GitHub Copilot"
script_version = "1.0"

function process_lines(subs, selected_lines)
    local i = 1
    while i <= #subs do
        local line = subs[i]

        if line.comment == false then
            -- 删除 Effect=fx 的 Dialogue 行
            if line.style == "Default" then
                subs.delete(i)
            -- 其他 Dialogue 行
            else
                i = i + 1
            end
        elseif line.comment == true then
        -- 删除 Effect=template noblank syl/furi 的 Comment 行
            if line.effect == "template noblank syl" or line.effect == "template noblank furi" then
                subs.delete(i)
            else
                -- 处理 Effect=karaoke 的行
                if line.effect == "karaoke" then
                    -- 删除所有 {} 及其中内容
                    line.text = line.text:gsub("[|%<].-k1}", "")
                    -- 将 Comment 改为 Dialogue
                    -- subs[i] = line
                    line.text = line.text:gsub("[|%<].*$", "")
                    -- 将 Comment 改为 Dialogue
                    -- subs[i] = line
                    line.text = line.text:gsub("{%\\k1}", "")
                    -- 将 Comment 改为 Dialogue
                    -- subs[i] = line
                    line.comment = false
                    subs[i] = line
                end
                i = i + 1
            end
        else
            i = i + 1
        end
    end
end

aegisub.register_macro(script_name, script_description, process_lines)
