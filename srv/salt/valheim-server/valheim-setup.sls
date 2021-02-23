'/home/steam/Steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/valheim +app_update 896660 validate +quit':
  cmd.run:
    - runas: steam
    - creates:
      - /home/steam/valheim/srcds_run
