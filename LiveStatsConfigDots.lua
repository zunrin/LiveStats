local nmDots = 0
local dotIndex = 0
local colorEntry

local listAllDots = {
	{114923,"Nether Tempest","MAGE"},
	{44457,"Living Bomb","MAGE"},
	{589,"Vampiric Touch","PRIEST"},
	{34914,"Shadow Word: Pain","PRIEST"},
	{116257,"Invocation","WARLOCK"},
	{137590,"Lego Gem","SHAMAN"}
}

local classDots = {}

function LS_UpdateScrollDots()
	local line; -- 1 through 5 of our window to scroll
	local lineplusoffset; -- an index into our data calculated from the scroll offset
	FauxScrollFrame_Update(LiveStats_ConfigDotsFrame_ScrollFrame,nmDots,10,25)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(LiveStats_ConfigDotsFrame_ScrollFrame)
		if lineplusoffset <= nmDots then
			getglobal("LS_DotsEntry"..line.."Check"):SetChecked(LiveStats_config[LiveStats_realm][LiveStats_char].dotsToTrack[classDots[lineplusoffset][1]])
			print(classDots[lineplusoffset][1])
			getglobal("LS_DotsEntry"..line.."ColorSwatchBg"):SetTexture(LiveStats_config[LiveStats_realm][LiveStats_char].dotsColor[classDots[lineplusoffset][1]][1],
																LiveStats_config[LiveStats_realm][LiveStats_char].dotsColor[classDots[lineplusoffset][1]][2],
																LiveStats_config[LiveStats_realm][LiveStats_char].dotsColor[classDots[lineplusoffset][1]][3])
			getglobal("LS_DotsEntry"..line.."CheckText"):SetText(classDots[lineplusoffset][2])
			getglobal("LS_DotsEntry"..line):Show()
		else
			getglobal("LS_DotsEntry"..line):Hide()
		end
	end
end

function LS_ToggleDot(self)
	local line
	local lineplusoffset
	local entryName = self:GetParent():GetName()
	for line=1,10 do
		if entryName==("LS_DotsEntry"..line) then
			lineplusoffset = line + FauxScrollFrame_GetOffset(LiveStats_ConfigDotsFrame_ScrollFrame)
			LiveStats_config[LiveStats_realm][LiveStats_char].dotsToTrack[classDots[lineplusoffset][1]] = not LiveStats_config[LiveStats_realm][LiveStats_char].dotsToTrack[classDots[lineplusoffset][1]]
			LS:updateTrackedDots()
			return
		end
	end
end

function LS_UpdateClass()
	local _,class,_ = UnitClass("player")
	getglobal("LiveStats_ConfigDotsFrame_Text"):SetText("Hey! You're a "..class.."!!  D:  Choose which dots u wanna track")
	
	classDots = {}
	nmDots = 0
	local dotInfo	
	for _,dotInfo in pairs(listAllDots) do
		if(dotInfo[3]==class) then
			table.insert(classDots,dotInfo)
			nmDots = nmDots+1
		end
	end
	LS_UpdateScrollDots()
	
end

function changedCallback()

	local r,g,b = ColorPickerFrame:GetColorRGB()
	if colorEntry == "LS_DotsEntryStats" then
		LiveStats_config[LiveStats_realm][LiveStats_char].statsColor[1] = r
		LiveStats_config[LiveStats_realm][LiveStats_char].statsColor[2] = g
		LiveStats_config[LiveStats_realm][LiveStats_char].statsColor[3] = b
		LS_TestOut()
	else
		LiveStats_config[LiveStats_realm][LiveStats_char].dotsColor[classDots[dotIndex][1]][1] = r
		LiveStats_config[LiveStats_realm][LiveStats_char].dotsColor[classDots[dotIndex][1]][2] = g
		LiveStats_config[LiveStats_realm][LiveStats_char].dotsColor[classDots[dotIndex][1]][3] = b
		LS_UpdateScrollDots()
	end
end


function LS_OpenColorPicker(self)
	local line
	colorEntry = self:GetParent():GetName()
	local r,g,b
	if colorEntry == "LS_DotsEntryStats" then
		r = LiveStats_config[LiveStats_realm][LiveStats_char].statsColor[1]
		g = LiveStats_config[LiveStats_realm][LiveStats_char].statsColor[2]
		b = LiveStats_config[LiveStats_realm][LiveStats_char].statsColor[3]
	else
		for line=1,10 do
			if colorEntry==("LS_DotsEntry"..line) then
				dotIndex = line + FauxScrollFrame_GetOffset(LiveStats_ConfigDotsFrame_ScrollFrame)
			end
		end
		
		r = LiveStats_config[LiveStats_realm][LiveStats_char].dotsColor[classDots[dotIndex][1]][1]
		g = LiveStats_config[LiveStats_realm][LiveStats_char].dotsColor[classDots[dotIndex][1]][2]
		b = LiveStats_config[LiveStats_realm][LiveStats_char].dotsColor[classDots[dotIndex][1]][3]
	end
	
	ColorPickerFrame:SetColorRGB(r,g,b);
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
	ColorPickerFrame.previousValues = {r,g,b,a};
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
		changedCallback, changedCallback, changedCallback;
	ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
	ColorPickerFrame:Show();
end

function LS_TestOut()
	getglobal("LS_DotsEntryStatsColorSwatchBg"):SetTexture(LiveStats_config[LiveStats_realm][LiveStats_char].statsColor[1],
						LiveStats_config[LiveStats_realm][LiveStats_char].statsColor[2],
						LiveStats_config[LiveStats_realm][LiveStats_char].statsColor[3])
end