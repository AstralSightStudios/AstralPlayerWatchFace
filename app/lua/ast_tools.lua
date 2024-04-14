local lvgl = require("lvgl")

AstTools = {}

function AstTools.get_filename(path)
    local filename = path:match("^.+/(.+)$")
    if filename then
        return filename
    else
        -- 如果没有找到匹配，返回默认值或进行错误处理
        return path
    end
end

function AstTools.createBackBtn(Layer, event)
    local backbtn = lvgl.Object(Layer, {
        bg_color = "#818589"
    })
    backbtn:add_flag(lvgl.FLAG.CLICKABLE)
    backbtn:set{
        align = {
            type = lvgl.ALIGN.TOP_MID,
            y_ofs = 20
        },
        width = 80,
        height = 40,
    }
    lvgl.Label(backbtn, {
        text = "Back",
        text_color = "#ffffff",
        text_align = lvgl.ALIGN.CENTER,
        align = {
            type = lvgl.ALIGN.CENTER
        }
    })
    backbtn:onevent(lvgl.EVENT.PRESSED, event)
end