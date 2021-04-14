/etc/ssl/private:
  file.directory:
    - mode: 755
    - makedirs: True

/etc/ssl/certs:
  file.directory:
    - mode: 755
    - makedirs: True

'openssl req -x509 -nodes -days 365 -batch -newkey rsa:2048 -keyout /etc/ssl/private/elastic_server.key -out /etc/ssl/certs/elastic_server.crt':
  cmd.run:
    - creates:
      - /etc/ssl/private/elastic_server.key

setup_repo:
  pkgrepo.managed:
    - name: elasticsearch
    - humanname: Elasticsearch repository for 7.x packages
    - baseurl: https://artifacts.elastic.co/packages/7.x/yum
    - gpgcheck: 1
    - gpgkey: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - enabled: true

elasticsearch:
  pkg.installed

kibana:
  pkg.installed

'/bin/systemctl daemon-reload':
  cmd.run

'/bin/systemctl enable elasticsearch.service':
  cmd.run

/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - template: jinja
    - source: salt://monitor-server/elasticsearch.yml.jinja

'/bin/systemctl start elasticsearch.service':
  cmd.run

'/bin/systemctl enable kibana.service':
  cmd.run

/etc/kibana/kibana.yml:
  file.managed:
    - template: jinja
    - source: salt://monitor-server/kibana.yml.jinja

'/bin/systemctl start kibana.service':
  cmd.run
