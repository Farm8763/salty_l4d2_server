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

set beats_system password:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/_xpack/security/user/beats_system/_password' -d '{"password":"{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}}"}'

create beats_writer user:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/_security/user/beats_writer' -d '{"password":"{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}}","roles":["kibana_admin","superuser"],"full_name":"beats"}'

add L4D2 map1:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/1?refresh=wait_for' -d '{"human_map": "The Last Stand","map": "c14m1_junkyard","map_size": "2"}'

add L4D2 map2:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/2?refresh=wait_for' -d '{"human_map": "Cold Stream","map": "c13m1_alpinecreek","map_size": "4"}'

add L4D2 map3:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/3?refresh=wait_for' -d '{"human_map": "Blood Harvest","map": "c12m1_hilltop","map_size": "5"}'

add L4D2 map4:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/4?refresh=wait_for' -d '{"human_map": "Dead Air","map": "c11m1_greenhouse","map_size": "5"}'

add L4D2 map5:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/5?refresh=wait_for' -d '{"human_map": "Death Toll","map": "c10m1_caves","map_size": "5"}'

add L4D2 map6:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/6?refresh=wait_for' -d '{"human_map": "Crash Course","map": "c9m1_alleys","map_size": "2"}'

add L4D2 map7:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/7?refresh=wait_for' -d '{"human_map": "No Mercy","map": "c8m1_apartment","map_size": "5"}'

add L4D2 map8:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/8?refresh=wait_for' -d '{"human_map": "The Sacrifice","map": "c7m1_docks","map_size": "3"}'

add L4D2 map9:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/9?refresh=wait_for' -d '{"human_map": "The Passing","map": "c6m1_riverbank","map_size": "3"}'

add L4D2 map10:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/10?refresh=wait_for' -d '{"human_map": "The Parish","map": "c5m1_waterfront_sndscape","map_size": "5"}'

add L4D2 map11:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/11?refresh=wait_for' -d '{"human_map": "Hard Rain","map": "c4m1_milltown_a","map_size": "5"}'

add L4D2 map12:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/12?refresh=wait_for' -d '{"human_map": "Swamp Fever","map": "c3m1_plankcountry","map_size": "4"}'

add L4D2 map13:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/13?refresh=wait_for' -d '{"human_map": "Dark Carnival","map": "c2m1_highway","map_size": "5"}'

add L4D2 map14:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/maps/_doc/14?refresh=wait_for' -d '{"human_map": "Dead Center","map": "c1m1_hotel","map_size": "4"}'

add dummy file:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/fileb/_doc/1?refresh=wait_for' -d '{"map": "c1m1_hotel"}'

add maps-policy:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/_enrich/policy/maps-policy' -d '{"match": {"indices": "maps","match_field": "map","enrich_fields": ["human_map", "map_size"]}}'

activate maps-policy:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPOST  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/_enrich/policy/maps-policy/_execute'

add pipeline:
  cmd.run:
    - name: >
        curl -uelastic:{{salt['pillar.get']('bootstrap_pass','Solarwinds123')}} -XPUT  -H 'Content-Type: application/json' 'http://{{ grains["ip4_interfaces"]["eth0"][0] }}:9200/_ingest/pipeline/parse_kill_count' -d '{"processors" : [{"grok": {"field": "message","patterns": ["L\\s*.*\\s*-\\s*.*:\\s*.*\"%{DATA:l4d2.user1}<.*><.*><%{WORD:l4d2.user1_team}><.*><.*><.*><.*><.*>\"\\s*%{WORD:l4d2.action}\\s*\"%{DATA:l4d2.user2}<.*><.*><%{WORD:l4d2.user2_team}><.*><.*><.*><.*><.*>\"\\s*.*\\s*\"%{DATA:l4d2.weapon}\"","L\\s*.*\\s*-\\s*.*:\\s%{WORD:l4d2.server_action}\\smap\\s\"%{WORD:map}\"*.*"],"ignore_missing": true,"tag": "Kill processor","ignore_failure": true}},{"enrich": {"field": "map","policy_name": "maps-policy","target_field": "l4d2","ignore_missing": true,"ignore_failure": true}}]}'

'/bin/systemctl enable kibana.service':
  cmd.run

/etc/kibana/kibana.yml:
  file.managed:
    - template: jinja
    - source: salt://monitor-server/kibana.yml.jinja

'/bin/systemctl start kibana.service':
  cmd.run
