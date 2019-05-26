-- Punishments windows
punishlogWindow = guiCreateWindow(407,203,719,494,"AuroraRPG ~ My punishments",false)
punishlogTabPanel = guiCreateTabPanel(9,23,701,421,false,punishlogWindow)
-- Account Punishments
punishlogTab1 = guiCreateTab("Account punishments",punishlogTabPanel)
accountPunishGrid = guiCreateGridList(1,3,699,393,false,punishlogTab1)
guiGridListSetSelectionMode(accountPunishGrid,0)
columnID1 = guiGridListAddColumn(accountPunishGrid,"ID: ",0.10)
column1 = guiGridListAddColumn( accountPunishGrid, "Date:", 0.24 )
column2 = guiGridListAddColumn( accountPunishGrid, "Punishment:", 0.73 )
-- Serial Punishments
punishlogTab2 = guiCreateTab("Serial punishments",punishlogTabPanel)
serialPunishGrid = guiCreateGridList(1,3,699,393,false,punishlogTab2)
guiGridListSetSelectionMode(serialPunishGrid,0)
columnID2 = guiGridListAddColumn(serialPunishGrid,"ID: ",0.10)
column3 = guiGridListAddColumn( serialPunishGrid, "Date:", 0.24 )
column4 = guiGridListAddColumn( serialPunishGrid, "Punishment:", 0.73 )


punishlogTab3 = guiCreateTab("Slap/Frozen Log (Not Punishements)",punishlogTabPanel)
PunishGrid = guiCreateGridList(1,3,699,393,false,punishlogTab3)
guiGridListSetSelectionMode(PunishGrid,0)
columnID3 = guiGridListAddColumn(PunishGrid,"ID: ",0.10)
column5 = guiGridListAddColumn( PunishGrid, "Date:", 0.24 )
column6 = guiGridListAddColumn( PunishGrid, "Logs:", 0.73 )







-- Labels
punishlogLabel1 = guiCreateLabel(11,449,437,16,"Accountname:  / Nickname: ",false,punishlogWindow)
guiSetFont(punishlogLabel1,"default-bold-small")
punishlogLabel2 = guiCreateLabel(11,467,433,17,"Serial: 0000000000000000000000000000000000000",false,punishlogWindow)
guiSetFont(punishlogLabel2,"default-bold-small")
punishlogButton = guiCreateButton(558,455,154,25,"Close window",false,punishlogWindow)

local screenW,screenH=guiGetScreenSize()
local windowW,windowH=guiGetSize(punishlogWindow,false)
local x,y = (screenW-windowW)/2,(screenH-windowH)/2
guiSetPosition(punishlogWindow,x,y,false)

guiWindowSetMovable (punishlogWindow, true)
guiWindowSetSizable (punishlogWindow, false)
guiSetVisible (punishlogWindow, false)

addEventHandler("onClientGUIClick", punishlogButton,
function()
	guiSetVisible(punishlogWindow, false)
	showCursor(false,false)
end, false)


function showPunishment()
	if guiGetVisible(punishlogWindow, true) then return false end
	if ( getElementData ( localPlayer, "isPlayerLoggedin" ) ) then
		local playerID = exports.server:getPlayerAccountID ( localPlayer )

		guiGridListClear ( accountPunishGrid )
		guiGridListClear ( serialPunishGrid )
		guiGridListClear ( PunishGrid )

		guiSetText( punishlogLabel1, "Accountname: " .. exports.server:getPlayerAccountName ( localPlayer ) .. " / Nickname: "..getPlayerName( localPlayer ) )
		guiSetText( punishlogLabel2, "Serial: "..getPlayerSerial() )
		--triggerServerEvent ( "retrievePlayerPunishments", localPlayer, playerID )
	end
end



addEvent( "onSetPlayerMuted" )
addEventHandler( "onSetPlayerMuted", root,function()
	triggerServerEvent("onSetPlayerMuted",localPlayer)
end)

addEvent( "showPunishmentsWindow", true )
addEventHandler( "showPunishmentsWindow", root,
function ( accountPunishments, serialPunishments )
	guiGridListClear ( accountPunishGrid )
	guiGridListClear ( serialPunishGrid )
	guiGridListClear ( PunishGrid )
	if ( accountPunishments ) then
		for key, punish in ipairs( accountPunishments ) do
			local row = guiGridListAddRow ( accountPunishGrid )
			local row2 = guiGridListAddRow ( PunishGrid )

			 if string.match(punish.punishment, "froze") or string.match(punish.punishment, "slapped") then
	         guiGridListSetItemText ( PunishGrid, row2, column6, "[ACCOUNT] "..punish.punishment, false, false )
             guiGridListSetItemText(PunishGrid,row2,columnID3, punish.uniqueid, false, false)
			 guiGridListSetItemText (PunishGrid, row2, column5, punish.datum, false, false )


			  else
            guiGridListSetItemText(accountPunishGrid,row,columnID1, punish.uniqueid, false, false)
			guiGridListSetItemText ( accountPunishGrid, row, column1, punish.datum, false, false )
			guiGridListSetItemText ( accountPunishGrid, row, column2, punish.punishment, false, false )
	        end
		end
	end

	if ( serialPunishments ) then
		for key, punish in ipairs( serialPunishments ) do
			local row = guiGridListAddRow ( serialPunishGrid )
			local row2 = guiGridListAddRow ( PunishGrid )
			if string.match(punish.punishment, "froze") or string.match(punish.punishment, "slapped") then
	         guiGridListSetItemText ( PunishGrid, row2, column6, "[SERIAL] "..punish.punishment, false, false )
             guiGridListSetItemText(PunishGrid,row2,columnID3, punish.uniqueid, false, false)
			 guiGridListSetItemText (PunishGrid, row2, column5, punish.datum, false, false )
			else
			guiGridListSetItemText(serialPunishGrid,row,columnID2, punish.uniqueid,false,false)
			guiGridListSetItemText ( serialPunishGrid, row, column3, punish.datum, false, false )
			guiGridListSetItemText ( serialPunishGrid, row, column4, punish.punishment, false, false )
			end
		end
	end
	guiSetText( punishlogLabel1, "Accountname: " .. exports.server:getPlayerAccountName ( localPlayer ) .. " / Nickname: "..getPlayerName( localPlayer ) )
	guiSetText( punishlogLabel2, "Serial: "..getPlayerSerial() )
	guiSetVisible(punishlogWindow, true) showCursor(true,true)
end
)
