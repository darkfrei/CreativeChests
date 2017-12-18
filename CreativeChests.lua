-- must be in control
--[[

SCRIPT.ON_EVENT(DEFINES.EVENTS.ON_PLAYER_CREATED, FUNCTION (EVENT)
	CC_ON_PLAYER_CREATED(EVENT)	
END)

SCRIPT.ON_EVENT(DEFINES.EVENTS.ON_PLAYER_RESPAWNED, FUNCTION (EVENT)
	CC_ON_PLAYER_RESPAWNED(EVENT)	
END)

SCRIPT.ON_EVENT(DEFINES.EVENTS.ON_TICK, FUNCTION (EVENT)
	CC_ON_TICK(EVENT)	
END)

SCRIPT.ON_EVENT(DEFINES.EVENTS.ON_GUI_CLICK, FUNCTION (EVENT)
	CC_ON_GUI_CLICK(EVENT)	
END)

SCRIPT.ON_EVENT(DEFINES.EVENTS.ON_BUILT_ENTITY, FUNCTION (EVENT)
	CC_ON_BUILT_ENTITY(EVENT)	
END)
]]

-- extern launched

function CC_ON_PLAYER_CREATED (event)
	CC_makeGUI (event.player_index)
end

function CC_ON_PLAYER_RESPAWNED (event)
	CC_makeGUI (event.player_index)
end

function CC_ON_TICK (event)
	CC_Migration ()
	CC_handler_on_tick_GUI ()
	CC_handler_on_tick_fill ()
end

function CC_ON_GUI_CLICK (event)
	CC_on_gui_click_handler (event)
end

function CC_ON_BUILT_ENTITY (event)
	CC_handler_on_built_entity (event)
end
---------------------------------------------------------

function CC_Migration()
	if not global then global = {} end
	if not global.CC then global.CC = {} end
	if not global.CC.GUI then 
		if global.GUI then
				global.CC.GUI = global.GUI
				global.GUI = nil
				printAll("migration 1 ok")
		else
			global.CC.GUI = {} 
		end
	end	
	
	if not global.CC.ID then 
		if global.ID then
				global.CC.ID = global.ID
				global.ID = nil
				printAll("migration 2 ok")
			else
			global.CC.ID = {} 
		end
	end	
	
	if not global.CC.entities then
		if global.entities then
				global.CC.entities = global.entities
				global.entities = nil
				printAll("migration 3 ok")
			else
			global.CC.entities = {} 
		end
	end
		
	if not global.CC.items then 
		if global.items then
				global.CC.items = global.items
				global.items = nil
				printAll("migration 4 ok")
			else
			global.CC.items = {} 
		end
	end
	
end

function CC_on_gui_click_handler (event)
	local player_index = event.player_index or 1
	if event.element.name == "openMaxi" then 
		global.CC.GUI[player_index].size = "maxi"
		CC_makeGUI (player_index)
		return
	end
	for i, value in pairs(global.CC.item_list_with_nothing) do 
		if event.element.name == value then
			global.CC.GUI[player_index].size = "mini"
			global.CC.GUI[player_index].itemOrNothing = value
			CC_makeGUI (player_index)
			return
		end
	end
end

function CC_handler_on_tick_GUI()
	if not global then global = {} end
	if not global.CC then global.CC = {} end
	if not global.CC.GUI then global.CC.GUI = {} end
	for player_index, player in pairs (game.players) do
		if not (global.CC.GUI[player_index]) then
			CC_makeGUI (player_index)
			game.players[player_index].print ("GUI for you")
		end
	end
end

function CC_makeGUI (player_index)
	local player = game.players[player_index]
	-- make GUI frame
	if player.gui.left.frameCreative == nil then
		player.gui.left.add{type = "frame", name = "frameCreative", direction = "horizontal"}
	end
	-- set default settings
	if not (global.CC) then global.CC = {} end
	if not (global.CC.GUI) then global.CC.GUI = {} end
	
	if not global.CC.GUI[player_index] then 
		global.CC.GUI[player_index] = {}
		global.CC.GUI[player_index].size = "mini"
		global.CC.GUI[player_index].itemOrNothing = "nothing"
	end
	
	--check if list exists
	if not global.CC.item_list_with_nothing then make_item_list_with_nothing() end
	
	if global.CC.GUI[player_index].size == "mini" then
	-- clear the GUI and make mini GUI
		player.gui.left.frameCreative.destroy()
		player.gui.left.add{type = "frame", name = "frameCreative", direction = "horizontal"}
		
		-- player.gui.left.frameCreative.add{type ="table", name = "tabCreative", colspan = 2} -- 0.15
		player.gui.left.frameCreative.add{type ="table", name = "tabCreative", column_count = 2} -- 0.16
		local tab = player.gui.left.frameCreative.tabCreative
			tab.add{type = "label", name = "LabelMini", caption = "Placing item"}
			tab.add{type = "button", name = "openMaxi", caption = global.CC.GUI[player_index].itemOrNothing}
	elseif global.CC.GUI[player_index].size == "maxi" then
	-- clear the GUI and make maxi GUI
		player.gui.left.frameCreative.destroy()
		player.gui.left.add{type = "frame", name = "frameCreative", direction = "horizontal"}
