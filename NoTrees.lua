--[[
script.on_event(defines.events.on_chunk_generated, function(event)
	NO_TREES_ON_CHUNK_GENERATED(event)
end)
]]



function NO_TREES_ON_CHUNK_GENERATED(event)
  for key, entity in pairs(event.surface.find_entities(event.area)) do
	-- If Entity is a tree or rock then destroy
	  if (entity.type == "tree") or entity.name:lower():find("-rock") then
		entity.destroy()
	  end
	end
end

