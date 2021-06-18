base:
  '*web':
    - steamcmd.server-setup.sls
    - steamcmd.steam-user
    - l4d2-server.server-setup
    - l4d2-mods.custom-maps
    - l4d2-mods.source_meta_mod
    - l4d2-mods.raise_max_players
    - valheim-server.valheim-setup
    - monitor-server.beats-setup
  '*monitor':
    - monitor-server.server-setup
