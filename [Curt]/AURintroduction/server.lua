function resetCm (player)
	setTimer(function()
		setCameraTarget(player, player)
	end, 2000, 1)
	
end
addEvent("AURintroduction.resetCamera", true)
addEventHandler("AURintroduction.resetCamera", resourceRoot, resetCm)

function tControls (st)
	if (st == false) then 
		toggleControl(client, "jump", false)
		toggleControl(client, "fire", false)
		toggleControl(client, "next_weapon", false)
		toggleControl(client, "previous_weapon", false)
		toggleControl(client, "forwards", false)
		toggleControl(client, "backwards", false)
		toggleControl(client, "left", false)
		toggleControl(client, "right", false)
		toggleControl(client, "zoom_in", false)
		toggleControl(client, "zoom_out", false)
		toggleControl(client, "sprint", false)
		toggleControl(client, "look_behind", false)
		toggleControl(client, "crouch", false)
		toggleControl(client, "action", false)
		toggleControl(client, "walk", false)
		toggleControl(client, "aim_weapon", false)
		toggleControl(client, "conversation_yes", false)
		toggleControl(client, "conversation_no", false)
		toggleControl(client, "group_control_forwards", false)
		toggleControl(client, "group_control_back", false)
		toggleControl(client, "enter_exit", false)
	else
		toggleControl(client, "jump", true)
		toggleControl(client, "fire", true)
		toggleControl(client, "next_weapon", true)
		toggleControl(client, "previous_weapon", true)
		toggleControl(client, "forwards", true)
		toggleControl(client, "backwards", true)
		toggleControl(client, "left", true)
		toggleControl(client, "right", true)
		toggleControl(client, "zoom_in", true)
		toggleControl(client, "zoom_out", true)
		toggleControl(client, "sprint", true)
		toggleControl(client, "look_behind", true)
		toggleControl(client, "crouch", true)
		toggleControl(client, "action", true)
		toggleControl(client, "walk", true)
		toggleControl(client, "aim_weapon", true)
		toggleControl(client, "conversation_yes", true)
		toggleControl(client, "conversation_no", true)
		toggleControl(client, "group_control_forwards", true)
		toggleControl(client, "group_control_back", true)
		toggleControl(client, "enter_exit", true)
	end 
end 
addEvent("AURintroduction.tControls", true)
addEventHandler("AURintroduction.tControls", root, tControls)