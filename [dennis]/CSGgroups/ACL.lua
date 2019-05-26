local groupRanks = { ["Guest"]=0, ["Member"]=1, ["Steward"]=2, ["Manager"]=3, ["Deputy Leader"]=4, ["Group Leader"]=5 }
local ranknumberTorankname = { [0]="Guest", [1]="Member", [2]="Steward", [3]="Manager", [4]="Deputy Leader", [5]="Group Leader" }

-- If you set a rank all ACL right all ranks above them one you used are able to use the function
-- Use 999 if you want to set something only usable for users not in a group
-- Use 888 if the option shouldn't be usable for group founders

function getGroupRankACL ()
	return groupRanks
end

function ranknumberToName ()
	return ranknumberTorankname
end

function getGroupsACL ()
	local CSGGroupsGUI = getGroupsTableGUI ()
	local groupACL = {
		-- Tabs
		{CSGGroupsGUI[3] , 0},
		{CSGGroupsGUI[28], 1},
		{CSGGroupsGUI[2500], 4},
		{CSGGroupsGUI[31], 1},
		{CSGGroupsGUI[35], 3},
		{CSGGroupsGUI[50], 1},
		{CSGGroupsGUI[56], 0},
		{CSGGroupsGUI[61], 0},
		{CSGGroupsGUI[9000], 3},
		-- Buttons and GUI elements
		{gtype.radio[1] , 999},
		{gtype.radio[2] , 999},
		{gtype.radio[3] , 999},
		{CSGGroupsGUI[4] , 999},
		{CSGGroupsGUI[5] , 999},
		{CSGGroupsGUI[59], 999},
		{CSGGroupsGUI[17], 888},
		{CSGGroupsGUI[34], 3},
		{CSGGroupsGUI[39], 3},
		{CSGGroupsGUI[40], 3},
		{CSGGroupsGUI[41], 3},
		{CSGGroupsGUI[42], 4},
		{CSGGroupsGUI[43], 4},
		{CSGGroupsGUI[44], 3},
		{CSGGroupsGUI[45], 4},
		{CSGGroupsGUI[46], 5},
		{CSGGroupsGUI[47], 5},
		{CSGGroupsGUI[53], 5},
		{CSGGroupsGUI[54], 1},
		{CSGGroupsGUI[55], 1},
		{CSGGroupsGUI[67], 3},
		{CSGGroupsGUI[76], 3},
		{CSGGroupsGUI[80], 3},
		{CSGGroupsGUI[93], 5},
		{CSGGroupsGUI[98], 5},
		{CSGGroupsGUI[500], 4},
		{CSGGroupsGUI[501], 4},
		{CSGGroupsGUI[502], 4},
		{CSGGroupsGUI[600], 3},
		{CSGGroupsGUI[601], 3},
		{CSGGroupsGUI[700], 3},
		{CSGGroupsGUI[108], 4},
		{CSGGroupsGUI[1500], 4}
	}

	return groupACL
end
-- alliances

-- 0 = not in alliance
-- 1 = not in alliance, but is group founder
-- 2 = alliance's group's members
-- 3 = group founder
-- 4 = alliance founder
function getAliancesACL ()
	return {
		-- Tabs
		{allianceGUI.tabs.groups[1] , 2},
		{allianceGUI.tabs.info[1] , 2},
		{allianceGUI.tabs.maintenance[1], 3},
		{allianceGUI.tabs.bank[1], 2},
		{allianceGUI.tabs.invites[1], 1},
		{allianceGUI.tabs.alliances[1], 0},
		-- Buttons and GUI elements
		{allianceGUI.tabs.invites.acceptInvite,1,1},
		{allianceGUI.tabs.invites.rejectInvite,1},
		{allianceGUI.tabs.info.update,3},
		{allianceGUI.tabs.main.createNewAlliance , 1, 1},
		{allianceGUI.tabs.main.createNewAllianceEdit , 1, 1},
		{allianceGUI.tabs.main.leaveAlliance, 3},
		{allianceGUI.tabs.maintenance.deleteAlliance, 4},
		{allianceGUI.tabs.maintenance.setAllianceFounder, 4},
		{allianceGUI.tabs.maintenance.shareBases, 4},
		-- ?banking?

		{}
	}

end

