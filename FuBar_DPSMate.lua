local tablet = AceLibrary("Tablet-2.0")
local L = AceLibrary("AceLocale-2.0"):new("SWStatsFu")

DPSMateFu = AceLibrary("AceAddon-2.0"):new("FuBarPlugin-2.0", "AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0")

local optionsTable = {
	type = 'group',
	args = {
		toggle = {
			order = 1,
			type = 'toggle',
			name = "Show window",
			desc = "Show or hide DPSMate",
			set = "OnClick",
			get = "IsVisible",
		},
		lock = {
			order = 2,
			type = 'toggle',
			name = "Lock window",
			desc = DPSMate.L["lockdesc"],
			set = "LockWindow",
			get = "IsLocked",
		},
		report = {
			order = 3,
			type = 'execute',
			name = DPSMate.L["report"],
			desc = DPSMate.L["reportsegment"],
			func = function() DPSMate_Report:Show(); DPSMate.Options.Dewdrop:Close() end,
		},
		reset = {
			order = 4,
			type = 'execute',
			name = DPSMate.L["reset"],
			desc = DPSMate.L["resetdesc"],
			func = function() DPSMate_PopUp:Show(); DPSMate.Options.Dewdrop:Close() end,
		},
		configure = {
			order = 5,
			type = 'execute',
			name = DPSMate.L["config"],
			desc = DPSMate.L["config"],
			func = function() DPSMate_ConfigMenu:Show(); DPSMate.Options.Dewdrop:Close() end,
		},
		blank1 = {
			order = 6,
			type = 'header',
		},		
		hideIcon = {
			order = 7,
			type = 'toggle',
			name = "Minimap Icon",
			desc = "Minimap Icon",
			set = "ToggleHideIcon",
			get = "IsHideIcon",
		},		
	}	
}

DPSMateFu.OnMenuRequest = optionsTable
DPSMateFu:RegisterChatCommand( { "/DPSMateFu" }, optionsTable )
DPSMateFu.hasIcon = false

DPSMateFu:RegisterDB("Fubar_DPSMateFuDB")
DPSMateFu:RegisterDefaults('profile', {
	enabled = 0,
	hideIcon = true,
})

function DPSMateFu:ToggleHideIcon()
	self.db.profile.hideIcon = not self.db.profile.hideIcon;
	if (DPSMate_MiniMap) then
		if self.db.profile.hideIcon == true then
			DPSMate_MiniMap:Hide();
		else
			DPSMate_MiniMap:Show();
		end
	end	
end

function DPSMateFu:IsHideIcon()
	return not self.db.profile.hideIcon;
end

function DPSMateFu:IsVisible()
	return not DPSMateSettings["windows"][1]["hidden"];
end

function DPSMateFu:LockWindow()
	if DPSMateFu:IsLocked() then
		DPSMate.Options:Unlock();
	else
		DPSMate.Options:Lock();
	end
end

function DPSMateFu:IsLocked()
	return DPSMateSettings["lock"];
end

function DPSMateFu:OnEnable()
	for _, val in DPSMateSettings["windows"] do
		if val["hidden"] then
			getglobal("DPSMate_"..val["name"]):Hide()
		else
			getglobal("DPSMate_"..val["name"]):Show()
		end
	end
	if (DPSMate_MiniMap) then
		if self.db.profile.hideIcon == true then
			DPSMate_MiniMap:Hide();
		else
			DPSMate_MiniMap:Show();
		end
	end		
end

function DPSMateFu:OnTextUpdate()
	self:SetText("DPSMate")
end

function DPSMateFu:OnClick()
	for _, val in DPSMateSettings["windows"] do
		if val["hidden"] then
			getglobal("DPSMate_"..val["name"]):Show()
			val["hidden"] = false
		else
			getglobal("DPSMate_"..val["name"]):Hide()
			val["hidden"] = true
		end
	end
end

function DPSMateFu:OnTooltipUpdate()
	tablet:SetHint("Click to show DPSMate");
end