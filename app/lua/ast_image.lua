local lvgl = require("lvgl")

local IMAGE_PATH = SCRIPT_PATH
if not IMAGE_PATH then
    IMAGE_PATH = "/"
    print("Note image root path is set to: ", IMAGE_PATH)
end

print("IMAGE_PATH:", IMAGE_PATH)

function imgPath(src, WITH_IMAGE_PATH)
    if WITH_IMAGE_PATH then
        return IMAGE_PATH .. src
    end
    return src
end

function Image(root, src, pos, w, h, CENTER, WITH_IMAGE_PATH)
    --- @class Image
    local t = {} -- create new table

    src = imgPath(src, WITH_IMAGE_PATH);

    t.widget = root:Image { src = src }
    
    t.w = w
    t.h = h
    -- current state, center
    t.pos = {
        x = pos[1],
        y = pos[2]
    }

    function t:getImageWidth()
        return t.w
    end

    function t:getImageheight()
        return t.h
    end   

    t.defaultY = pos[2]
    t.lastState = STATE_POSITION_MID
    t.state = STATE_POSITION_MID

    t.widget:set {
        w = w,
        h = h,
        x = t.pos.x,
        y = t.pos.y
    }

    if CENTER then
        t.widget:set{
            align = {
                type = lvgl.ALIGN.CENTER
            }
        }
    end

    return t
end