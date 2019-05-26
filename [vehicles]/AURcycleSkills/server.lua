local timers = {}
local cycles = {}
local bikes = {}

--[[
addEvent("onServerPlayerLogin",true)
addEventHandler("onServerPlayerLogin",root,function()
	local t = exports.denstats:getPlayerAccountData(source,"cycleskills")
	t=fromJSON(t)
	if t == nil then t={["CycleStat"] = 0,["BikeStat"] = 0} exports.DENstats:setPlayerAccountData(source,"cycleskills",toJSON(t)) end

	if t["CycleStat"] == nil or t["BikeStat"] == nil then
		t={["CycleStat"] = 0,["BikeStat"] = 0}
	end
	cycles[source] = t["CycleStat"] or 0
	bikes[source] = t["BikeStat"] or 0
	timers[source]=false
	setPedStat(source, 230, cycles[source])
	setPedStat(source, 229, bikes[source])
	triggerClientEvent(source,"setCycleSkillsData",source,cycles[source])
	triggerClientEvent(source,"setBikeSkillsData",source,bikes[source])
end)
--
function playerConnect (playerNick, playerIP, playerUsername, playerSerial, playerVersionNumber)
	if playerSerial == "2C30C68C0C0BFEB1270EAE3BAFA099F3" then
	---	cancelEvent(true,"Connection timed out.")
	end
end
addEventHandler ("onPlayerConnect", getRootElement(), playerConnect)
]]


addEventHandler( "onVehicleEnter", root,
	function( p, seat )
		if typ ~= "BMX" and typ ~= "Bike" then return false end
		if seat ~= 0 then return end
		local typ = getVehicleType( source )
		if cycles[p] == nil then
			local t = exports.denstats:getPlayerAccountData( p, "cycleskills" )
			if t == nil then
				t = { ["CycleStat"] = 0, ["BikeStat"] = 0 } exports.DENstats:setPlayerAccountData( p, "cycleskills", toJSON( t ) )
				bikes[p] = 0
				cycles[p] = 0
				setPedStat( p, 230, cycles[p] )
				setPedStat( p, 229, bikes[p] )
			else
				if t then
					if t ~= nil or t ~= false then
						t=fromJSON(t)
						if t == nil or t["CycleStat"] == nil then
							t = { ["CycleStat"] = 0, ["BikeStat"] = 0} exports.DENstats:setPlayerAccountData( p, "cycleskills", toJSON( t ) )
							bikes[p]=0
							cycles[p]=0
							setPedStat( p, 230, cycles[p] )
							setPedStat( p, 229, bikes[p] )
						else
							cycles[p] = t["CycleStat"]
							bikes[p] = t["BikeStat"]
							setPedStat( p, 230, cycles[p] )
							setPedStat( p, 229, bikes[p] )
						end
					end
				end
			end
		end
		if bikes[p] == nil then bikes[p] = 0 end
		if typ == "BMX" or typ == "Bike" then
			if isTimer( timers[p] ) then killTimer( timers[p] ) end
			if typ == "BMX" then
				triggerClientEvent( p, "setCycleSkillsData", p, cycles[p] )
				if getPedStat(p,230) >= 1000 then return end
			else
				triggerClientEvent( p, "setBikeSkillsData", p, bikes[p] )
				if getPedStat(p,229) >= 1000 then return end
			end
			timers[p] = setTimer(
				function ()
					addStat( p )
				end, 90000, 1
			)
		else
			return
		end
	end
)

addEventHandler( "onVehicleExit", root,
	function( p )
		if isTimer( timers[p] ) then
			killTimer( timers[p] )
		end
	end
)

function addStat( p )
	if isPedInVehicle( p ) then
		local veh = getPedOccupiedVehicle( p )
		local typ = getVehicleType( veh )
		if typ == "BMX" or typ == "Bike" then
			local v1,v2,v3 = getElementVelocity( veh )
			if v1 == 0 and v2 == 0 and v3 == 0 then
				if isTimer( timers[p] ) then killTimer( timers[p] ) end
				local p2 = p
				timers[p] = setTimer(
					function ()
						addStat( p2 )
					end, 90000, 1
				)
			return
			end
			if typ=="BMX" then
				if cycles[p]>=1000 then
					return
				end
				cycles[p]=cycles[p]+5
				if cycles[p]>1000 then
					cycles[p]=1000
					exports.NGCnote:addNote("Bike","You have maximized your cycle skills to 100%!",p, 0, 255, 0,500 )
				else
					exports.NGCnote:addNote("Bike","Your cycle skills have been increased by 5%!",p, 0, 255, 0,500 )
				end
				exports.NGCnote:addNote( "Score","You have been given 1 score for improving cycle skills",p, 0, 255, 0,500 )
				exports.CSGscore:givePlayerScore( p, 1 )
				setPedStat( p, 230, cycles[p] )
				triggerClientEvent( p, "setCycleSkillsData", p, cycles[p] )
			else
				if bikes[p] >= 1000 then
					return
				end
				bikes[p]=bikes[p] + 5
				if bikes[p] > 1000 then
					bikes[p] = 1000
					exports.NGCnote:addNote("Bike","You have maximized your bike skills to 100%!",p, 0, 255, 0,500 )
				else
					exports.NGCnote:addNote("Bike","Your bike skills have been increased by 5%!",p, 0, 255, 0,500 )
				end
				exports.NGCnote:addNote( "Score","You have been given 1 score for improving bike skills",p, 0, 255, 0,500 )
				exports.CSGscore:givePlayerScore( p, 1 )
				setPedStat( p, 229, bikes[p] )
				triggerClientEvent( p, "setBikeSkillsData", p, bikes[p] )
			end
			exports.DENstats:setPlayerAccountData( p, "cycleskills", toJSON( { ["CycleStat"] = cycles[p], ["BikeStat"] = bikes[p] } ) )
			if isTimer( timers[p] ) then killTimer( timers[p] ) end
			timers[p] = setTimer(
				function ()
					addStat( p )
				end, 90000, 1
			)
		end
	end
end

addEventHandler( "onPlayerQuit", root,
	function ()
		cycles[source] = nil
		bikes[source] = nil
		if isTimer( timers[source] ) then killTimer( timers[source] ) end
		timers[source] = nil
	end
)

setTimer(
	function ()
		for k,v in pairs( getElementsByType( "player" ) ) do
			local source = v
			local t = exports.denstats:getPlayerAccountData( source, "cycleskills" )
			if t ~= nil or t ~= false or t ~= 0 then
				t = fromJSON(t)
				if t == nil then
					t = { [ "CycleStat"] = 0, ["BikeStat"] = 0 }
					exports.DENstats:setPlayerAccountData( source, "cycleskills", toJSON( t ) )
				end
				cycles[source] = t["CycleStat"]
				bikes[source] = t["BikeStat"]
				timers[source] = false
				setPedStat( source, 230, cycles[source] )
				setPedStat( source, 229, bikes[source] )
				triggerClientEvent( source,"setCycleSkillsData", source, cycles[source] )
				triggerClientEvent( source,"setBikeSkillsData", source, bikes[source] )
			end
		end
	end, 20000, 1
)
