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

'/usr/share/elasticsearch/bin/elasticsearch-certutil ca':
  cmd.run:
    - stdin: 'elastic-stack-ca.p12\n{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}}'
    - creates:
      - /usr/share/elasticsearch/elastic-stack-ca.p12

'/usr/share/elasticsearch/bin/elasticsearch-certutil cert --ca /usr/share/elasticsearch/elastic-stack-ca.p12':
   cmd.run:
    - stdin: '{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}}\nelastic-certificates.p12\n{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}}'
    - creates:
      - /usr/share/elasticsearch/elastic-certificates.p12

/etc/elasticsearch/elastic-certificates.p12:
  file.copy:
    - source: /usr/share/elasticsearch/elastic-certificates.p12
    - mode: 744
    - force: True

'/usr/share/elasticsearch/bin/elasticsearch-keystore add xpack.security.transport.ssl.keystore.secure_password':
   cmd.run:
    - stdin: '{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}}'

'/usr/share/elasticsearch/bin/elasticsearch-keystore add xpack.security.transport.ssl.truststore.secure_password':
   cmd.run:
    - stdin: '{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}}'

'/usr/share/elasticsearch/bin/elasticsearch-keystore add "bootstrap.password"':
  cmd.run:
    - stdin: '{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}}'

'/bin/systemctl start elasticsearch.service':
  cmd.run

set kibana_system password:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/_xpack/security/user/kibana_system/_password' -d '{"password":"{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}}"}'

'/bin/systemctl enable kibana.service':
  cmd.run

/etc/kibana/kibana.yml:
  file.managed:
    - template: jinja
    - source: salt://monitor-server/kibana.yml.jinja

'/bin/systemctl start kibana.service':
  cmd.run
