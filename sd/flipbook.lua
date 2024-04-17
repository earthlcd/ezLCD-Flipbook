-- 'flipbook' 2/17/2024 play group of images as short motion sequence
-- todo: use timer to calculate frames per second

function flipbook(path, frame_start, frame_end, loops)
    local delay  = 1		-- set frame delay in milliseconds
    for loop = 1, loops, 1
    do
        if Pressed == 1 then
            break
        end
        for frame = frame_start, frame_end, 1
        do
            if Pressed == 1 then
                break
            end
            -- draw image n (can be bmp or jpg) jpg will be much faster
            local filename = string.format("%s%04d.jpg", path, frame)
            ez.PutPictFile(0,0,filename)
            ez.Wait_ms(delay)	-- delay display of next frame
        end
    end
end

function ButtonHandler(id,state)
	--print("data -", id," ", state, "pressed",pressed) --print id and state for diagn.
	--print("\r\n")

	if ( id == 0 and state==2) then
        -- check for button released
        Book = Book + 1
        Pressed = 1
	end
	if ( id == 1 and state==2) then
        -- check for button released
        count = 0
        Pressed = 1
	end
end

ez.Button(0,1,-1,-1,-1,0,0,320,199)	-- set up button
ez.Button(1,1,-1,-1,-1,0,200,80,240)	-- set up button
ez.SetButtonEvent("ButtonHandler")	-- call the button function (above)

ez.Cls(ez.RGB(255,255,255))
Book = 1
count = 1
::Start::
    if Book == 1 then
        flipbook("/flip/bconla/", 1, 250, 2)
        flipbook("/flip/case/", 1, 250, 2)
        flipbook("/flip/base/", 1, 720, 1)
        flipbook("/flip/toy/", 1, 250, 2)
    elseif Book == 2 then
        flipbook("/flip/bconla/", 1, 250, 1)
    elseif Book == 3 then
        flipbook("/flip/toy/", 1, 250, 1)
    elseif Book == 4 then
        flipbook("/flip/case/", 1, 250, 1)
    elseif Book == 5 then
        flipbook("/flip/base/", 1, 720, 1)
    else
        Book = 1
    end
    Pressed = 0
if count == 0 then
    goto Stop
end
-- count = count - 1
goto Start
::Stop::
ez.Cls(ez.RGB(0,0,255))

