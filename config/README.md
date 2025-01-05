### Crie os seguintes arquivos de configuração

- Esse Labs usa https lets-encrypt
```YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: <seu email aqui>
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
```

- Crie o secret necessário para serviços catalogo
- Os valores devem estar em base64, use o comando abaixo ou [base64encode.org](https://www.base64encode.org/)
```shell
 echo -n 'valor' | base64 
```

```YAML
apiVersion: v1 
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  POSTGRES_USER: '<user>'
  POSTGRES_PASSWORD: '<senha>'
  POSTGRES_DB: '<database>'
---
apiVersion: v1
kind: Secret
metadata:
  name: catalogo-secret
type: Opaque
data:
  DB_USER: '<user>'
  DB_PASSWORD: '<senha>'
  DB_DATABASE: '<database>'
```
- Crie o configmap db-config.yaml
```YAML
apiVersion: v1 
kind: ConfigMap
metadata:
  name: db-config
data:
  DB_HOST: "<ipBancoDeDados ou db (para usar postgreelocal)>"
  PGDATA: "/var/lib/postgresql/data/db"
```