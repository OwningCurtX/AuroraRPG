---------------------------------------------------------------------
-- Project: irc
-- Author: MCvarial
-- Contact: mcvarial@gmail.com
-- Version: 1.0.3
-- Date: 31.10.2010
---------------------------------------------------------------------

------------------------------------
-- Echo
------------------------------------
local messages = {}

addEventHandler("onResourceStart",root,
	function (resource)
		if getResourceInfo(resource,"type") ~= "map" then
			local server = createElement("irc-staff")
			outputIRCStaff("09* Resource '"..getResourceName(resource).."' started!")
			--ircSay(server, "09* Resource '"..getResourceName(resource).."' started!")
			--ircRaw(server,"PRIVMSG #staff :09* Resource '"..getResourceName(resource).."' started!"))
		end
		if resource == getThisResource() then
			for i,player in ipairs (getElementsByType("player")) do
				messages[player] = 0
			end
		end
	end
)

addEventHandler("onResourceStop",root,
	function (resource)
		if getResourceInfo(resource,"type") ~= "map" then
			local server = createElement("irc-staff")
			outputIRCStaff("04* Resource '"..(getResourceName(resource) or "?").."' stopped!")
			--ircSay(server, "04* Resource '"..(getResourceName(resource) or "?").."' stopped!")
			--ircRaw(server,"PRIVMSG #staff :04* Resource '"..getResourceName(resource).."' stopped!"))
		end
	end
)

