------------------------------------------------------------------------------------
--  For CSG Server
--  Verson 1.0.0
--  CSGnonCamping/server (server-side)
--  Non-Camping Areas / Restricted Areas
--  Smith
------------------------------------------------------------------------------------
function getPlayerFromParticalName(thePlayerName)
	local thePlayer = getPlayerFromName(thePlayerName)
	if thePlayer then
		return thePlayer
	end
	for _,thePlayer in ipairs(getElementsByType("player")) do
		if string.find(string.gsub(getPlayerName(thePlayer):lower(),"#%x%x%x%x%x%x", ""), thePlayerName:lower(), 1, true) then
			return thePlayer
		end
	end
	return false
end


-- function which checks if player is in current team
function isPlayerInTeam(src, TeamName)
	if src and isElement ( src ) and getElementType ( src ) == "player" then
		local team = getPlayerTeam(src)
		if team then
			if getTeamName(team) == TeamName then
				return true
			else
				return false
			end
		end
	end
end

-- Outputing to client TEXT with warning
function outputServerWarning(player,text1,text2,timer)
	triggerClientEvent(player,"OutputWarning",root,text1,text2,timer)
end
-- Outputing to client TEXT with restriction
function outputServerRestriction(player,text11,text21,timer)
	triggerClientEvent(player,"OutputRestricted",root,text11,text21,timer)
end
-----------------------------------------------
---------------- SETINGS ----------------------
-----------------------------------------------

CampingPlayersTimer = {}

----------------------------- Military ------------------------------------
local Military_BC_MB = createColCuboid (-41,1683,-20, 470,470, 90) -- Main Base Area 51
	setElementInterior ( Military_BC_MB, 0)
	setElementDimension ( Military_BC_MB, 0)

onMedicIsInHospitalAreas = 90
onCiviliansIsInHospitalAreas = 65

function getMilitaryColshape()
	return Military_BC_MB
end

------------- LS All Saints Hospital Area ------------------------
addEventHandler ("onColShapeHit", getRootElement(),
function( hitElement, matchingDimension )
	if not matchingDimension then return end
	if( getElementType( hitElement ) ~= "player" ) then return end
	if isPlayerInTeam(hitElement,"Staff") then return end
	if (source == Military_BC_MB) then
		if (((getElementData(hitElement,"Group")) == "Advanced Assault Forces") or ((getElementData(hitElement,"MFbasePermission")) == true) or isPlayerInTeam(hitElement,"Staff") or isPlayerInTeam(hitElement,"Military Forces")) then return end
				if( isPlayerInTeam(hitElement,"Government")) then
					campTime = 10
					outputServerRestriction(hitElement,"Res1","Res2",campTime)
				else
					campTime = 30
					outputServerRestriction(hitElement,"Res1","Res2",campTime)
				end
				CampingPlayersTimer[hitElement] = setTimer( function ()
					for k,v in ipairs(getElementsByType("player")) do
						if isPlayerInTeam(v, "Military Forces") then
							exports.killmessages:outputMessage("ATTENTION : > "..getPlayerName(hitElement).." has been killed due of camping at Military Base!", v, 250, 0, 0,"default-bold")
						end
						end
						killPed ( hitElement, hitElement )
					end , campTime*1000, 1  )
	end
end
)

addEventHandler ("onColShapeLeave", getRootElement(),
	function( hitElement, matchingDimension )
	if not matchingDimension then return end
		if (source == Military_BC_MB) then
			if isTimer ( CampingPlayersTimer[hitElement] ) then
				killTimer( CampingPlayersTimer[hitElement])
				triggerClientEvent(hitElement,"OutputKillRestricted",hitElement)
			end
		end
	end
)

local permission = {
	["badboy1"] = true,
	["joseph"] = true,
}


function giveBasePermission(thePlayer,cmd,target)
	local account = exports.server:getPlayerAccountName(thePlayer)
	if permission[account] then
		if target then
			chosenPlayer = getPlayerFromParticalName(target)
			if chosenPlayer then
				outputChatBox ("You gave permission to '"..getPlayerName(chosenPlayer).."' to enter in AAF Base!",thePlayer,0,155,0)
				outputChatBox ("You got permission to enter in AAF Base from '"..getPlayerName(thePlayer).."'!",chosenPlayer,0,155,0)
				setElementData(chosenPlayer,"MFbasePermission", true)
			else
				outputChatBox ("Player with name you typed doesnt exist or no longer left game!",thePlayer,195,5,0)
			end
		end
	end
end
addCommandHandler("giveperm",giveBasePermission)


function removeBasePermission(thePlayer,cmd,target)
local account = exports.server:getPlayerAccountName(thePlayer)
if permission[account] then
 if target then
   chosenPlayer = getPlayerFromParticalName(target)
   if chosenPlayer then
	outputChatBox ("You removed permission from '"..getPlayerName(chosenPlayer).."' to enter in AAF Base!",thePlayer,0,155,0)
	outputChatBox ("You permission to enter in AAF Base has been removed from '"..getPlayerName(thePlayer).."'!",chosenPlayer,0,155,0)
	setElementData(chosenPlayer,"MFbasePermission", false)
    else
	outputChatBox ("Player with name you typed doesnt exist or no longer left game!",thePlayer,195,5,0)
   end
 end
end
end
addCommandHandler("removeperm",removeBasePermission)
