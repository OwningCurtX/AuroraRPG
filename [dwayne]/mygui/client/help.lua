--[[--------------------------------------------------
	GUI Editor
	client
	help.lua
	
	creates the in-game help gui
--]]--------------------------------------------------


HelpWindow = {
	gui = {},
	items = {},
	itemsGrouped = {},
	baseItems = {},
	baseItemsGrouped = {},	
}


function HelpWindow.create()
	HelpWindow.gui.wndMain = guiCreateWindow((gScreen.x - 500) / 2, (gScreen.y - 500) / 2, 500, 500, "Help Documentation", false)
	guiWindowSetSizable(HelpWindow.gui.wndMain, false)
	guiWindowTitlebarButtonAdd(HelpWindow.gui.wndMain, "Close", "right", HelpWindow.close)
	
	HelpWindow.gui.edtSearch = guiCreateEdit(10, 25, 185, 20, "Search...", false, HelpWindow.gui.wndMain)
	addEventHandler("onClientGUIChanged", HelpWindow.gui.edtSearch,
		function()
			HelpWindow.search(guiGetText(source))
		end
	, false)
	addEventHandler("onClientGUIFocus", HelpWindow.gui.edtSearch,
		function()
			if guiGetText(source) == "Search..." then
				guiSetText(source, "")
			end
		end
	, false)		
	
	
	HelpWindow.gui.list = ExpandingGridList:create(10, 50, 185, 440, false, HelpWindow.gui.wndMain)
	HelpWindow.gui.list:addColumn("Items")
	
	HelpWindow.gui.list.onRowClick = 
		function(row, col, text, section)
			local description = HelpWindow.items[text].text or "[NO DESCRIPTION]"
			--[[
			description = splitLinesForLabel(description, 285)
			local lines = #description
			description = table.concat(description, "\n")
			]]
			guiSetText(HelpWindow.gui.lblDescription, description:gsub("\\n","\n"))
			--[[
			if (lines * 20) > 370 then
				guiSetSize(HelpWindow.gui.lblDescription, 285, lines * 20, false)
			else
				guiSetSize(HelpWindow.gui.lblDescription, 285, 370, false)
			end
			]]
		end
	
	HelpWindow.gui.scpDescription = guiCreateScrollPane(205, 20, 285, 470, false, HelpWindow.gui.wndMain)
	HelpWindow.gui.lblDescription = guiCreateLabel(0, 0, 1, 1, "", true, HelpWindow.gui.scpDescription)
	guiLabelSetHorizontalAlign(HelpWindow.gui.lblDescription, "center", true)
	guiLabelSetVerticalAlign(HelpWindow.gui.lblDescription, "center")

	guiSetVisible(HelpWindow.gui.wndMain, false)
	
	HelpWindow.load()
	doOnChildren(HelpWindow.gui.wndMain, setElementData, "guieditor.internal:noLoad", true)
end


function HelpWindow.open()
	if not HelpWindow.gui.wndMain then
		HelpWindow.create()
	end
	
	guiSetText(HelpWindow.gui.edtSearch, "Search...")
	guiSetText(HelpWindow.gui.lblDescription, "")
	
	HelpWindow.itemsGrouped = table.copy(HelpWindow.baseItemsGrouped)
	HelpWindow.gui.list:setData(HelpWindow.itemsGrouped)	
	
	guiSetVisible(HelpWindow.gui.wndMain, true)
	guiBringToFront(HelpWindow.gui.wndMain)
end


function HelpWindow.close()
	if not HelpWindow.gui.wndMain then
		return
	end
	
	guiSetVisible(HelpWindow.gui.wndMain, false)
end