addEventHandler("onPlayerJoin",root,
	function ()
		messages[source] = 0
		outputIRC("03*** "..getPlayerName(source).." joined the game." .. " [player "..#getElementsByType("player") .. "]")
	end
)

addEventHandler("onPlayerQuit",root,
	function (quit,reason,element)
		messages[source] = nil
		if reason then
			if element then
				outputIRC("02*** "..getPlayerName(source).." was "..quit.." from the game by "..getPlayerName(element).." ("..reason..")" .. " ["..#getElementsByType("player")-1 .. " left]")
			else
				outputIRC("02*** "..getPlayerName(source).." was "..quit.." from the game by Console ("..reason..")" .. " ["..#getElementsByType("player")-1 .. " left]")
			end
		else
			outputIRC("02*** "..getPlayerName(source).." left the game ("..quit..") ["..#getElementsByType("player")-1 .. " left]")
		end
	end
)

addEventHandler("onPlayerChangeNick",root,
	function (oldNick,newNick)
		setTimer(function (player,oldNick)
			local newNick = getPlayerName(player)
			if newNick ~= oldNick then
				outputIRC("13* "..oldNick.." is now known as "..newNick)
			end
		end,100,1,source,oldNick)
	end
)

addEventHandler("onPlayerMute",root,
	function (arg)
		if type(arg) ~= "nil" then return end
		local result = executeSQLSelect("ircmutes","serial,reason","serial = '"..getPlayerSerial(source).."'")
		if result and result[1] then
			local admin = result[1]["admin"] or "console"
			if result[1]["reason"] then
				outputIRC("12* "..getPlayerName(source).." has been muted by "..admin.." ("..result[1]["reason"]..")")
			else
				outputIRC("12* "..getPlayerName(source).." has been muted by "..admin)
			end
		else
			outputIRC("12* "..getPlayerName(source).." has been muted")
		end
	end
)

addEventHandler("onPlayerUnmute",root,
	function ()
		outputIRC("12* "..getPlayerName(source).." has been unmuted")
	end
)

addEvent("onPlayerMainChat")

addEventHandler("onPlayerMainChat",root,
	function (chatzone, message)
		local mute = getPlayerMute(source)
		messages[source] = messages[source] + 1
		local color = exports.DENchatsystem:getColorForIRC(source)
		name = getPlayerName(source)
		if mute ~= "Global" and mute ~= "Main" then
			outputIRC("07("..chatzone..") "..tonumber(color)..""..name..": "..message)
		end		
	end
)

addEventHandler("onPlayerChat",root,
	function (message,type)
		local mute = getPlayerMute(source)
		messages[source] = messages[source] + 1
		local color = exports.DENchatsystem:getColorForIRC(source)
		name = getPlayerName(source)
		
		if type == 0 then
			return
			--if mute ~= "Global" and mute ~= "Main" then
				--outputIRC("07("..calculatePlayerChatZone(source)..") "..tonumber(color)..",1"..name..": "..message)
			--end
		elseif type == 1 then
			if mute ~= "Global" and mute ~= "Main" then
				outputIRC("06* "..name.." "..message)
			end		
		elseif type == 2 then
			if mute ~= "Global" and mute ~= "Main" then
				local team = getPlayerTeam(source)
				local teamName = "Unknown Team"
				if team then teamName = "Team: "..getTeamName(team) end
				outputIRC("07("..teamName..") "..tonumber(color)..""..name..": "..message)
			end
		end
	end
)

function getPlayerMute(player)
	local res = getResourceFromName("CSGadmin")
	local mute = false
	if res and getResourceState(res) == "running" then
		mute =  exports.CSGadmin:getPlayerMute(player)
	end
	return mute
end

function calculatePlayerChatZone( thePlayer )
	local x, y, z = getElementPosition(thePlayer)
	if x < -920 then
		return "SF"
	elseif y < 420 then
		return "LS"
	else
		return "LV"
	end
end

addEventHandler("onSettingChange",root,
	function (setting,oldValue,newValue)
		outputIRC("6Setting '"..tostring(setting).."' changed: "..tostring(oldValue).." -> "..tostring(newValue))
	end
)

local bodyparts = {nil,nil,"Torso","Ass","Left Arm","Right Arm","Left Leg","Right Leg","Head"}
local weapons = {}
weapons[19] = "Rockets"
weapons[88] = "Fire"
addEventHandler("onPlayerWasted",root,
	function (ammo,killer,weapon,bodypart)
	if true then
		return false -- disabled
	end
		if killer then
			if getElementType(killer) == "vehicle" then
				local driver = getVehicleController(killer)
				if driver then
					outputIRC("04* "..getPlayerName(source).." was killed by "..getPlayerName(driver).." in a "..getVehicleName(killer))
				else
					outputIRC("04* "..getPlayerName(source).." was killed by an "..getVehicleName(killer))
				end
			elseif getElementType(killer) == "player" then
				if weapon == 37 then
					if getPedWeapon(killer) ~= 37 then
						weapon = 88
					end
				end
				outputIRC("04* "..getPlayerName(source).." was killed by "..getPlayerName(killer).." ("..(getWeaponNameFromID(weapon) or weapons[weapon] or "?")..")("..bodyparts[bodypart]..")")
			else
				outputIRC("04* "..getPlayerName(source).." died")
			end
		else
			outputIRC("04* "..getPlayerName(source).." died")
		end
	end
)
		
addEvent("onPlayerSupportChat",true)
addEventHandler("onPlayerSupportChat",root,
function ( theMessage )
	name = getPlayerName(source)
	
	outputIRC("(SUPPORT) "..name..": "..theMessage)
end
)

addEvent("onServerNote",true)
addEventHandler("onServerNote",root,
function ( theMessage )
	outputIRC("04* (NOTE) "..getPlayerName(source)..": 04"..theMessage)
end)

addEvent("onPlayerAdvert",true)
addEventHandler("onPlayerAdvert",root,
function ( message )
	outputIRC("07* (ADVERT) "..getPlayerName(source)..": 07"..message)
end)

addEvent("onAddingUpdate",true)
addEventHandler("onAddingUpdate",root,
function ()
	outputIRC("09* A new update has been added by 07"..getPlayerName(source).."")
end)

addEvent("onPlayerFinish",true)
addEventHandler("onPlayerFinish",root,
	function (rank,time)
		outputIRC("12* "..getPlayerName(source).." finished (rank: "..rank.." time: "..msToTimeStr(time)..")")
	end
)

addEvent("onGamemodeMapStart",true)
addEventHandler("onGamemodeMapStart",root,
	function (res)
		outputIRC("12* Map started: "..(getResourceInfo(res, "name") or getResourceName(res)))
		local resource = getResourceFromName("mapratings")
		if resource and getResourceState(resource) == "running" and exports.mapratings:getMapRating(getResourceName(res)) and exports.mapratings:getMapRating(getResourceName(res)).average then
			outputIRC("07* Rating: "..exports.mapratings:getMapRating(getResourceName(res)).average)
		end
	end
)

addEvent("onPlayerToptimeImprovement",true)
addEventHandler("onPlayerToptimeImprovement",root,
	function (newPos,newTime,oldPos,oldTime)
		if newPos == 1 then
			outputIRC("07* New record: "..msToTimeStr(newTime).." by "..getPlayerName(source).."!")
		end
	end
)

addEventHandler("onBan",root,
	function (ban)
		local text = "12* Ban added by "..(getPlayerName(source) or "Console")..": name: "..(getBanNick(ban) or "/")..", ip: "..(getBanIP(ban) or "/")..", serial: "..(getBanSerial(ban) or "/")..", banned by: "..(getBanAdmin(ban) or "/").." banned for: "..(getBanReason(ban) or "/")
		ircSay(ircGetChannelFromName("#staff"), text)
	end
)

addEventHandler("onUnban",root,
	function (ban)
		local text = "12* Ban removed by "..(getPlayerName(source) or "Console")..": name: "..(getBanNick(ban) or "/")..", ip: "..(getBanIP(ban) or "/")..", serial: "..(getBanSerial(ban) or "/")..", banned by: "..(getBanAdmin(ban) or "/").." banned for: "..(getBanReason(ban) or "/")
		ircSay(ircGetChannelFromName("#staff"), text)
	end
)

addEvent("onPlayerRaceWasted")
addEventHandler("onPlayerRaceWasted",root,
	function (vehicle)
		if #getAlivePlayers() == 1 and currentmode ~= "Sprint" then
			outputIRC("12* "..getPlayerName(getAlivePlayers()[1]).." won the deathmatch!")
		end
	end
)

------------------------------------
-- Admin interaction
------------------------------------
addEvent("onPlayerFreeze")
addEventHandler("onPlayerFreeze",root,
	function (state)
		if state then
			outputIRC("12* "..getPlayerName(source).." was frozen!")
		else
			outputIRC("12* "..getPlayerName(source).." was unfrozen!")
		end
	end
)

addEvent("aMessage",true)
addEventHandler("aMessage",root,
	function (Type,t)
		if Type ~= "new" then return end
		
		for i,channel in ipairs (ircGetEchoChannels()) do
			ircRaw(ircGetChannelServer(channel),"NOTICE %"..tostring(ircGetChannelName(channel)).." :New admin message by "..tostring(getPlayerName(source)))
			ircRaw(ircGetChannelServer(channel),"NOTICE %"..tostring(ircGetChannelName(channel)).." :Category: "..tostring(t.category))
			ircRaw(ircGetChannelServer(channel),"NOTICE %"..tostring(ircGetChannelName(channel)).." :Subject: "..tostring(t.subject))
			ircRaw(ircGetChannelServer(channel),"NOTICE %"..tostring(ircGetChannelName(channel)).." :Message: "..tostring(t.message))
		end
	end
)

------------------------------------
-- Votemanager interaction
------------------------------------
local pollTitle

addEvent("onPollStarting")
addEventHandler("onPollStarting",root,
	function (data)
		if data.title then
			pollTitle = tostring(data.title)
		end
	end
)

addEvent("onPollModified")
addEventHandler("onPollModified",root,
	function (data)
		if data.title then
			pollTitle = tostring(data.title)
		end
	end
)

addEvent("onPollStart")
addEventHandler("onPollStart",root,
	function ()
		if pollTitle then
			outputIRC("14* A vote was started ["..tostring(pollTitle).."]")
		end
	end
)

addEvent("onPollStop")
addEventHandler("onPollStop",root,
	function ()
		if pollTitle then
			pollTitle = nil
			outputIRC("14* Vote stopped!")
		end
	end
)

addEvent("onPollEnd")
addEventHandler("onPollEnd",root,
	function ()
		if pollTitle then
			pollTitle = nil
			outputIRC("14* Vote ended!")
		end
	end
)

addEvent("onPollDraw")
addEventHandler("onPollDraw",root,
	function ()
		if pollTitle then
			pollTitle = nil
			outputIRC("14* A draw was reached!")
		end
	end
)