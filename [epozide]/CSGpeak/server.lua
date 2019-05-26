local peak = 0
local players = 0

function handlePlayer(player)
	if (isElement(player)) or (isElement(source)) then
		players = players + 1
		checkPeak() --check if a peak has been reached
	end
end
addEventHandler("onPlayerJoin",root,handlePlayer)

addEventHandler("onPlayerQuit",root,
function()
	players = players - 1
end)

addEventHandler("onResourceStart",resourceRoot,
function()
	peak = peakFile("load")

	for k,v in ipairs(getElementsByType("player")) do
		handlePlayer(v)
	end
end)

addEventHandler("onResourceStop",resourceRoot,
function()
	peakFile("save")
end)

function checkPeak()
	if (tonumber(players) > tonumber(peak)) then
		exports.NGCdxmsg:createNewDxMessage(root,"A new peak has been reached! Peak is now "..peak,0,255,0)
		peak = players
		if (peak == 140) then
			for k,v in pairs(getElementsByType("player")) do
				exports.AURVIP:givePlayerVIP(v,60*30)
				outputChatBox("You have been given 30 hours to celebrate!",v,0,255,0)
			end
		else
			for k,v in pairs(getElementsByType("player")) do
				amount = players*1000
				score = players*0.6
				givePlayerMoney(v,amount)
				exports.CSGscore:givePlayerScore(v,score)
				exports.NGCdxmsg:createNewDxMessage(v,"You have been given "..score.." score to celebrate!",0,255,0)
				exports.NGCdxmsg:createNewDxMessage(v,"You have been given $"..amount.." to celebrate!",0,255,0)
			end
		end
	else
		return false
	end
end

function peakFile(type)
	if (type == "load") then
		data = exports.DENmysql:querySingle("SELECT value FROM settings WHERE settingName=?","totalPlayerPeak")
		if (data) then
			return data["value"]
		else
			return 135
		end
	elseif (type == "save") then
		exports.DENmysql:exec("UPDATE settings SET value=? WHERE settingName=?",peak,"totalPlayerPeak")
	else
		return false
	end
end

addCommandHandler("peak",
function(player)
	outputChatBox("Peak is #FFFF00"..peak,player,0,255,0,true)
end)