function HelpWindow.load()
	local file = xmlLoadFile("client/help_documentation.xml")
	
	if file then
		for i,node in ipairs(xmlNodeGetChildren(file)) do
			local name = xmlNodeGetAttribute(node, "name") or "[NO NAME]"
			local description = xmlNodeGetAttribute(node, "description") or "[NO DESCRIPTION]"
			local group = xmlNodeGetAttribute(node, "groups") or "[NO GROUPS]"
			local groups = split(group, ',')
			local tag = xmlNodeGetAttribute(node, "tags") or ""
			local tags = split(tag, ',')
			
			HelpWindow.items[name] = {text = description, groups = groups, tags = tags}
			HelpWindow.baseItems[name] = {text = description, groups = groups, tags = tags}
			
			for k,g in ipairs(groups) do
				if not HelpWindow.itemsGrouped[g] then
					HelpWindow.itemsGrouped[g] = {}
				end
				
				if not HelpWindow.baseItemsGrouped[g] then
					HelpWindow.baseItemsGrouped[g] = {}
				end			
				
				HelpWindow.itemsGrouped[g][ #HelpWindow.itemsGrouped[g] + 1 ] = name
				HelpWindow.baseItemsGrouped[g][ #HelpWindow.baseItemsGrouped[g] + 1 ] = name
			end
		end
		
		HelpWindow.gui.list:setData(HelpWindow.itemsGrouped)
		
		xmlUnloadFile(file)
	else
		outputDebug("Couldn't open help_documentation.xml file")
	end
end



function HelpWindow.search(text)
	if not HelpWindow.gui.wndMain then
		return
	end
	
	if text == "Search..." then
		return
	end
	
	if not text then
		HelpWindow.itemsGrouped = table.copy(HelpWindow.baseItemsGrouped)
		HelpWindow.gui.list:setData(HelpWindow.itemsGrouped)
		return
	end

	local t = table.copy(HelpWindow.baseItemsGrouped)
	text = string.lower(text)
	
	for group,items in pairs(t) do 
		-- if the group name matches exactly, keep everything inside it regardless
		if string.lower(group) ~= text then
			for i = #items, 1, -1 do
				if not string.lower(items[i]):find(text, 0, true) then
					local found

					for _,tag in ipairs(HelpWindow.baseItems[items[i]].tags or {}) do
						if string.lower(tag or ""):find(text, 0, true) then
							found = true
						end
					end
						
					if not found then
						table.remove(t[group], i)
					end
				end
			end
			
			if #items == 0 then
				t[group] = nil
			end
		end
	end
	
	HelpWindow.itemsGrouped = t
	HelpWindow.gui.list:setData(HelpWindow.itemsGrouped)
end






-- not used
function splitLinesForLabel(text, width, splitter)
	local lineWidth = 0
	local words = {}
	local space = " "
	
	if splitter == "" then
		text:gsub(".", function(c)
			words[#words + 1] = c
		end)
		
		space = ""
	else
		words = split(text, splitter or ' ')
	end
	
	local line = ""
	local i = 1
	local outputLines = {}
	
	while true do
		if i > #words then
			outputLines[#outputLines + 1] = line
			break
		end
	
		local oldLine = line
		line = line .. (line ~= "" and space or "") .. words[i]
		
		-- if the new line is too long
		if dxGetTextWidth(line) > width then
			-- if the next word on its own is longer than the width
			if dxGetTextWidth(words[i]) > width then
				line = oldLine
				
				local oldLineSpaced = line..space
				local lineCount = oldLineSpaced:len()
				local wordSplit = splitLinesForLabel(oldLineSpaced .. words[i], width, "")
				
				if #wordSplit > 0 then
					wordSplit[1] = wordSplit[1]:sub(lineCount + 1)
				end
				
				for k = 1, #wordSplit do
					if k == 1 then
						words[i] = wordSplit[k]
					else
						table.insert(words, i + (k - 1), wordSplit[k])
					end
				end
			else
				-- remove the last added word, and set this line as done
				outputLines[#outputLines + 1] = oldLine
				line = ""
			end
		else
			i = i + 1
		end
	end
	
	return outputLines
end