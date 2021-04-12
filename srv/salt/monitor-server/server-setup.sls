/etc/yum.repos.d/elasticsearch.repo:
  file.managed:
    - source: salt://monitor-server/elasticsearch.repo
