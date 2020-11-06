'wget -P /home/steam/L4D2/left4dead2/ "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6499-linux.tar.gz"':
  cmd.run:
    - creates: /home/steam/L4D2/left4dead2/sourcemod-1.10.0-git6499-linux.tar.gz

/home/steam/L4D2/left4dead2/sourcemod-1.10.0-git6499-linux.tar.gz:
  file.managed:
    - user: steam
    - group: steam

'tar -zxvf /home/steam/L4D2/left4dead2/sourcemod-1.10.0-git6499-linux.tar.gz -C /home/steam/L4D2/left4dead2/':
  cmd.run:
    - runas: steam
    - creates: /home/steam/L4D2/left4dead2/addons/sourcemod/bin

'wget -P /home/steam/L4D2/left4dead2/ "https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz"':
  cmd.run:
    - creates: /home/steam/L4D2/left4dead2/mmsource-1.10.7-git971-linux.tar.gz

/home/steam/L4D2/left4dead2/mmsource-1.10.7-git971-linux.tar.gz:
  file.managed:
    - user: steam
    - group: steam

'tar -zxvf /home/steam/L4D2/left4dead2/mmsource-1.10.7-git971-linux.tar.gz -C /home/steam/L4D2/left4dead2/':
  cmd.run:
    - runas: steam
    - creates: /home/steam/L4D2/left4dead2/addons/metamod/bin
