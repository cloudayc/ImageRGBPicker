


lib = {}

lib.touch = function ( x, y )
    mSleep(100);  
    touchDown(0, x, y);
    mSleep(200);
    touchUp(0); 
end

lib.long_touch = function ( x, y )
    mSleep(100);  
    touchDown(0, x, y);
    mSleep(600);
    touchUp(0); 
end

lib.rectInRect = function ( r_in, r_out )
    return r_in.x >= r_out.x and r_in.y >= r_out.y and r_in.x + r_in.w <= r_out.x + r_out.w and r_in.y + r_in.h <= r_out.y + r_out.h
end
lib.find_sample_point = function ( samples, regions, fuzzy )
    for i = 1, #regions do
        local region = regions[i]
        local frame = {}
        frame.x = region.x
        frame.y = region.y
        frame.w = samples.size.w
        frame.h = samples.size.h
        while lib.rectInRect( frame, region ) do
             local found = true
             for i = 1, #samples do
                local sample = samples[i]
                local r, g, b = getColorRGB(frame.x + sample.x, frame.y + sample.y);
                if math.abs(r - sample.r) > fuzzy or math.abs(g - sample.g) > fuzzy or math.abs(b - sample.b) > fuzzy then
                    found = false
                    break
                end
             end
             if found then
                return frame.x, frame.y
             end
             frame.x = frame.x + 1
             if frame.x + frame.w >= region.x + region.w then
                frame.x = region.x
                frame.y = frame.y + 1
            end
        end
    end
    return -1, -1
end

-- print(os.date("%Y-%m-%d %H:%M:%S"))
-- 2014-05-21 18:15:44
lib.log = function ( ... )
     local str = {...}
     local content = ""
     for i = 1, #str do
        if type(str[i]) == "number" or type(str[i]) == "string" then
            content = content .. str[i] .. " "
        end
     end
     local date = os.date("%Y-%m-%d %H:%M:%S ")
     local f = io.open("/mnt/sdcard/Touchelper/scripts/v2/log.txt", "a")
     f:write(date .. content .. "\n")
     f:close()
end
