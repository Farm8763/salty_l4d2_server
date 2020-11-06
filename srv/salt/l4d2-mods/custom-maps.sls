/home/steam/L4D2/left4dead2/addons/workshop/:
  file.recurse:
    - user: steam
    - group: steam
    - source: salt://l4d2-mods/workshop/

/home/steam/L4D2/left4dead2/addons/missing_content.vpk:
  file.managed:
    - user: steam
    - group: steam
    - source: salt://l4d2-mods/missing_content.vpk


