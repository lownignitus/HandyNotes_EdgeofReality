HandyNotes_EdgeOfReality = LibStub("AceAddon-3.0"):NewAddon("HandyNotes_EdgeOfReality", "AceBucket-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
if not HandyNotes then print"Edge of Reality requires HandyNotes to load"; return end

local db
local iconDefault = "Interface\\ICONS\\Ability_Mount_FireRavenGodMountPurple"
local textDefault = "Edge of Reality"

HandyNotes_EdgeOfReality.nodes = {}
local nodes = HandyNotes_EdgeOfReality.nodes

nodes["FrostfireRidge"] = {
    [51101986] = { "Edge of Reality"},
    [52401818] = { "Edge of Reality"},
    [53801746] = { "Edge of Reality"},
    [47702757] = { "Edge of Reality"},
--    [39002600] = { "Edge of Reality"},
}
nodes["NagrandDraenor"] = {
    [40504760] = { "Edge of Reality"},
    [44013067] = { "Edge of Reality"},
    [57302670] = { "Edge of Reality"},
--    [59501020] = { "Edge of Reality"},
}
nodes["SpiresOfArak"] = {
    [36431830] = { "Edge of Reality"},
    [47002010] = { "Edge of Reality"},
    [50400610] = { "Edge of Reality"},
    [60801123] = { "Edge of Reality"},
}
nodes["ShadowmoonValleyDR"] = {
    [41907570] = { "Edge of Reality"},
    [43797096] = { "Edge of Reality"},
    [48957026] = { "Edge of Reality"},
    [50337153] = { "Edge of Reality"},
    [49607160] = { "Edge of Reality"},
    [50907250] = { "Edge of Reality"},
    [51687485] = { "Edge of Reality"},
}
nodes["Gorgrond"] = {
    [51603880] = { "Edge of Reality"},
    [54004580] = { "Edge of Reality"},
    [56004070] = { "Edge of Reality"},
    [43303420] = { "Edge of Reality"},
--    [46902120] = { "Edge of Reality"},
}
nodes["Talador"] = {
    [39885561] = { "Edge of Reality"},
    [46265256] = { "Edge of Reality"},
    [47164882] = { "Edge of Reality"},
    [52144113] = { "Edge of Reality"},
    [52302580] = { "Edge of Reality"},
    [52623462] = { "Edge of Reality"},
    [50963241] = { "Edge of Reality"},
}

function HandyNotes_EdgeOfReality:OnEnter(mapFile, coord)
	if (not nodes[mapFile][coord]) then return end

	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
	if ( self:GetCenter() > UIParent:GetCenter() ) then
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	local text = nodes[mapFile][coord][1] or textDefault
	tooltip:SetText(text)
	tooltip:Show()
end

function HandyNotes_EdgeOfReality:OnLeave(mapFile, coord)
	if self:GetParent() == WorldMapButton then
		WorldMapTooltip:Hide()
	else
		GameTooltip:Hide()
	end
end

local options = {
	type = "group",
	name = "Edge Of Reality",
	desc = "Locations of the Edge of Reality portals.",
	get = function(info) return db[info.arg] end,
	set = function(info, v) db[info.arg] = v; HandyNotes_EdgeOfReality:Refresh() end,
	args = {
		desc = {
			type = "description",
			name = "These settings control the look and behavior of the icons.",
			order = 0,
		},
		icon_scale = {
			type = "range",
			name = "Icon Scale",
			desc = "The scale of the icons.",
			min = 0.25, max = 3, step = 0.01,
			arg = "icon_scale",
			order = 10,
		},
		icon_alpha = {
			type = "range",
			name = "Icon Alpha",
			desc = "The transparency of the icons.",
			min = 0, max = 1, step = 0.01,
			arg = "icon_alpha",
			order = 20,
		},
		showonminimap = {
			type = "toggle",
			arg = "showonminimap",
			name = "Show on Minimap",
			desc = "Show icons on minimap in addition to world map.",
			order = 30,
			width = "normal",
		},
	},
}

function HandyNotes_EdgeOfReality:OnInitialize()
	local defaults = {
		profile = {
			icon_scale = 1.0,
			icon_alpha = 1.0,
			showonminimap = false,
		},
	}

	db = LibStub("AceDB-3.0"):New("HandyNotes_EdgeOfRealityDB", defaults, true).profile
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "WorldEnter")
end

function HandyNotes_EdgeOfReality:WorldEnter()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:ScheduleTimer("RegisterWithHandyNotes", 10)
end

function HandyNotes_EdgeOfReality:RegisterWithHandyNotes()
	do
		local function iter(t, prestate)
			if not t then return nil end
			local state, value = next(t, prestate)
			while state do
				if (value[1]) then
					local icon = value[3] or iconDefault
					return state, nil, icon, db.icon_scale, db.icon_alpha
				end
				state, value = next(t, state)
			end
		end
		function HandyNotes_EdgeOfReality:GetNodes(mapFile,isMinimapUpdate, dungeonLevel)
			if isMinimapUpdate and not db.showonminimap then return function() end end
			return iter, nodes[mapFile], nil
		end
	end
	HandyNotes:RegisterPluginDB("HandyNotes_EdgeOfReality", self, options)
end

function HandyNotes_EdgeOfReality:Refresh()
	self:SendMessage("HandyNotes_NotifyUpdate", "HandyNotes_EdgeOfReality")
end