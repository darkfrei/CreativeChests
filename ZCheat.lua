function cheat_on_player_created (event)
  local player = game.players[event.player_index]
    player.cheat_mode = true
    player.surface.always_day = true
end