local http = require("socket.http")
local widget = require( "widget" )
local statusNow = "http://seikisenjo.netne.net/status.html"
local web = "http://seikisenjo.netne.net"
local myTitle = display.newText("ESP8266 status", display.contentCenterX, 0, native.systemFont, 20)
myTitle:setFillColor(0, 255, 50)
local myText = display.newText("Checking for internet connection...",display.contentCenterX, 45, native.systemFont, 14)
myText.x, myText.y = display.contentCenterX, 25
local myInfoBackground = display.newRect( display.contentCenterX, display.contentCenterY + 30, display.contentWidth - 20, display.contentHeight - 15 )
local myInfo = display.newText("", myInfoBackground.x, myInfoBackground.y, myInfoBackground.width - 10, myInfoBackground.height - 10, "Courier New", 8)
myInfo:setFillColor( 0, 0, 0 )
local background = display.newImage( "unnamed.png", display.contentCenterX, display.contentCenterY)
display.setDefault("background", 0.5, 0.5, 0.5)
local tab = display.newText( "Checking status... ", 0, 0, native.systemFont, 18 )
tab:setFillColor(0, 0, 0)
tab.x, tab.y = display.contentCenterX, 60
local function checkStatus( event )
	if ( event.isError ) then
		myText.text = "Unable to retrieve status!"
	else
		myText.text = "Connected to ESP8266 server"
	end
end
local function getStatus ()
	local checkOnline = network.request(web, "POST", checkStatus)
end
getStatus()
local function getStatus1 ()
local path = system.pathForFile( "status.txt", system.CachesDirectory)
local myFile = io.open( path, "w" ) 
http.request{ 
        url = "http://seikisenjo.netne.net/status.html",  sink = ltn12.sink.file(myFile),
}
local file = io.open( path, "r" )
if file then
    -- read all contents of file into a string
    local contents = file:read( "*a" )
    io.close( file )
    --tab.text = contents
    if contents:match "387d7a59dbaaef002e0f9ac69ecd4443b9c5cef2" then
	tab.text = "Currently: ON"
    elseif contents:match "ad50489054ddaae044be8b3054bf4d67480648d6" then
	tab.text = "Currently: OFF"
    else
	tab.text = "Override Error!"
    end
else
    print("file not found")
end
end
getStatus1 ()
local function handleButton1Event( event )
    if ( "ended" == event.phase ) then
	local remote_host = "http://seikisenjo.netne.net/main.php"
	local auxdata = {}
	auxdata.headers = {}
	auxdata.headers["Authorization"] = "Basic "
	auxdata.headers["Content-Type"] = "application/x-www-form-urlencoded"
	auxdata.body = "status=1896935db4606ac65c7cf24edd40b891da87ba52"
	network.request( remote_host, "POST", listener1, auxdata )
    end
end
local function handleButton2Event( event )
    if ( "ended" == event.phase ) then
	local remote_host = "http://seikisenjo.netne.net/main.php"
	local auxdata = {}
	auxdata.headers = {}
	auxdata.headers["Authorization"] = "Basic "
	auxdata.headers["Content-Type"] = "application/x-www-form-urlencoded"
	auxdata.body = "status=c3ca8d418ad23d849ae76f7dc039073711f35dc5"
	network.request( remote_host, "POST", listener2, auxdata )
    end
