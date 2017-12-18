require ("NoTrees")
require ("CreativeChests")
require ("ZCheat")

--require ("CreativeInventory")

script.on_event(defines.events.on_player_created, function (event)

	--getPowerArmorAndTechs(event)
	--CC_ON_PLAYER_CREATED(event)	
	cheat_on_player_created (event)
end)

script.on_event(defines.events.on_player_respawned, function (event)
	getPowerArmorAndTechs(event)
	CC_ON_PLAYER_RESPAWNED(event)	
end)

script.on_event(defines.events.on_tick, function (event)
	CC_ON_TICK() -- no event pls
	
	--CI_ON_TICK()
end)

script.on_event(defines.events.on_gui_click, function (event)
	CC_ON_GUI_CLICK(event)	
	--cheat_on_gui_click (event)
end)

script.on_event(defines.events.on_built_entity, function (event)
	CC_ON_BUILT_ENTITY(event)	
	--CI_ON_BUILT_ENTITY(event)
end)

script.on_event(defines.events.on_chunk_generated, function(event)
	NO_TREES_ON_CHUNK_GENERATED(event)
end)