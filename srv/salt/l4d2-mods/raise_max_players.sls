/home/steam/L4D2/left4dead2/addons/l4dtoolz-rezipped-1.0.0.9h.zip:
  file.managed:
    - user: steam
    - group: steam
    - source: salt://l4d2-mods/l4dtoolz-rezipped-1.0.0.9h.zip

'unzip /home/steam/L4D2/left4dead2/addons/l4dtoolz-rezipped-1.0.0.9h.zip -d /home/steam/L4D2/left4dead2/addons/':
  cmd.run:
    - runas: steam
    - creates: /home/steam/L4D2/left4dead2/addons/metamod/l4dtoolz.vdf

'wget -O /home/steam/L4D2/left4dead2/addons/sourcemod/plugins/l4d_superversus.smx "http://www.sourcemod.net/vbcompiler.php?file_id=54755"':
  cmd.run:
    - creates: /home/steam/L4D2/left4dead2/addons/sourcemod/plugins/l4d_superversus.smx

/home/steam/L4D2/left4dead2/addons/sourcemod/plugins/l4d_superversus.smx:
  file.managed:
    - user: steam
    - group: steam

/home/steam/L4D2/left4dead2/addons/l4dtoolz/l4dtoolz_mm.so:
  file.managed:
    - user: steam
    - group: steam
    - source: salt://l4d2-mods/l4dtoolz_mm.so

/home/steam/L4D2/left4dead2/cfg/sourcemod/l4d_superversus.cfg:
  file.managed:
    - template: jinja
    - user: steam
    - group: steam
    - source: salt://l4d2-mods/l4d_superversus.cfg.jinja
