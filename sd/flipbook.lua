-- 'flipbook' 2/17/2024 play group of images as short motion sequence
-- todo: use timer to calculate frames per second

-- Path for ezLCD-5035 (320x240 images)
path = "/flip/"
-- Path for ezLCD-105 (800x600 images)
--path = "/flip800x600/"
-- Path for ezLCD-2023 (320x480 images)
--path = "/flip320x480/"

--------------------------------------------------------------------------
-- flipbook
--------------------------------------------------------------------------
-- format_string: string that defines how the file name of the flipbook is built
--    for example if the path + file name is /flip/sub/name-0001.jpg then your 
--    format string should be /flip/sub/name-%04d.jpg.
-- frame_start: the first numerical frame in the flipbook.
-- frame_end: the last numerical frame in the flipbook.
-- inc: the number of frames to advance after displaying each frame
-- loops: the number of times to display this flipbook
-- delay_ms: interframe delay in ms
function flipbook(format_string, frame_start, frame_end, inc, loops, delay_ms)
    for loop = 1, loops, 1
    do
        if Pressed == 1 then
            break
        end
        for frame = frame_start, frame_end, inc
        do
            if Pressed == 1 then
                break
            end
            -- draw image n (can be bmp or jpg) jpg will be much faster
            local filename = string.format(format_string, frame)
            ez.PutPictFile(0,0,filename)
            ez.Wait_ms(delay_ms)	-- delay display of next frame
        end
    end
end

function ButtonHandler(id,state)
	--print("data -", id," ", state, "pressed",pressed) --print id and state for diagn.
	--print("\r\n")

    -- state == 2 is check for button released
    if (state==2) then
        if ( id == 0 ) then
            Book = Book - 1
        end
        if ( id == 1 ) then
            Book = Book + 1
        end
        if ( id == 2 ) then
            count = 0
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

ez.Cls(ez.RGB(255,255,255))
Book = 0
count = 1
::Start::
    if Book == 0 then
        ez.Cls(ez.RGB(255,0,255))
        ez.SetColor(ez.RGB(200,200,255))
		ez.SetXY(10,10)
		print ("Flipbook for:" .. path)
        --flipbook(path .. "RVid/frame-%06d.jpg", 0, 2438, 5, 1, 0) --2438
        --ez.PutPictFile(0, 0, path .. "RVid/frame-000066.jpg")
        ez.Wait_ms(5000)	-- delay display of next frame
        Book = 1
    elseif Book == 1 then
        flipbook(path .. "bconla/%04d.jpg", 1, 250, 1, 2, 1)
        flipbook(path .. "case/%04d.jpg", 1, 250, 1, 2, 1)
        flipbook(path .. "base/%04d.jpg", 1, 720, 1, 1, 1)
        flipbook(path .. "toy/%04d.jpg", 1, 250, 1, 2, 1)
    elseif Book == 2 then
        flipbook(path .. "bconla/%04d.jpg", 1, 250, 1, 2, 1)
    elseif Book == 3 then
        flipbook(path .. "toy/%04d.jpg", 1, 250, 1, 1, 1)
    elseif Book == 4 then
        flipbook(path .. "case/%04d.jpg", 1, 250, 1, 1, 1)
    elseif Book == 5 then
        flipbook(path .. "base/%04d.jpg", 1, 720, 1, 1, 1)
    elseif Book > 5 then
        Book = 1
    else
        Book = 5
    end
    Pressed = 0
if count == 0 then
    goto Stop
end
-- count = count - 1
goto Start
::Stop::

-- Clear the screen and make it blue
ez.Cls(ez.RGB(0,0,255))
-- Make the font a blue-ish white color
ez.SetColor(ez.RGB(200,200,255))

-- Display a message to the user on the LCD
print("")
print("Flipbook script has ended")
print("")
print("Touching the bottom left screen corner")
print("cuases ezLCD to alert host computer")
print("that the onboard SD card is writable")
