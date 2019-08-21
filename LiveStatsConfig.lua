 function LiveStatsConfigFrameOnShow()
	-- make sure our profile has been loaded
	if ( not LiveStats_variables_loaded ) then -- config not loaded
		LiveStats_ConfigFrame:Hide(); -- hide our config pane
		return;
	end
	-- read settings from profile, and change our checkbuttons and slider to represent them
	getglobal(LiveStats_ConfigFrame:GetName().."_ButtonOn"):SetChecked( LiveStats_config[LiveStats_realm][LiveStats_char].on )
	--getglobal(LiveStats_Config_Frame:GetName().."_ButtonTime24"):SetChecked( LiveStats_config[LiveStats_realm][LiveStats_char].time24 );		
	--getglobal(LiveStats_Config_Frame:GetName().."_SliderOffset"):SetValue(LiveStats_config[LiveStats_realm][LiveStats_char].offset);
 end
 
 function LiveStatsOnToggle()
	-- make sure our profile has been loaded
	if ( not LiveStats_variables_loaded ) then -- config not loaded
		LiveStats_ConfigFrame:GetParent():Hide() -- hide our config pane (this is now a checkbox)
		return
	end
	LiveStats_config[LiveStats_realm][LiveStats_char].on = not LiveStats_config[LiveStats_realm][LiveStats_char].on 
	LS:ConfigChange()
 end
 
 function LiveStatsConfigBuffsShow()
	LiveStats_ConfigBuffsFrame:Show();  
 end
  
 function LiveStatsConfigDotsShow()
	LiveStats_ConfigDotsFrame:Show();  
 end
 
 function LiveStatsConfigStatsShow()
	LiveStats_ConfigStatsFrame:Show();  
 end
 
 function LiveStatsConfigLoveShow()
	LiveStats_ConfigLoveFrame:Show();  
 end
 
function LS_LoadEditBox(self)
	local name = self:GetName()
	if name == "LiveStats_ConfigFrame_PosXEdit" then
		self:ClearFocus()
		self:SetText(LiveStats_config[LiveStats_realm][LiveStats_char].posX)
	elseif name == "LiveStats_ConfigFrame_PosYEdit" then
		self:ClearFocus()
		self:SetText(LiveStats_config[LiveStats_realm][LiveStats_char].posY)	
	elseif name == "LiveStats_ConfigFrame_SizeXEdit" then
		self:ClearFocus()
		self:SetText(LiveStats_config[LiveStats_realm][LiveStats_char].sizeX)	
	elseif name == "LiveStats_ConfigFrame_SizeYEdit" then
		self:ClearFocus()
		self:SetText(LiveStats_config[LiveStats_realm][LiveStats_char].sizeY)	
	end
end

function LS_EditBoxChanged(self)
	local name = self:GetName()
	local value = self:GetNumber()
	if name == "LiveStats_ConfigFrame_PosXEdit" then
		LiveStats_config[LiveStats_realm][LiveStats_char].posX = value
	elseif name == "LiveStats_ConfigFrame_PosYEdit" then
		LiveStats_config[LiveStats_realm][LiveStats_char].posY = value
	elseif name == "LiveStats_ConfigFrame_SizeXEdit" then
		LiveStats_config[LiveStats_realm][LiveStats_char].sizeX = value
	elseif name == "LiveStats_ConfigFrame_SizeYEdit" then
		LiveStats_config[LiveStats_realm][LiveStats_char].sizeY = value	
	end
	LS:UpdatePosSize()
	--LS:UpdateGraph()
end