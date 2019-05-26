﻿addEvent ("onClientPlayerKillMessage",true)
function onClientPlayerKillMessage ( killer,weapon,wr,wg,wb,kr,kg,kb,width,resource )
	if wasEventCancelled() then return end

	local x1, y1, z1 = getElementPosition( localPlayer )
	local x2, y2, z2 = getElementPosition( source )

	if ( getDistanceBetweenPoints2D ( x1, y1, x2, y2 ) < 700 ) then
		outputKillMessage ( source, wr,wg,wb,killer,kr,kg,kb,weapon,width,resource )
	end
end
addEventHandler ("onClientPlayerKillMessage",getRootElement(),onClientPlayerKillMessage)

function outputKillMessage ( source, wr,wg,wb,killer,kr,kg,kb,weapon,width,resource )
	if not iconWidths[weapon] then
		if type(weapon) ~= "string" then
			weapon = 999
		end
	end
	local killerName
	local wastedName
	if not tonumber(wr) then wr = 255 end
	if not tonumber(wg) then wg = 255 end
	if not tonumber(wb) then wb = 255 end
	if not tonumber(kr) then kr = 255 end
	if not tonumber(kg) then kg = 255 end
	if not tonumber(kb) then kb = 255 end
	if ( source ) then
		if isElement ( source ) then
			if getElementType ( source ) == "player" then
				wastedName = getPlayerName ( source )
			else
			outputDebugString ( "outputKillMessage - Invalid 'wasted' player specified",0,0,0,100)
			return false end
		elseif type(source) == "string" then
			wastedName = source
		end
	else
		outputDebugString ( "outputKillMessage - Invalid 'wasted' player specified",0,0,0,100)
	return false end
	if ( killer ) then
		if isElement ( killer ) then
			if getElementType ( killer ) == "player" then
				killerName = getPlayerName ( killer )
				if (setPlayerKillStreak) then
					setPlayerKillStreak( killer )
				end
			elseif getElementType ( killer ) == "ped" and getElementData(killer,"isPedWife") then
				local owner = getElementData(killer,"WifeOwner")
				killerName = getPlayerName ( owner )
				killerName = killerName.."'s Wife"
				if (setPlayerKillStreak) then
					setPlayerKillStreak( owner )
				end
			else
				outputDebugString ( "outputKillMessage - Invalid 'killer' player specified",0,0,0,100)
			return false end
		elseif type(killer) == "string" then
			killerName = killer
		else
			killerName = ""
		end
	else killerName = "" end
	--create the new text
	if not killerName then
		killerName = ""
	end
	return outputMessage ( {killerName, {"padding",width=3}, {"icon",id=weapon},
		{"padding",width=3},{"color",r=wr,g=wg,b=wb}, wastedName},
		kr,kg,kb )
end
