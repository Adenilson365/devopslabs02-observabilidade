### Consultas
[Medium - Prometheus Rule](https://medium.com/@muppedaanvesh/a-hands-on-guide-setting-up-prometheus-and-alertmanager-in-kubernetes-with-custom-alerts-%EF%B8%8F-f9c6d37b27ca)

- Configurar o telegram
- Pegar o ID do chat
https://api.telegram.org/bot<tokenDoBot>/getUpdates

"""
"message":{"message_id":22,"from":{"id":7373123934
"""

### Crie do diretório values o arquivo de configuração do alertmanager

[Documentação - Alterando o receiver pode configurar outros como: email, slack ... ](https://prometheus.io/docs/alerting/latest/configuration/)

```YAML
alertmanager:
  config:
    global:
      resolve_timeout: 5m
    route:
      group_by: ['alertname']
      group_wait: 30s
      group_interval: 1m
      repeat_interval: 5m
      receiver: 'null'
      routes:
        - receiver: 'telegram'
          matchers:
            - alertname = "AltaTaxaErros"
    receivers:
      - name: 'null'
      - name: 'telegram'
        telegram_configs:
          - api_url: 'https://api.telegram.org'
            chat_id: <id_do_chat> # Precisa ser passado como número, correto: 123 incorreto: '123'
            bot_token: '<Token_do_se_bot_telegram>'
            parse_mode: ''
    templates:
      - '/etc/alertmanager/config/*.tmpl'
```