end
local button1 = widget.newButton {
	defaultFile = "buttonGreen.png",
	overFile = "buttonGreenOver.png",
	labelColor = 
	{ default = { 0, 0, 0, 255 },
	},
	font = native.systemFont,
	fontSize = 22,
	label = "Turn On",
	onEvent = handleButton1Event
}
local button2 = widget.newButton {
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	labelColor = 
	{ default = { 0, 0, 0, 255 },
	},
	font = native.systemFont,
	fontSize = 22,
	label = "Turn Off",
	onEvent = handleButton2Event
}
button1.x = display.contentCenterX; button1.y = 100
button2.x = display.contentCenterX; button2.y = 160
local myFunction1 = display.newText("Off Timer (hour : minute)", display.contentCenterX, 200, native.systemFont, 20)
myFunction1:setFillColor(0, 0, 0)
local mytitle2 = display.newText("  :  ", display.contentCenterX, 235, native.systemFont, 23)
mytitle2:setFillColor(0, 0, 0)
local timehour
local timeminute
local headerhash = "4c393afd13ebbdb70b008d5bd4714e297584809b"
local endhash = "c65f75ad8b1262384d537d8b0f5fa3ec384bfd9a"
local numericField1 = native.newTextField( 125, 235, 60, 36 )
numericField1.text = "00"
numericField1.isEditable = true
numericField1.inputType = "number"
local function handlerFunctionoff1( event )
    if ( event.phase == "began" ) then
        -- user begins editing numericField1
        print( event.text )
   elseif event.phase == "ended" then
        -- do something with textBox text
        print( event.target.text )
   elseif event.phase == "editing" then
        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )
        if(string.len(numericField1.text)) >2 then
	numericField1.text = numericField1.text:sub(1,2)
        end
        local valuehour = numericField1.text
        local valueCheck1 = tonumber( valuehour )
        if (valueCheck1 > 23) then
	numericField1.text = "00"
        end
    end   
end
numericField1:addEventListener( "userInput", handlerFunctionoff1 )
local numericField2 = native.newTextField( 195, 235, 60, 36 )
numericField2.text = "00"
numericField2.isEditable = true
numericField2.inputType = "number"
local function handlerFunctionoff2( event )
    if ( event.phase == "began" ) then
        -- user begins editing numericField2
        print( event.text )
   elseif event.phase == "ended" then
         -- do something with textBox text
        print( event.target.text )
   elseif event.phase == "editing" then
        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text ) 
        if(string.len(numericField2.text)) >2 then
	numericField2.text = numericField2.text:sub(1,2)
        end
        local valueminute = numericField2.text
        local valueCheck2 = tonumber( valueminute )
        if (valueCheck2 > 59) then
	numericField2.text = "00"
        end
    end   	
end
numericField2:addEventListener( "userInput", handlerFunctionoff2 )
local function handleButton3Event( event )
    if ( "began" == event.phase ) then
                 timehour = numericField1.text
                 timeminute = numericField2.text
    elseif ( "ended" == event.phase ) then
	local remote_host = "http://seikisenjo.netne.net/timer.php"
	local auxdata = {}
	auxdata.headers = {}
	auxdata.headers["Authorization"] = "Basic "
	auxdata.headers["Content-Type"] = "application/x-www-form-urlencoded"
	auxdata.body = "timer="..headerhash..timehour..timeminute..endhash
	network.request( remote_host, "POST", listener3, auxdata )
    end
end
local button3 = widget.newButton {
	defaultFile = "buttonYellow.png",
	overFile = "buttonYellowOver.png",
	labelColor = 
	{ default = { 0, 0, 0, 255 },
	},
	font = native.systemFont,
	fontSize = 22,
	label = "Set Timer",
	onEvent = handleButton3Event
}
button3.x = display.contentCenterX; button3.y = 285
local timerStates = display.newText( "Timer not active ", display.contentCenterX, 320, native.systemFont, 20 )
timerStates:setFillColor(0, 0, 0)
local function getStatus2 ()
local path1 = system.pathForFile( "timer.txt", system.CachesDirectory)
local myFile1 = io.open( path1, "w" ) 
http.request{ 
        url = "http://seikisenjo.netne.net/timer.html",  sink = ltn12.sink.file(myFile1),
}
local file1 = io.open( path1, "r" )
if file1 then
    -- read all contents of file into a string
    local contents1 = file1:read( "*a" )
    io.close( file1 )
    if contents1:match "aa:aa" then
	timerStates.text = "Timer not active..."
    else
	timerStates.text = "Timer set!"
    end
else
    print("file not found")
