function LS_LoadEditBoxStats(self)
	local name = self:GetName()
	if name == "LiveStats_ConfigStatsFrame_IntEdit" then
		self:ClearFocus()
		self:SetText(math.floor(LiveStats_config[LiveStats_realm][LiveStats_char].baseInt*1.05))
	elseif name == "LiveStats_ConfigStatsFrame_SPEdit" then
		self:ClearFocus()
		self:SetText(LiveStats_config[LiveStats_realm][LiveStats_char].baseSP+math.floor(LiveStats_config[LiveStats_realm][LiveStats_char].baseInt*1.05))	
	elseif name == "LiveStats_ConfigStatsFrame_HasteEdit" then
		self:ClearFocus()
		self:SetText(LiveStats_config[LiveStats_realm][LiveStats_char].baseHaste)	
	elseif name == "LiveStats_ConfigStatsFrame_CritEdit" then
		self:ClearFocus()
		self:SetText(LiveStats_config[LiveStats_realm][LiveStats_char].baseCrit)
	elseif name == "LiveStats_ConfigStatsFrame_MastEdit" then
		self:ClearFocus()
		self:SetText(LiveStats_config[LiveStats_realm][LiveStats_char].baseMast)	
	end
end

function LS_EditBoxChangedStats(self)
	local name = self:GetName()
	local value = self:GetNumber()
	if name == "LiveStats_ConfigStatsFrame_IntEdit" then
		LiveStats_config[LiveStats_realm][LiveStats_char].baseInt = math.floor(value/1.05)
	elseif name == "LiveStats_ConfigStatsFrame_SPEdit" then
		LiveStats_config[LiveStats_realm][LiveStats_char].baseSP = value-math.floor(LiveStats_config[LiveStats_realm][LiveStats_char].baseInt*1.05)
	elseif name == "LiveStats_ConfigStatsFrame_HasteEdit" then
		LiveStats_config[LiveStats_realm][LiveStats_char].baseHaste = value
	elseif name == "LiveStats_ConfigStatsFrame_CritEdit" then
		LiveStats_config[LiveStats_realm][LiveStats_char].baseCrit = value
	elseif name == "LiveStats_ConfigStatsFrame_MastEdit" then
		LiveStats_config[LiveStats_realm][LiveStats_char].baseMast = value
	end
end