'/home/steam/Steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/L4D2 +app_update 222860 validate +quit':
  cmd.run:
    - runas: steam
    - creates: 
      - /home/steam/L4D2/srcds_run
      - /home/steam/L4D2/left4dead2

/home/steam/L4D2/left4dead2/cfg/server.cfg:
  file.managed:
    - template: jinja
    - user: steam
    - group: steam
    - source: salt://l4d2-server/server.cfg.jinja
