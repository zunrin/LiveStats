local Graph = LibStub:GetLibrary("LibGraph-2.0")
LS = {}
local realTickRate = 0
local dotStats = {}
local dotTicks = {}
local curTime = 0
local lastUpdate = 0
local times = {}
local multiplier = {}
LiveStats_variables_loaded = false
LiveStats_realm = GetCVar("realmName")
LiveStats_char = UnitName("player");
local LiveStats_default_on = true;
local LiveStats_default_posX = 0;
local LiveStats_default_posY = -355;
local LiveStats_default_sizeX = 250;
local LiveStats_default_sizeY = 125;
local LiveStats_default_statsColor = {1,0,0};
local LiveStats_default_int = 19984;
local LiveStats_default_SP = 10859;
local LiveStats_default_haste = 13754;
local LiveStats_default_crit = 5763;
local LiveStats_default_mast = 6065;
SLASH_LIVESTATS1 = '/livestats'
local ATMemory = {}


function SlashCmdList.LIVESTATS(msg, editbox)
	LiveStats_ConfigFrame:Show();
	-- print(LiveStats_variables_loaded)
end


local allBuffs = {	
	[1459] = {{"SP Unique", 10},{"Crit Unique", 5}}, --Arcane intel
	[61316] = {{"SP Unique", 10},{"Crit Unique", 5}}, --Dalaran intel
	[77747] = {{"SP Unique", 10}}, -- Burning Wrath
	[109773] = {{"SP Unique", 10}}, -- Dark Intent
	[126309] = {{"SP Unique", 10},{"Crit Unique", 5}}, -- Still Water
	[24932] = {{"Crit Unique", 5}}, -- Leader of the Pack
	[24604] = {{"Crit Unique", 5}}, -- Furious Howl
	[90309] = {{"Crit Unique", 5}}, -- Terrifying Roar
	[116781] = {{"Crit Unique", 5}}, -- Legacy of the White Tiger
	[1126] = {{"Int Unique", 5}}, -- MotW
	[90363] = {{"Int Unique", 5}}, -- Embrace of the Shale Spider
	[115921] = {{"Int Unique", 5}}, -- Legacy of the Emperor
	[20217] = {{"Int Unique", 5}}, -- Kings
	[15473] = {{"Haste Unique", 5}}, -- Shadowform
	[49868] = {{"Haste Unique", 5}}, -- Mind Quickening
	[24907] = {{"Haste Unique", 5}}, -- Moonkin 
	[51470] = {{"Haste Unique", 5}}, -- Elemental Oath
	[93435] = {{"Mast Unique", 3000}}, -- Roar of Courage
	[128997] = {{"Mast Unique", 3000}}, -- Spirit Beast Blessing
	[19740] = {{"Mast Unique", 3000}}, -- Blessing of Might
	[116956] = {{"Mast Unique", 3000}}, -- Grace of Air
	
	[110909] = {{"Alter Time", 0}}, --Alter time
	[138317] = {{"Haste r", 1800},{"Crit r", 1800},{"Mast r", 1800}}, --Alter time tier
	[7302] = {{"Haste %", 7}}, --Frost Armor
	[6117] = {{"Mast r", 3000}}, --Mage Armor
	[30482] = {{"Crit %", 5}}, --Molten Armor
	[116257] = {{"SP %", 15}}, --Invocation
	[89744] = {{"Int %", 5}}, --Wizardry
	
	[123254] = {{"SP %", 15}}, --Twist of Fate
	[10060] = {{"SP %", 5},{"Haste %", 20}}, --PI
	[588] = {{"SP %", 10}}, --Inner Fire
	[89745] = {{"Int %", 5}}, --Mysticism
	
	[113860] = {{"Haste %", 30}}, -- Misery
	[86091] = {{"Int %", 5}}, --Nethermancy	
	
	[137590] = {{"Haste %", 30}}, --Lego Gem
	[139133] = {{"Int r", 7903}}, --Cha-Ye (nm)
	[104993] = {{"Int r", 1650}}, -- Jade Spirit
	[125487] = {{"Int r", 2000}}, -- Lightweave
	[138786] = {{"Int s", "Electrified", 1, 10}}, -- Wusholay (nm)
	[138703] = {{"Haste r", 9483}}, -- Volatile Talisman (nm)
	[138964] = {{"Crit %", 100}}, -- UVLS
	
	[26297] = {{"Haste %", 20}}, -- Berserking
	
	[80353] = {{"Haste %", 30}}, -- TW
	[2825] = {{"Haste %", 30}}, -- BL
	
	[105702] = {{"Int r", 4000}}, -- Jade Pot
	[105691] = {{"Int r", 1000}}, -- Int flask
	[104277] = {{"Int r", 300}}, -- Mogu fish
	[138898] = {{"Int r", 7903}}, -- Breath of the Hydra (nm)
	[96230] = {{"Int r", 1920}} --Engi synapse springs
}

