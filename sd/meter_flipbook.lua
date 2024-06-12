----------------------------------------------------------------------
-- ezLCD Meter Flipbook
-- Play a flipbook of images with the flipbook index controlled by
-- an ADC input to the LCD.
--
-- Created  06/12/2024  -  Jacob Christ
--
-- This program has tested on the following:
--   ezLCD-5035 Firmware 04xx2024
--
----------------------------------------------------------------------

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


----------------------------------------------------------------------
-- *** ezLCD-5035 ADC Pin Definitions ***
-- 0=VBat / 4    (Raw value)
-- 1=Temp Sensor (Raw value)
-- 2=VREFInt
-- 3=DAC1
-- 4=DAC2
-- 5=Pin U1-11 (ADC3_In1_N)
-- 6=Pin U1-12 (ADC3_In1_P) / Pin U1-11 (ADC3_In1_N) Differential
-- 7=Pin U1-13 (ADC2_In5_P) / Pin U1-14 (ADC2_In5_N) Differential
-- 8=Pin U1-14 (ADC2_In5_N)
-- 9=Pin U1-15 (ADC1_In1_N)
-- 10=Pin U1-16 (ADC1_In1_P) / Pin U1-15 (ADC1_In1_N) Differential
-- 11=Pin U1-25 (SPI5_MOSI)
-- 12=Pin U2-30 (GPIO 14)

-- ADC Global Variables
ADC_StartPort = 0
ADC_StopPort = 12
ADC_Ports = ADC_StopPort + 1
ADC_MAX = 4095.0
ADC_CHANNEL = 5

function MeterFlipbook(format_string, frame_start, frame_end, delay_ms)
    -- value = ez.ADCGetValue(ADC_CHANNEL) * 0.9 + value * 0.10
    local value = ez.ADCGetValue(ADC_CHANNEL)

    ez.SetXY(10,10)
    print(string.format("ADC %2d: %4d, start: %d, stop: %d", ADC_CHANNEL, value, frame_start, frame_end))

    local frame = math.floor(value * (frame_end - frame_start) / ADC_MAX) + frame_start
    print(string.format("frame %d", frame))

    -- draw image n (can be bmp or jpg) jpg will be much faster
    local filename = string.format(format_string, frame)
    ez.PutPictFile(0,0,filename)
    ez.Wait_ms(delay_ms)	-- delay display of next frame

    ez.SetXY(0,0)
    print(string.format("filename %s", filename))
    -- print(string.format(" ADC %2d: %4d", ADC_CHANNEL, value))
end

function ButtonHandler(id,state)
	-- print("data -", id,",", state, " Pressed ", Pressed) --print id and state for diagn.

    -- state == 2 is check for button released
    if (state==2) then
        if ( id == 0 ) then
            Book = Book - 1
        end
        if ( id == 1 ) then
            Book = Book + 1
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
fb = {
    { path .. "bconla/%04d.jpg", 1, 250, 1, 2, 1 },
    { path .. "case/%04d.jpg",   1, 250, 1, 2, 1 },
    { path .. "base/%04d.jpg",   1, 720, 1, 1, 1 },
    { path .. "toy/%04d.jpg",    1, 250, 1, 2, 1 },
    --{ path .. "RVid/frame-%06d.jpg", 0, 2438, 5, 1, 0 }, --2438
}

function Main()
    ez.ADCOpen(ADC_CHANNEL)

    ez.Cls(ez.RGB(255,255,255))
    --ez.PutPictFile(0, 0, path .. "RVid/frame-000066.jpg")

    Book = -1
    Running = 1

    while Running == 1 do
        if Book < -1 then
            Book = -1
        elseif Book == -1 then
            ez.Cls(ez.RGB(128,0,128))
            ez.SetColor(ez.RGB(200,200,255))
            ez.SetXY(10,10)
            print ("Flipbook for:")
            for b = 1, #fb do
                print("   " .. fb[b][1])
            end

            -- Wait for a button press
            while Pressed == 0 do
                ez.Wait_ms(10)	-- do nothing
            end
        elseif Book == 0 then
            ez.Cls(ez.RGB(128,0,128))
            ez.SetColor(ez.RGB(200,200,255))
            local value = ez.ADCGetValue(ADC_CHANNEL)
            ez.SetXY(10,100)
            print("ADC Value = ", value)
            ez.Wait_ms(100)	-- do nothing

        elseif Book <= #fb then
            MeterFlipbook(fb[Book][1], fb[Book][2], fb[Book][3], fb[Book][6])
        elseif Book > #fb then
            Book = 1
        else
            Book = #fb
        end
        Pressed = 0
    end

    -- Clear the screen and make it blue
    ez.Cls(ez.RGB(0,0,255))
    -- Make the font a blue-ish white color
    ez.SetColor(ez.RGB(200,200,255))

    -- Display a message to the user on the LCD
    print("")
    print("MeterFlipbook script has ended")
    print("")
    print("Touching the bottom left screen corner")
    print("cuases ezLCD to alert host computer")
    print("that the onboard SD card is writable")

end

Main()




