local lvgl = require("lvgl")
require "ast_fs"
require "ast_tools"
require "ast_settings"
require "ast_vp"

local globalWidth = lvgl.HOR_RES()
local globalHeight = lvgl.VER_RES()

local DECODED_VIDEOS_PATH = "/data/quickapp/files/com.astralsightstudios.astralplayer/"

if AstSettings.LVGL_SIMULATOR_MODE then
    DECODED_VIDEOS_PATH = SCRIPT_PATH .. "data/quickapp/files/playerquickapp"
end

local function createBack()
    local property = {
        w = globalWidth,
        h = globalHeight,
        bg_color = 0,
        bg_opa = lvgl.OPA(100),
        border_width = 0,
        pad_all = 0,
    }

    local scr = lvgl.Object(nil, property)
    return scr
end

local function createfileBtn(Layer, text, color, w, h, y, onEvent)
    local fileBtn = lvgl.Object(Layer, {
        bg_color = color
    })
    fileBtn:add_flag(lvgl.FLAG.CLICKABLE)
    fileBtn:set{
        align = {
            type = lvgl.ALIGN.CENTER,
            y_ofs = y
        },
        width = w,
        height = h
    }
    lvgl.Label(fileBtn, {
        text = text,
        text_color = "#ffffff",
        text_align = lvgl.ALIGN.CENTER,
        align = {
            type = lvgl.ALIGN.CENTER
        }
    })

    fileBtn:onevent(lvgl.EVENT.PRESSED, onEvent)

    return fileBtn
end


local bak = createBack()
AstTools.createBackBtn(bak, function()
    bak:delete()
    require("ast_main")
end)

local scanstatus = lvgl.Label(bak, {
    text = "Scanning...",
    text_color = "#ffffff",
    text_align = lvgl.ALIGN.CENTER,
    align = {
        type = lvgl.ALIGN.CENTER,
        y_ofs = 0
    },
    text_font = lvgl.Font("montserrat", 16)
})

local scan_ret = AstFS.findFilesByExtension(DECODED_VIDEOS_PATH, "asplayerdec")

if scan_ret[1] == nil then
    scanstatus:set({
        text = "No any decoded videos (.asplayerdec) found"
    })
else
    scanstatus:delete()
    local yofs = -90
    for index, value in ipairs(scan_ret) do
        print(index, value)
        createfileBtn(bak, AstTools.get_filename(value), "#818589", 300, 50, yofs , function ()
            bak:delete()
            AstVP.PlayVideo(value)
        end)
        yofs = yofs + 80
    end
    createfileBtn(bak, "", "#000000", 300, 70, yofs , function ()
    end)
end