local allDots = {[114923]={1,12}, -- Nether Tempest
					[44457]={3,12}, -- Living Bomb
					
					[589]={3,15}, -- SW:P
					[34914]={3,18}, -- Vamp Touch
					
					[980]={2,24}, -- Agony
					[30108]={2,14}, -- Unstable Affliction
					[172]={2,18}, -- Corruption
					[348]={3,15}, -- Immolate
					
	

}

local buffList = {}
local dotList = {}

function LS:updateTrackedBuffs()
	-- print("updating buffs")
	buffList = {}
	for spellId, isTracked in pairs(LiveStats_config[LiveStats_realm][LiveStats_char].buffsToTrack) do
		if isTracked then
			buffList[spellId] = allBuffs[spellId]
		end
	end
end

function LS:updateTrackedDots()
	-- print("updating dots")
	dotList = {}
	for spellId, isTracked in pairs(LiveStats_config[LiveStats_realm][LiveStats_char].dotsToTrack) do
		if isTracked then
			dotList[spellId] = allDots[spellId]
		end
	end
end

function LS:UpdatePosSize()
	local posX = LiveStats_config[LiveStats_realm][LiveStats_char].posX
	local posY = LiveStats_config[LiveStats_realm][LiveStats_char].posY
	g:SetPoint("CENTER",UIParent,"CENTER",posX,posY)
	local width = LiveStats_config[LiveStats_realm][LiveStats_char].sizeX
	local height = LiveStats_config[LiveStats_realm][LiveStats_char].sizeY
	g:SetWidth(width)
	g:SetHeight(height)
	if #multiplier ~= 0 then
		LS:UpdateGraph()		
	end
end


local gearInt, gearHaste, gearCrit = 0