--		player.gui.left.frameCreative.add{type ="table", name = "tabCreative", colspan = 31}
		
		player.gui.left.frameCreative.add{
			  type ="table",
			  name = "tabCreative",
			  -- colspan = 31,
			  column_count = 31,
			  -- style = "slot_table_style"
			  style = "slot_table"
			}
		
		local tab = player.gui.left.frameCreative.tabCreative
			for i, value in pairs(global.CC.item_list_with_nothing) do 
				if (i%30 == 2)and (i > 29) then tab.add{type = "label", name = "blank"..i, caption = " "..i.." "}  end
				if value == "nothing" then 
					tab.add{type = "button", name = value, caption = value}
				else
				--tab.add{type = "sprite-button", name = value, caption = "    ", sprite  = "item/" .. value}
				tab.add{
					  type = "sprite-button",
					  -- style = "slot_button_style", 
					  style = "slot_button", 
					  name = value,
					  sprite  = "item/" .. value,
					  tooltip = game.item_prototypes[value].localised_name
					}
				end
			end
	end
end

function make_item_list_with_nothing() -- list of names, not items itself
	if global.CC.item_list_with_nothing == nil then 
		global.CC.item_list_with_nothing = {}
		global.CC.items = {}
		local i = 1
		global.CC.item_list_with_nothing[i] = "nothing"
		
		for k, item in pairs (game.item_prototypes) do  
			i = i + 1
			global.CC.item_list_with_nothing[i] = item.name
			global.CC.items[item.name] = item
		end
	end
end

-- ============================================--
-- ============================================--
-- ============================================--
local chestsNames = {"wooden-chest", "iron-chest", "steel-chest", "logistic-chest-storage", "logistic-chest-passive-provider"}

function CC_handler_on_built_entity (event)
	entity_name = event.created_entity.name
	if tableContains(chestsNames, entity_name) and (global.CC.GUI) then
		printAll("entity name is ".. entity_name)
		CC_mainHandler(event)
	end
end

function CC_mainHandler(event)
	local player_index = event.player_index or 1
	local entity = event.created_entity 
	if not (global) then printAll("No global, sorry")	return end
	if not (global.CC.GUI) then printAll("No global.CC.GUI, sorry")	return end
	if not (global.CC.GUI[player_index]) then 
	printAll("No global.CC.GUI[player_index], sorry")
	return end
	
	if not (global.CC.GUI[player_index].itemOrNothing) then 
	printAll("No global.CC.GUI[player_index].itemOrNothing, sorry")
	return end
	local itemOrNothing = global.CC.GUI[player_index].itemOrNothing
	
	if itemOrNothing == "nothing" then 
		printAll("From GUI: ".. itemOrNothing)
		return
	end
	
	local item = itemOrNothing -- its not a nothing, yay!
	printAll("must place chest with " .. item)
	CC_addEntityToTable(entity, item)
end


function CC_addEntityToTable(entity, item)
	if not global.CC.entities then global.CC.entities = {} end
	CC_nextID()
	local ID = global.CC.ID
	global.CC.entities[ID] = {}
	global.CC.entities[ID].type = chest
	global.CC.entities[ID].entity = entity
	global.CC.entities[ID].ID = ID -- some magick
	global.CC.entities[ID].item = item
end

function CC_nextID()
	--if not global.CC then global.CC = {} end
	if not global.CC.ID then global.CC.ID = 0 end
	if type (global.CC.ID) == "table" then global.CC.ID = 0 end
	
	global.CC.ID = global.CC.ID + 1
	return
end

function	CC_handler_on_tick_fill ()
	if not (game.tick % 120 == 0) then return end -- twice in second
	--if not (global.CC.entities) then return end
		
	for ID_chest, chest in pairs (global.CC.entities) do
		CC_fill_chest(ID_chest, chest.item)
	end
end

function CC_fill_chest(ID, item)
	if not (global.CC.entities[ID]) then
		if (global.entities[ID]) then -- migration, yay!
			global.CC.entities[ID] = global.entities[ID]
			global.entities[ID] = nil
			printAll("Was migrated:" .. ID)
		end
		printAll("No global.CC.entities[ID], sorry")
		return
	end
	
	if not (global.CC.entities[ID].entity.valid) then
		printAll(ID .. " - This entity was destroyed, sorry.")
		global.CC.entities[ID] = nil
		printAll("We still have " .. #global.CC.entities .. " more.")
		return
	end
	
	local chest_inventory = global.CC.entities[ID].entity.get_inventory(1)
	chest_inventory.clear()
	
	for l = 1, 2 do -- only two stacks is enough
	chest_inventory[l].set_stack{name = item, count = global.CC.items[item].stack_size}
	end
end

function tableContains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return value
    end
	 if type(value) == "table" then
		local valueOrFalse = tableContains(value, element)
		if valueOrFalse then return value end
	 end
  end
  return false
end

function printAll(text)
	log (text)
	-- for player_index, player in pairs (game.players) do
		-- game.players[player_index].print (text)
	-- end
end