end
end
getStatus2 ()
local star = display.newLine( 20, 335, 300, 335 )
star:setStrokeColor( 0, 0, 1, 1 )
star.strokeWidth = 5
local taskStates = display.newText( "Create task (Start - End) ", display.contentCenterX, 350, native.systemFont, 20 )
taskStates:setFillColor(0, 0, 0)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create two tables to hold data for hour and minute      
local shour = {}
local sminute = {}
local svalues
local currentsHour
local currentsMinute
-- Populate the "minute" table
sminute [1] = "00"
sminute [2] = "01"
sminute [3] = "02"
sminute [4] = "03"
sminute [5] = "04"
sminute [6] = "05"
sminute [7] = "06"
sminute [8] = "07"
sminute [9] = "08"
sminute [10] = "09"
sminute [11] = "10"
for sm = 12, 60 do
    sminute [sm] = sm-1
end
-- Populate the "hour" table
shour [1] = "00"
shour [2] = "01"
shour [3] = "02"
shour [4] = "03"
shour [5] = "04"
shour [6] = "05"
shour [7] = "06"
shour [8] = "07"
shour [9] = "08"
shour [10] = "09"
shour [11] = "10"
for sh = 12, 24 do
    shour[sh] = sh-1
end
-- Configure the picker wheel columns
local columnData = {
    -- hour
    {  align = "center",
        width = 45,
        startIndex = 13,
        labels = shour
    },
    -- minute
    {  align = "center",
        width = 45,
        startIndex = 31,
        labels = sminute
    }
}	
-- Create the widget
local pickerWheel1 = widget.newPickerWheel( {
        top = 120,
        left = 40,
        columns = columnData,
        sheet = pickerWheelSheet,
        overlayFrame = 1,
        overlayFrameWidth = 320,
        overlayFrameHeight = 222,
        backgroundFrame = 2,
        backgroundFrameWidth = 320,
        backgroundFrameHeight = 222,
        separatorFrame = 3,
        separatorFrameWidth = 8,
        separatorFrameHeight = 100,
        columnColor = { 255, 255, 255, 255 },
        fontColor = { 0.4, 0.4, 0.4, 0.5 },
        fontColorSelected = { 0.2, 0.6, 0.4 }
    }
)
print( currentsHour, currentsMinute )
pickerWheel1.isVisible=false
-----------------------------------------------------------------------------
local ehour = {}
local eminute = {}
local evalues
local currenteHour 
local currenteMinute
-- Populate the "minute" table
eminute [1] = "00"
eminute [2] = "01"
eminute [3] = "02"
eminute [4] = "03"
eminute [5] = "04"
eminute [6] = "05"
eminute [7] = "06"
eminute [8] = "07"
eminute [9] = "08"
eminute [10] = "09"
eminute [11] = "10"
for em = 12, 60 do
    eminute[em] = em-1
end
-- Populate the "hour" table
ehour [1] = "00"
ehour [2] = "01"
ehour [3] = "02"
ehour [4] = "03"
ehour [5] = "04"
ehour [6] = "05"
ehour [7] = "06"
ehour [8] = "07"
ehour [9] = "08"
ehour [10] = "09"
ehour [11] = "10"
for eh = 12, 24 do
    ehour[eh] = eh-1
end
-- Configure the picker wheel columns
local columnData = {
    -- hour
    {  align = "center",
        width = 45,
        startIndex = 13,
        labels = ehour
    },
    -- minute
    {  align = "center",
        width = 45,
        startIndex = 31,
        labels = eminute
    }
}	
-- Create the widget
local pickerWheel2 = widget.newPickerWheel( {
        top = 120,
        left = 160,
        columns = columnData,
        sheet = pickerWheelSheet,
        overlayFrame = 1,
        overlayFrameWidth = 320,
        overlayFrameHeight = 222,
        backgroundFrame = 2,
        backgroundFrameWidth = 320,
        backgroundFrameHeight = 222,
        separatorFrame = 3,
        separatorFrameWidth = 8,
        separatorFrameHeight = 100,
        columnColor = { 255, 255, 255, 255 },
        fontColor = { 0.4, 0.4, 0.4, 0.5 },
        fontColorSelected = { 0.2, 0.6, 0.4 }
    }
)
-- Get the table of current values for all columns
-- This can be performed on a button tap, timer execution, or other event
-- Get the value for each column in the wheel (by column index)
print( currenteHour, currenteMinute )
pickerWheel2.isVisible=false
-----------------------------------------------------------------------------
local starthash = "61858e5955dd96694dbe6a2b124d7a6ec2069ba0"
local donehash = "9d4f39b97053db845fa9bb790576f515379ed161"
local taskField1 = native.newTextField( display.contentCenterX, 380, 200, 36 )
taskField1.text = "Set your task here"
taskField1.isEditable = true
taskField1.inputType = "number"
local function handlerTask1( event )
    if event.phase == "editing" then
       taskField1.text = ""
       pickerWheel1.isVisible=true 
       pickerWheel2.isVisible=true  
       numericField1.isVisible=false
       numericField2.isVisible=false
    end     
