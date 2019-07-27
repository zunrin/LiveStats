local nmBuffs = 37

local listAllBuffs = {
	{1459,"Arcane Brilliance"},
	{61316,"Dalaran Brilliance"},
	{77747,"Burning Wrath"},
	{109773,"Dark Inten"},
	{126309,"Still Water"},
	{24932,"Leader of the Pack"},
	{24604,"Furious Howl"},
	{90309,"Terrifying Roar"},
	{116781,"Legacy of the White Tiger"},
	{1126,"Mark of the Wild"},
	{90363,"Embrace of the Shale Spider"},
	{115921,"Legacy of the Emperor"},
	{20217,"Blessing of Kings"},
	{15473,"Shadowform"},
	{49868,"Mind Quickening"},
	{24907,"Moonkin Aura"},
	{51470,"Elemental Oath"},
	{93435,"Roar of Courage"},
	{128997,"Spirit Beast Blessing"},
	{19740,"Blessing of Might"},
	{116956,"Grace of Air"},
	
	{26297,"Berserking"},
	{80353,"TW"},
	
	{105702,"Jade Pot"},
	{105691,"Int flask"},
	{104277,"Mogu fish"},
	
	{110909,"Alter Time"},
	{7302,"Frost Armor"},
	{6117,"Mage Armor"},
	{30482,"Molten Armor"},
	{116257,"Invocation"},	
	{89744,"Wizardry"},
	
	{138703,"Volatile Talisman of the Shado Pan"},
	{139133,"Cha-Ye"},
	{138898,"Breath of the Hydra"},
	{138786,"Wusholay"},
	{138317,"Alter time tier"},
		
	{137590,"Lego Gem"},
	{104993,"Jade Spirit"},
	
	{125487,"Lightweave"},
	{96230,"Engi synapse springs"}
}
	


function LS_UpdateScrollBuffs()
	local line; -- 1 through 5 of our window to scroll
	local lineplusoffset; -- an index into our data calculated from the scroll offset
	FauxScrollFrame_Update(LiveStats_ConfigBuffsFrame_ScrollFrame,nmBuffs,10,25)
	for line=1,10 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(LiveStats_ConfigBuffsFrame_ScrollFrame)
		if lineplusoffset <= nmBuffs then
			getglobal("LS_BuffsEntry"..line.."Check"):SetChecked(LiveStats_config[LiveStats_realm][LiveStats_char].buffsToTrack[listAllBuffs[lineplusoffset][1]])
			getglobal("LS_BuffsEntry"..line.."CheckText"):SetText(listAllBuffs[lineplusoffset][2])
			getglobal("LS_BuffsEntry"..line):Show()
		else
			getglobal("LS_BuffsEntry"..line):Hide()
		end
	end
end

function LS_ToggleBuff(self)
	local line
	local lineplusoffset
	local entryName = self:GetParent():GetName()
	for line=1,10 do
		if entryName==("LS_BuffsEntry"..line) then
			lineplusoffset = line + FauxScrollFrame_GetOffset(LiveStats_ConfigBuffsFrame_ScrollFrame)
			LiveStats_config[LiveStats_realm][LiveStats_char].buffsToTrack[listAllBuffs[lineplusoffset][1]] = not LiveStats_config[LiveStats_realm][LiveStats_char].buffsToTrack[listAllBuffs[lineplusoffset][1]]
			LS:updateTrackedBuffs()
			return
		end
	end
end

