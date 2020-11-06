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

'cp /root/.ssh/authorized_keys /home/steam/.ssh/authorized_keys':
  cmd.run:
    - creates: /home/steam/.ssh/authorized_keys

/home/steam/.ssh/:
  file.directory:
    - user: steam
    - group: steam
    - recurse:
      - user
      - group
