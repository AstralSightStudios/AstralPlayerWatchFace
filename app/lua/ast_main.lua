local lvgl = require("lvgl")
require "ast_fs"
require "ast_settings"
require "ast_image"
require "ast_vp"

local globalWidth = lvgl.HOR_RES()
local globalHeight = lvgl.VER_RES()

local CHECKFILE_PATH = "/data/quickapp/files/com.astralsightstudios.astralplayer/installed"
local PLAYFILE_PATH = "/data/quickapp/files/com.astralsightstudios.astralplayer/play"

if AstSettings.LVGL_SIMULATOR_MODE then
    CHECKFILE_PATH = SCRIPT_PATH .. "data/quickapp/files/installed"
    PLAYFILE_PATH = SCRIPT_PATH .. "data/quickapp/files/play"
end

print(CHECKFILE_PATH)

local INSTALLED = false

INSTALLED = AstFS.fileExists(CHECKFILE_PATH)

print(INSTALLED)

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
    scr:clear_flag(lvgl.FLAG.SCROLLABLE)
    return scr
end

local function createfeatureBtn(Layer, text, color, w, h, y, onEvent)
    local playBtn = lvgl.Object(Layer, {
        bg_color = color
    })
    playBtn:add_flag(lvgl.FLAG.CLICKABLE)
    playBtn:set{
        align = {
            type = lvgl.ALIGN.CENTER,
            y_ofs = y
        },
        width = w,
        height = h
    }
    lvgl.Label(playBtn, {
        text = text,
        text_color = "#ffffff",
        text_align = lvgl.ALIGN.CENTER,
        align = {
            type = lvgl.ALIGN.CENTER
        }
    })

    playBtn:onevent(lvgl.EVENT.PRESSED, onEvent)

    return playBtn
end

local bak = createBack()
if INSTALLED then
    local title = lvgl.Label(bak, {
        text = "AstralPlayer",
        text_color = "#ffffff",
        text_align = lvgl.ALIGN.CENTER,
    })
    title:set{
        align = {
            type = lvgl.ALIGN.TOP_MID,
            y_ofs = 90
        },
        text_font = lvgl.Font("montserrat", 34)
    }
    local sec_title = lvgl.Label(bak, {
        text = "WatchFace Side",
        text_color = "#ffffff",
        text_align = lvgl.ALIGN.CENTER,
    })
    sec_title:set{
        align = {
            type = lvgl.ALIGN.TOP_MID,
            y_ofs = 140
        },
        text_font = lvgl.Font("montserrat", 16)
    }
    local author_notice = lvgl.Label(bak, {
        text = "Made By @Searchstars With \"Love\"",
        text_color = "#ffffff",
        text_align = lvgl.ALIGN.CENTER,
    })
    author_notice:set{
        align = {
            type = lvgl.ALIGN.TOP_MID,
            y_ofs = 370
        },
        text_font = lvgl.Font("montserrat", 14)
    }
    local path_notice = lvgl.Label(bak, {
        text = SCRIPT_PATH,
        text_color = "#ffffff",
        text_align = lvgl.ALIGN.CENTER,
    })
    path_notice:set{
        align = {
            type = lvgl.ALIGN.TOP_MID,
            y_ofs = 420
        },
        text_font = lvgl.Font("montserrat", 10)
    }

    createfeatureBtn(bak, "Scan video manifest files   >", "#818589", 300, 50, -10 , function ()
        bak:delete()
        require("ast_scan")
    end)

    createfeatureBtn(bak, "Play selected video   >", "#818589", 300, 50, 70 , function ()
        bak:delete()
        if AstFS.fileExists(PLAYFILE_PATH) then
            AstVP.PlayVideo(PLAYFILE_PATH)
        end
    end)
else
    local scanstatus = lvgl.Label(bak, {
        text = "Please install and run the \"AstralPlayer\" quick app first",
        text_color = "#ffffff",
        text_align = lvgl.ALIGN.CENTER,
        align = {
            type = lvgl.ALIGN.CENTER,
            y_ofs = 0
        },
        text_font = lvgl.Font("montserrat", 14)
    })
end