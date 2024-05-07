local lvgl = require("lvgl")
require "ast_json"
require "ast_fs"
require "ast_image"
require "ast_settings"

local IMAGE_PATH = "/data/quickapp/files/com.astralsightstudios.astralplayer/"
if AstSettings.LVGL_SIMULATOR_MODE then
    IMAGE_PATH = SCRIPT_PATH
end

AstVP = {}
-- AstVP.PlayVideo 函数用于播放视频
function AstVP.PlayVideo(AsPlayerDec)
    -- 创建新的专用背景版
    local globalWidth = lvgl.HOR_RES()  -- 获取屏幕水平分辨率
    local globalHeight = lvgl.VER_RES() -- 获取屏幕垂直分辨率

    STARTED_PLAY = false

    -- 设置背景属性
    local property = {
        w = globalWidth,         -- 宽度
        h = globalHeight,        -- 高度
        bg_color = 0,            -- 背景颜色
        bg_opa = lvgl.OPA(100),  -- 背景透明度
        border_width = 0,        -- 边框宽度
        pad_all = 0,             -- 填充
    }

    -- 创建背景对象
    local scr = lvgl.Object(nil, property)

    -- 解析播放器描述文件
    local DecJson = AstJson.parseJson(AstFS.readFile(AsPlayerDec))

    local status_text = lvgl.Label(scr, {
        text = "Preparing...",
        text_color = "#ffffff",
        text_align = lvgl.ALIGN.CENTER,
        align = {
            type = lvgl.ALIGN.CENTER
        }
    })

    -- 检查格式版本
    if DecJson["formatVersion"] ~= 0 or DecJson["formatVersion"] == nil then
        status_text:delete()
        -- 如果格式版本不正确，显示错误信息
        lvgl.Label(scr, {
            text = "Bad AsPlayerDec File",
            text_color = "#ffffff",
            text_align = lvgl.ALIGN.CENTER,
            align = {
                type = lvgl.ALIGN.CENTER
            }
        })
    else
        -- 检查图片文件是否存在
        if AstFS.fileExists(IMAGE_PATH .. DecJson["pics"] .. "1." .. DecJson["pic_format"]) then
            local ui_wait_timer = lvgl.Timer {
                period = 1000,
                cb = function(t)
                    if STARTED_PLAY ~= true then
                        STARTED_PLAY = true
                        status_text:set({
                            text = "Finished"
                        })

                        AstFS.writeToFile(IMAGE_PATH .. "playaudionow", "true")

                        -- 创建播放层
                        local playLayer = Image(scr, IMAGE_PATH .. DecJson["pics"] .. "1." .. DecJson["pic_format"], {0,0}, DecJson["width"], DecJson["height"], true, true)
                        -- 获取帧率和帧持续时间
                        local fps = DecJson["fps"]
                        local interval = 1 / fps
                        local frameCount = DecJson["frame"]
                        local startTime = os.clock()  -- 使用os.clock()保持时间函数的一致性
                        local frameIndex = 1
                        local ImagePath = DecJson["pics"]
                        local ImageFormat = DecJson["pic_format"]
                        local syncTime = startTime -- 将同步时间初始化在计时器外部
                        -- 创建计时器用于更新帧
                        local timer = lvgl.Timer {
                            period = 1000 / fps,
                            cb = function(t)
                                local currentTime = os.clock()  -- 使用更高精度的时间函数
                                local elapsedTime = currentTime - startTime
                                frameIndex = math.floor(elapsedTime * fps) % frameCount + 1
                                syncTime = currentTime  -- 更新同步时间
                                -- 更新图片帧
                                local frameName = string.format("%s%d.%s", IMAGE_PATH .. ImagePath, frameIndex, ImageFormat)
                                print(frameName)
                                playLayer.widget:set_src(frameName)
                            end
                        }
                    end
            end}
        else
            status_text:delete()
            -- 如果图片文件不存在，显示错误信息
            lvgl.Label(scr, {
                text = "Image files was not found",
                text_color = "#ffffff",
                text_align = lvgl.ALIGN.CENTER,
                align = {
                    type = lvgl.ALIGN.CENTER
                }
            })
        end
    end
end