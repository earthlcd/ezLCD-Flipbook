-- 'flipbook' 2/17/2024 play group of images as short motion sequence
-- todo: use timer to calculate frames per second

-- Path for ezLCD-5035 (320x240 images)
path = "/flip/"
-- Path for ezLCD-105 (800x600 images)
--path = "/flip800x600/"
-- Path for ezLCD-2023 (320x480 images)
--path = "/flip320x480/"

--------------------------------------------------------------------------
-- slideshow
--------------------------------------------------------------------------
-- format_string: string that defines how the file name of the flipbook is built
--    for example if the path + file name is /flip/sub/name-0001.jpg then your 
--    format string should be /flip/sub/name-%04d.jpg.
-- frames: frame to display
function slideshow(format_string, frame)
    -- draw image frame (can be bmp or jpg) jpg will be much faster
    local filename = string.format(format_string, frame)
    ez.PutPictFile(0,0,filename)
end

function ButtonHandler(id,state)
	--print("data -", id," ", state, "pressed",pressed) --print id and state for diagn.
	--print("\r\n")

    -- state == 2 is check for button released
    if (state==2) then
        if ( id == 0 ) then
            Index = Index - 1
        end
        if ( id == 1 ) then
            Index = Index + 1
        end
        if ( id == 2 ) then
            Running = 0
        end
        Pressed = 1
    end
end

-- Button 0 (Top Left) { x1, y1, x2, y2 }
B0 = { 0, 0, (ez.Width // 2) - 1, ez.Height - 41 }

-- Button 1 (Top Right) { x1, y1, x2, y2 }
B1 = { ez.Width // 2, 0, ez.Width, ez.Height - 41 }

-- Button 2 (Bottom Left) { x1, y1, x2, y2 }
B2 = { 0, ez.Height - 40, 80, ez.Height }

ez.Button(0,1,-1,-1,-1,B0[1],B0[2],B0[3],B0[4])	-- set up button
ez.Button(1,1,-1,-1,-1,B1[1],B1[2],B1[3],B1[4]) -- set up button
ez.Button(2,1,-1,-1,-1,B2[1],B2[2],B1[3],B1[4]) -- set up button
ez.SetButtonEvent("ButtonHandler")	    -- call the button function (above)


-- Create array of flipbooks with parameters passed to the flipbook function
-- { format_string, frame_start, frame_end, inc, loops, delay_ms }
ss = {
    --{ path .. "bconla/%04d.jpg", 1, 250, 12 },
    --{ path .. "case/%04d.jpg",   1, 250, 12 },
    { path .. "base/%04d.jpg",   1, 720, 36 },
    --{ path .. "toy/%04d.jpg",    1, 250, 12 },
    --{ path .. "RVid/frame-%06d.jpg", 0, 2438, 5 }, --2438
}

function Main()
    ez.Cls(ez.RGB(255,255,255))
    --ez.PutPictFile(0, 0, path .. "RVid/frame-000066.jpg")

    local show = 1
    local frame = 1
    Index = -1
    Running = 1

    while Running == 1 do
        if Index < -1 then
            Index = -1
        elseif Index == -1 then
            ez.Cls(ez.RGB(64,64,64))
            ez.SetColor(ez.RGB(200,200,255))
            ez.SetXY(10,10)
            print (string.format("Slideshow #$d:", show))
            for b = 1, #ss do
                print("   " .. ss[show][1])
            end
            print("   ")
            print("   Touch top right / left corners")
            print("   to advance / reverse slideshow")

            -- Wait for a button press
            while Pressed == 0 do
                ez.Wait_ms(10)	-- do nothing
            end
        elseif Index <= ss[show][3] // ss[show][4] then
            Frame = ss[show][2] + (Index * ss[show][4])
            if Frame > ss[show][3] then
                Index = 0
                Frame = ss[show][2] + (Index * ss[show][4])
            end
            slideshow(ss[show][1], Frame )
        elseif Index > ss[show][3] // ss[show][4] then
            Index = 1
        else
            Index = #fb
        end
        Pressed = 0
    end

    -- Clear the screen and make it blue
    ez.Cls(ez.RGB(0,0,255))
    -- Make the font a blue-ish white color
    ez.SetColor(ez.RGB(200,200,255))

    -- Display a message to the user on the LCD
    print("")
    print("Slideshow script has ended")
    print("")
    print("Touching the bottom left screen corner")
    print("cuases ezLCD to alert host computer")
    print("that the onboard SD card is writable")

end

Main()

