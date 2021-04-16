setup_repo:
  pkgrepo.managed:
    - name: elasticsearch
    - humanname: Elasticsearch repository for 7.x packages
    - baseurl: https://artifacts.elastic.co/packages/7.x/yum
    - gpgcheck: 1
    - gpgkey: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - enabled: true

filebeat:
  pkg.installed

/etc/filebeat/filebeat.yml:
  file.managed:
    - template: jinja
    - source: salt://monitor-server/filebeat.yml.jinja

'/bin/systemctl enable filebeat.service':
  cmd.run

'/bin/systemctl start filebeat.service':
  cmd.run
