/home/steam/Steam:
  file.directory:
    - user: steam
    - group: steam
    - mode: 755
    - makedirs: True

/home/steam/L4D2:
  file.directory:
    - user: steam
    - group: steam
    - mode: 755
    - makedirs: True

glibc.i686:
  pkg.installed

wget:
  pkg.installed

unzip:
  pkg.installed

'wget -P /home/steam/Steam "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"':
  cmd.run:
    - creates: /home/steam/Steam/steamcmd_linux.tar.gz

/home/steam/Steam/steamcmd_linux.tar.gz:
  file.managed:
    - user: steam
    - group: steam

'tar -zxvf /home/steam/Steam/steamcmd_linux.tar.gz -C /home/steam/Steam/':
  cmd.run:
    - runas: steam
    - creates: /home/steam/Steam/steamcmd

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
