### Loki
- [Conectar Opentelemetry ao Loki](https://grafana.com/docs/loki/latest/send-data/otel/)

- Para usar o distributed, o opentelemetry deve se conectar ao gateway para http.

### Grafana Dashboard

- Conexões Grafana:
    - Loki
    - http://loki.obs.svc.cluster.local:3100
    - Tempo
    - http://tempo.obs.svc.cluster.local:3100


### Conexão com prometheus:
[Link Consulta - Suporte nativo OTLP (09/2023)](https://prometheus.io/blog/2024/03/14/commitment-to-opentelemetry/)
[Link Consulta - Docs Otel](https://opentelemetry.io/blog/2024/prom-and-otel/)


### Tempo
- Habilitar o service graph [link](https://grafana.com/docs/tempo/latest/configuration/#metrics-generator)



- No values do tempo: 
```YAML
tempo:
  metricsGenerator:
    enabled: true
    remoteWriteUrl: "http://<prometheusserver>.<namespace>:9090/api/v1/write"

```
- No values do prometheus:
```YAML
prometheus:
  prometheusSpec:
     enableRemoteWriteReceiver: true
```

- Se tudo der certo deve aparecer as métricas iniciadas em traces no prometheus.
- Na UI do grafana nas configurações do datasource tempo em aditionalSettings, adicione o prometheus como datasource e marque a opção nodeGraph, como abaixo:
![Prometheus-tempo](../docs-assets/prometheus-tempo.png)

- Após é possível ver o serviceGraph no tempo.

![nodegraph-tempo](../docs-assets/nodegraph-tempo.png)