function LS:UpdateGraph()
	lastUpdate = curTime

	local dotsData = {}
	local dotId = 0
	local dotInfo = {}
	for dotId,dotInfo in pairs(dotTicks) do
		local singleDot = {}
		for count=1,51,1 do
			if #dotInfo>0 and curTime+times[count]<dotInfo[#dotInfo] then
				table.insert(singleDot,{times[count],dotStats[dotId]})
			end
		end
		if #dotInfo>0 and curTime<dotInfo[#dotInfo] then
			table.insert(singleDot,{dotInfo[#dotInfo]-curTime,dotStats[dotId]})		
		end
		dotsData[dotId] = singleDot
	end
	
	local statsData={}
	for count = 1,51,1	do
		table.insert(statsData,{times[count],multiplier[count]})
	end
	
	
	g:ResetData()
	
	local statsColor = LiveStats_config[LiveStats_realm][LiveStats_char].statsColor
	local statsColorRGBA = {statsColor[1],statsColor[2],statsColor[3],0.8}
	g:AddDataSeries(statsData,statsColorRGBA)
	
	for dotId,dotInfo in pairs(dotTicks) do
		local dotColorRGB = LiveStats_config[LiveStats_realm][LiveStats_char].dotsColor[dotId]
		local dotColor = {dotColorRGB[1],dotColorRGB[2],dotColorRGB[3],0.8}
		g:AddDataSeries(dotsData[dotId],dotColor)
		if #dotInfo>0 and curTime<dotInfo[#dotInfo] then
			for k,v in pairs(dotInfo) do
				if v-curTime>0 then 
					local Data3={{v-curTime,0},{v-curTime,dotStats[dotId]}}
					g:AddDataSeries(Data3,dotColor)
				else
					--break
				end
			end	
		end
	end


end

function LS:OnLoad()
	g=Graph:CreateGraphLine("TestLineGraph",UIParent,"CENTER","CENTER",0,-355,250,125)
	g:SetXAxis(0,10)
	g:SetYAxis(0,300)
	g:SetGridSpacing(1,25)
	g:SetGridColor({0.5,0.5,0.5,0.5})
	g:SetAxisDrawing(true,true)
	g:SetAxisColor({1.0,1.0,1.0,1.0})
	g:LockXMin()
	g:LockXMax()
	g:LockYMin()
	g:SetAutoScale(true)
	
	g.text = g:CreateFontString(nil,"ARTWORK") 
	g.text:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
	g.text:SetPoint("CENTER",0,-50)
end

function LiveStats_VARIABLES_LOADED()
	if not LiveStats_config then
		LiveStats_config = {}
	end
	if not LiveStats_config[LiveStats_realm] then
		LiveStats_config[LiveStats_realm] = {}
	end
	if not LiveStats_config[LiveStats_realm][LiveStats_char] then
		LiveStats_config[LiveStats_realm][LiveStats_char] = {}
	end
	if not LiveStats_config[LiveStats_realm][LiveStats_char].on then
		LiveStats_config[LiveStats_realm][LiveStats_char].on = LiveStats_default_on
	end
	if not LiveStats_config[LiveStats_realm][LiveStats_char].posX then
		LiveStats_config[LiveStats_realm][LiveStats_char].posX = LiveStats_default_posX
	end
	if not LiveStats_config[LiveStats_realm][LiveStats_char].posY then
		LiveStats_config[LiveStats_realm][LiveStats_char].posY = LiveStats_default_posY
	end
	if not LiveStats_config[LiveStats_realm][LiveStats_char].sizeX then
		LiveStats_config[LiveStats_realm][LiveStats_char].sizeX = LiveStats_default_sizeX
	end
	if not LiveStats_config[LiveStats_realm][LiveStats_char].sizeY then
		LiveStats_config[LiveStats_realm][LiveStats_char].sizeY = LiveStats_default_sizeY
	end
	
	if not LiveStats_config[LiveStats_realm][LiveStats_char].statsColor then
		LiveStats_config[LiveStats_realm][LiveStats_char].statsColor = LiveStats_default_statsColor
	end
	
	if not LiveStats_config[LiveStats_realm][LiveStats_char].buffsToTrack then
		local buffsToTrack = {[1459]=true,
								[110909]=true,
								[138317]=true,
								[7302]=true,
								[116257]=true,
								[137590]=true,
								[139133]=true,
								[104993]=true,
								[125487]=true,
								[138786]=true,
								[26297]=true,
								[80353]=true,
								[105702]=true,
								[105691]=true,
								[104277]=true,
								[138898]=true,
								[96230]=true,
								[24932]=true,
								[24604]=true,
								[1126]=true,
								[77747]=true,
								[15473]=true,
								[109773]=true,
								[126309]=true,
								[24907]=true,
								[49868]=true,
								[51470]=true,
								[90309]=true,
								[116781]=true,
								[93435]=true,
								[128997]=true,
								[19740]=true,
								[116956]=true,
								[90363]=true,
								[115921]=true,
								[20217]=true,
								[138703]=true,
								[61316]=true,
								[6117]=true,
								[30482]=true,
								[138964]=true,
								[123254]=true,
								[10060]=true,
								[588]=true,
								[89745]=true,
								[113860]=true,
								[86091]=true,
								[2825]=true}
		LiveStats_config[LiveStats_realm][LiveStats_char].buffsToTrack = buffsToTrack
	end
	-- LiveStats_config[LiveStats_realm][LiveStats_char].buffsToTrack[123254]=true
	
	if not LiveStats_config[LiveStats_realm][LiveStats_char].dotsToTrack then
		local dotsToTrack = {[114923]=false, --NT
								[44457]=false, --LB
								[34914]=false, --VT
								[589]=false, --SWP
								[980]=false,
								[30108]=false,
								[172]=false,
								[348]=false}
		LiveStats_config[LiveStats_realm][LiveStats_char].dotsToTrack = dotsToTrack
	end
	-- LiveStats_config[LiveStats_realm][LiveStats_char].dotsToTrack[980]=false
	
	if not LiveStats_config[LiveStats_realm][LiveStats_char].dotsColor then
		local dotsColor = {[114923]={1,0,0}, --NT
								[44457]={1,1,0}, --LB
								[34914]={0,1,0}, --VT
								[589]={0,1,1}, --SWP
								[980]={0,0,1},
								[30108]={1,0,1},
								[172]={1,0,1},
								[348]={1,0,1}}
		LiveStats_config[LiveStats_realm][LiveStats_char].dotsColor = dotsColor
	end
	-- LiveStats_config[LiveStats_realm][LiveStats_char].dotsColor[980]={1,0,1}
	
	if not LiveStats_config[LiveStats_realm][LiveStats_char].baseInt then
		LiveStats_config[LiveStats_realm][LiveStats_char].baseInt = LiveStats_default_int
	end
	if not LiveStats_config[LiveStats_realm][LiveStats_char].baseSP then
		LiveStats_config[LiveStats_realm][LiveStats_char].baseSP = LiveStats_default_SP
	end
	if not LiveStats_config[LiveStats_realm][LiveStats_char].baseHaste then
		LiveStats_config[LiveStats_realm][LiveStats_char].baseHaste = LiveStats_default_haste
	end
	if not LiveStats_config[LiveStats_realm][LiveStats_char].baseCrit then
		LiveStats_config[LiveStats_realm][LiveStats_char].baseCrit = LiveStats_default_crit
	end
	if not LiveStats_config[LiveStats_realm][LiveStats_char].baseMast then
		LiveStats_config[LiveStats_realm][LiveStats_char].baseMast = LiveStats_default_mast
	end
	LiveStats_variables_loaded = true
	LS:ConfigChange()
	
	LS:updateTrackedBuffs()
	LS:updateTrackedDots()
	LS:UpdatePosSize()
end

function LS:ConfigChange()
	if not LiveStats_variables_loaded then
		LiveStats_Frame:Hide()
		return
	end
	-- print(LiveStats_config[LiveStats_realm][LiveStats_char].on)
	if LiveStats_config[LiveStats_realm][LiveStats_char].on then
		LiveStats_Frame:Show()
		g:Show()
	else
		LiveStats_Frame:Hide()
		g:Hide()
		-- print("turn off?")
	end
	-- print("Hello")
end

function SpellSent(self, event, ...)
	if event=="VARIABLES_LOADED" then
		LiveStats_VARIABLES_LOADED()
	end
	if LiveStats_config[LiveStats_realm][LiveStats_char].on then
		local arg1, arg2, arg3, arg4, arg5= ...
		curTime = GetTime()
		if arg1 ~= "player" and curTime - lastUpdate<0.2 then
			return {}
		end
		
		-- print("updating"..curTime)
		local dotCasted = false
		local ATCasted = false
		local baseTickRate = 0
		local baseDuration = 0
		
		for dotId, dotInfo in pairs(dotList) do
			if dotId == arg5 and arg1=="player" then
				dotCasted = true
				baseTickRate = dotInfo[1]
				baseDuration = dotInfo[2]
			end		
		end
		-- IF AT WAS CASTED
		if arg5 ==  108978 and arg1=="player" then
			ATCasted = true
		end
		
		--LAZY HARD CODED DATA
		local baseSP = LiveStats_config[LiveStats_realm][LiveStats_char].baseSP --spreadsheet-int == weapon duh
		local baseInt = LiveStats_config[LiveStats_realm][LiveStats_char].baseInt --spreadsheet/1.05
		local baseHaste = LiveStats_config[LiveStats_realm][LiveStats_char].baseHaste --spreadsheet
		local baseCrit = LiveStats_config[LiveStats_realm][LiveStats_char].baseCrit --spreadsheet
		local baseMast = LiveStats_config[LiveStats_realm][LiveStats_char].baseMast --spreadsheet
		
		--INITIATE GROUP BUFFS (unique)
		local statsUnique = false
		local spUnique = false
		local hasteUnique = false
		local critUnique = false
		local mastUnique = false
		
		local alterTimeLeft = 1000
		
		--INITIALIZE INTERMEDIATE TABLES
		times = {}
		local intR = {}
		local spR = {}
		local critR = {}
		local hasteR = {}
		local mastR = {}
		local hasteP = {}
		local critP = {}
		local spP = {}
		local intP = {}
		local mastP = {}
		for count = 0,50,1	do
			table.insert(times,count*0.2)
			table.insert(intR,baseInt)
			table.insert(spR,baseSP)
			table.insert(hasteR,baseHaste)
			table.insert(critR,baseCrit)
			table.insert(mastR,baseMast)
			table.insert(hasteP,1)
			table.insert(critP,1)
			table.insert(spP,1)
			table.insert(intP,1.05)	
			table.insert(mastP,1)	
		end
		
		--CHECK BUFFS AND FILL IN INTERMEDIATE TABLES
		local i = 1
		local buff,_,_,_,_,_,tEnd,_,_,_,id,_,_,_,_ = UnitBuff("player", i)
		while buff do
			tLeft = tEnd - curTime
			for bId, bInfo in pairs(buffList) do
				if id == bId then
					for i,v in pairs(bInfo) do
					
						--PERCENTAGES
						if v[1] == "SP %" then
							for count = 0,50,1 do
								if count*.2 < tLeft then
									spP[count+1] = spP[count+1]*(1+v[2]/100)
								end
							end
						end
						if v[1] == "Int %" then
							for count = 0,50,1 do
								if count*.2 < tLeft then
									intP[count+1] = intP[count+1]*(1+v[2]/100)
								end
							end
						end
						if v[1] == "Crit %" then
							for count = 0,50,1 do
								if count*.2 < tLeft then
									critP[count+1] = critP[count+1]+v[2]/100
								end
							end
						end
						if v[1] == "Haste %" then
							for count = 0,50,1 do
								if count*.2 < tLeft or tEnd == 0 then
									hasteP[count+1] = hasteP[count+1]*(1+v[2]/100)
								end
							end
						end
						if v[1] == "Mast %" then
							for count = 0,50,1 do
								if count*.2 < tLeft or tEnd == 0 then
									mastP[count+1] = mastP[count+1]*(1+v[2]/100)
								end
							end
						end
						
						
						--RATINGS
						if v[1] == "Mast r" then
							for count = 0,50,1 do
								if count*.2 < tLeft then
									mastR[count+1] = mastR[count+1]+v[2]
								end
							end
						end
						if v[1] == "Int r" then
							for count = 0,50,1 do
								if count*.2 < tLeft then
									intR[count+1] = intR[count+1]+value
								end
							end
						end
						if v[1] == "Crit r" then
							for count = 0,50,1 do
								if count*.2 < tLeft then
									critR[count+1] = critR[count+1]+v[2]
								end
							end
						end
						if v[1] == "Haste r" then
							for count = 0,50,1 do
								if count*.2 < tLeft then
									hasteR[count+1] = hasteR[count+1]+v[2]
								end
							end
						end
						
						--GROUP BUFFS
						if v[1] == "Mast Unique" and not mastUnique then
							mastUnique = true
							for count = 0,50,1 do
								mastR[count+1] = mastR[count+1]+v[2]
							end
						end
						if v[1] == "SP Unique" and not spUnique then
							spUnique = true
							for count = 0,50,1 do
								spP[count+1] = spP[count+1]*(1+v[2]/100)
							end
						end
						if v[1] == "Crit Unique" and not critUnique then
							critUnique = true
							for count = 0,50,1 do
								critP[count+1] = critP[count+1]+v[2]/100
							end
						end
						if v[1] == "Int Unique" and not statsUnique then
							statsUnique = true
							for count = 0,50,1 do
								intP[count+1] = intP[count+1]*(1+v[2]/100)
							end
						end
						if v[1] == "Haste Unique" and not hasteUnique then
							statsUnique = true
							for count = 0,50,1 do
								hasteP[count+1] = hasteP[count+1]*(1+v[2]/100)
							end
						end
						
						--ALTER TIME MESS
						if v[1] == "Alter Time" and tLeft>0 then
							alterTimeLeft = tLeft
						end
						
						--WUSHOLAY SHIT
						if v[1] == "Int s" then
							for count = 0,50,1 do
								local _,_,_,stacks,_,_,_,_,_,_,_,_,_,_,value = UnitBuff("player", v[2])
								local valuePerS = value/stacks
								if count*.2 < tLeft then
									intR[count+1] = intR[count+1]+valuePerS*floor((v[4]-tLeft+.2*count)/v[3])
								end
							end
						end
						
					end
				end
			end
					
			i = i + 1;
			buff,_,_,_,_,_,tEnd,_,_,_,id,_,_,_,value = UnitBuff("player", i)
		end
		
		
		--SPE USEFUL FOR MAST AND MULTIPLIER
		local spec = GetSpecialization()
		local specName = ""
		if spec~=nil then
			_,specName = GetSpecializationInfo(spec)
		end
		local mastRP = 1
		
		multiplier = {}
		--CALCULATE MULTIPLIER FROM STATS
		for count = 0,50,1	do
			local trueCount = count
			if count*.2>alterTimeLeft then
				trueCount = count-math.floor(alterTimeLeft/0.2)
				-- print(trueCount)
				-- print(alterTimeLeft)
				table.insert(multiplier,ATMemory[trueCount])
			else
				local hasteRP = (1+hasteR[trueCount+1]/425/100)*hasteP[trueCount+1]
				local critRP = math.min((intR[trueCount+1]*intP[trueCount+1]/2278+critR[trueCount+1]/600)/100+critP[trueCount+1],2)
				local spRP = (intR[trueCount+1]*intP[trueCount+1]+spR[trueCount+1])*spP[trueCount+1]
				if specName == "Shadow" then
					mastRP = (1.144+mastR[trueCount+1]/334/100)*mastP[trueCount+1]
				elseif specName == "Affliction" then
					mastRP = (1.248+mastR[trueCount+1]/193.5/100)*mastP[trueCount+1]				
				elseif specName == "Demonology" then
					mastRP = (1.08+mastR[trueCount+1]/600/100)*mastP[trueCount+1]
				elseif specName == "Destruction" then
					mastRP = ((1.08+mastR[trueCount+1]/200/100)*3/8)*mastP[trueCount+1]
				end
				
				table.insert(multiplier,hasteRP*critRP*spRP*mastRP/1000)		
			
			end	
		end
		
		
		--DEFAULT_CHAT_FRAME:AddMessage(multiplier[1]);
		--DEFAULT_CHAT_FRAME:AddMessage((1+hasteR[1]/425/100)*hasteP[1]);
		--DEFAULT_CHAT_FRAME:AddMessage((intR[1]*intP[1]/2278+critR[1]/600)/100+critP[1]);
		--DEFAULT_CHAT_FRAME:AddMessage((intR[1]*intP[1]+spR[1])*spP[1]);
		
		if dotCasted then
			singleDot = {}
			local hasteRP = (1+hasteR[1]/425/100)*hasteP[1]
			realTickRate = baseTickRate/hasteRP
			dotStats[arg5] = multiplier[1]
			for count = 0,math.floor(baseDuration/realTickRate+0.5),1 do
				table.insert(singleDot,curTime + count*realTickRate)
			end
			dotTicks[arg5]=singleDot
		end
		
		if ATCasted then
			ATMemory = multiplier
		end
		g.text:SetText(multiplier[1])
		
		LS:UpdateGraph()
	end
end