end
taskField1:addEventListener( "userInput", handlerTask1 )
local function handleButton4Event( event )
    if ( "ended" == event.phase ) then
	taskField1.text = currentsHour..":"..currentsMinute.."-"..currenteHour..":"..currenteMinute
 	pickerWheel1.isVisible=false
	pickerWheel2.isVisible=false
    	numericField1.isVisible=true
       	numericField2.isVisible=true
	local remote_host = "http://seikisenjo.netne.net/task.php"
	local auxdata = {}
	auxdata.headers = {}
	auxdata.headers["Authorization"] = "Basic "
	auxdata.headers["Content-Type"] = "application/x-www-form-urlencoded"
	auxdata.body = "timer="..starthash..currentsHour..currentsMinute..currenteHour..currenteMinute..donehash
	network.request( remote_host, "POST", listener4, auxdata )
    elseif ( "began" == event.phase ) then
	svalues = pickerWheel1:getValues()  
       	currentsHour = svalues[1].value
       	currentsMinute = svalues[2].value  
                 evalues = pickerWheel2:getValues()  
       	currenteHour = evalues[1].value
       	currenteMinute = evalues[2].value  
    end
end
local button4 = widget.newButton {
	defaultFile = "buttonWhite.png",
	overFile = "buttonWhiteOver.png",
	labelColor = 
	{ default = { 0, 0, 0, 255 },
	},
	font = native.systemFont,
	fontSize = 22,
	label = "Create Task",
	onEvent = handleButton4Event	
}
button4.x = display.contentCenterX; button4.y = 435
local taskStates = display.newText( "Currently: No task ", display.contentCenterX, 475, native.systemFont, 20 )
taskStates:setFillColor(0, 0, 0)
local function getStatus3 ()
local path2 = system.pathForFile( "task.txt", system.CachesDirectory)
local myFile2 = io.open( path2, "w" ) 
http.request{ 
        url = "http://seikisenjo.netne.net/task.html",  sink = ltn12.sink.file(myFile2),
}
local file2 = io.open( path2, "r" )
if file2 then
    -- read all contents of file into a string
    local contents2 = file2:read( "*a" )
    io.close( file2 )
    if contents2:match "aa:aa" then
	taskStates.text = "No task created..."
    else
	taskStates.text = "Task running!"
    end
else
    print("file not found")
end
end
getStatus3 ()
local function checkOnlineState ()      
	getStatus()
	getStatus1()
	getStatus2()
	getStatus3()
end
timer.performWithDelay( 10000, checkOnlineState, 0 )
function listener1( event )
	if ( event.isError ) then
		tab.text = "Status update failed!"
	else
		tab.text = "Currently: ON"
	end
end
function listener2( event )
	if ( event.isError ) then
		tab.text = "Status update failed!"
	else
		tab.text = "Currently: OFF"
	end
end
function listener3( event )
	if ( event.isError ) then
		timerStates.text = "Failed to set timer!"
	else
		timerStates.text = "Timer set!"
	end
end
function listener4( event )
	if ( event.isError ) then
		taskStates.text = "Failed to create task!"
	else
		taskStates.text = "Task created!"
	end
end