steam:
  user.present:
    - fullname: Steam L4D2
    - shell: /bin/bash
    - home: /home/steam
    - groups:
      - wheel

/home/steam/.ssh:
  file.directory:
    - user: steam
    - group: steam
    - mode: 755
    - makedirs: True

steam user ssh key:
  ssh_auth.present:
    - user: steam
    - source: salt://ssh_keys/steam.id_rsa.pub
    - config: '%h/.ssh/authorized_keys'

/home/steam/.ssh/:
  file.directory:
    - user: steam
    - group: steam
    - recurse:
      - user
      - group
