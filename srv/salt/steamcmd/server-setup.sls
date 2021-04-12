/home/steam/Steam:
  file.directory:
    - user: steam
    - group: steam
    - mode: 755
    - makedirs: True

/home/steam/valheim:
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
