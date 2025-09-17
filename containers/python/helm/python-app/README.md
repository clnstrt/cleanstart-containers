# Python App Helm Chart

This Helm chart deploys the CleanStart Python application on a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- CleanStart Python container image

## Installing the Chart

To install the chart with the release name `my-python-app`:

```bash
helm install my-python-app ./python-app
```

The command deploys the Python application on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-python-app` deployment:

```bash
helm uninstall my-python-app
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)   | `""`  |

### Image parameters

| Name                | Description                                                                 | Value                   |
| ------------------- | --------------------------------------------------------------------------- | ----------------------- |
| `image.repository`  | Python image repository                                                     | `cleanstart/python`     |
| `image.tag`         | Python image tag (immutable tags are recommended)                           | `""`                     |
| `image.pullPolicy`  | Python image pull policy                                                     | `Always`                |
| `image.pullSecrets` | Python image pull secrets                                                    | `[]`                    |

### Service Account parameters

| Name                     | Description                                                                 | Value   |
| ------------------------ | --------------------------------------------------------------------------- | ------- |
| `serviceAccount.create`  | Specifies whether a ServiceAccount should be created                        | `true`  |
| `serviceAccount.name`    | The name of the ServiceAccount to use.                                      | `""`    |
| `serviceAccount.annotations` | Additional custom annotations for the ServiceAccount                    | `{}`    |

### Pod Security Context parameters

| Name                | Description                                                                 | Value   |
| ------------------- | --------------------------------------------------------------------------- | ------- |
| `podSecurityContext.runAsNonRoot` | Set the container's security context runAsNonRoot                    | `true`  |
| `podSecurityContext.runAsUser`    | Set the container's security context runAsUser                         | `1001`  |
| `podSecurityContext.runAsGroup`  | Set the container's security context runAsGroup                        | `1001`  |
| `podSecurityContext.fsGroup`     | Set the container's security context fsGroup                            | `1001`  |

### Security Context parameters

| Name                     | Description                                                                 | Value   |
| ------------------------ | --------------------------------------------------------------------------- | ------- |
| `securityContext.allowPrivilegeEscalation` | Set the container's security context allowPrivilegeEscalation      | `false` |
| `securityContext.readOnlyRootFilesystem`    | Set the container's security context readOnlyRootFilesystem        | `false` |
| `securityContext.runAsNonRoot`              | Set the container's security context runAsNonRoot                   | `true`  |
| `securityContext.runAsUser`                 | Set the container's security context runAsUser                       | `1001`  |
| `securityContext.runAsGroup`                | Set the container's security context runAsGroup                      | `1001`  |

### Deployment parameters

| Name                | Description                                                                 | Value |
| ------------------- | --------------------------------------------------------------------------- | ----- |
| `replicaCount`      | Number of replicas                                                          | `3`   |
| `podAnnotations`    | Pod annotations                                                              | `{}`  |
| `podLabels`         | Pod labels                                                                  | `{}`  |

### Service parameters

| Name                | Description                                                                 | Value       |
| ------------------- | --------------------------------------------------------------------------- | ----------- |
| `service.type`      | Kubernetes Service type                                                      | `ClusterIP` |
| `service.port`      | Service HTTP port                                                            | `5000`      |
| `service.targetPort` | Service HTTP target port                                                   | `5000`      |
| `service.protocol`  | Service HTTP protocol                                                        | `TCP`       |
| `service.name`      | Service HTTP port name                                                       | `http`      |
| `service.annotations` | Additional custom annotations for the Service                            | `{}`        |
| `service.sessionAffinity` | Control where client requests go, to the same pod or round-robin      | `None`      |

### Ingress parameters

| Name                | Description                                                                 | Value   |
| ------------------- | --------------------------------------------------------------------------- | ------- |
| `ingress.enabled`   | Enable ingress record generation for Python                                | `false` |
| `ingress.className` | IngressClass resource. The controller may be specified as a class         | `nginx` |
| `ingress.annotations` | Additional annotations for the Ingress resource                          | `{}`    |
| `ingress.hosts`     | An array of hosts to be covered with this ingress record                   | `[]`    |
| `ingress.tls`       | TLS configuration for additional hostname(s) to be covered with this ingress record | `[]` |

### Resource parameters

| Name                | Description                                                                 | Value   |
| ------------------- | --------------------------------------------------------------------------- | ------- |
| `resources.limits` | The resources limits for the Python container                              | `{}`    |
| `resources.requests` | The requested resources for the Python container                           | `{}`    |

### Autoscaling parameters

| Name                | Description                                                                 | Value   |
| ------------------- | --------------------------------------------------------------------------- | ------- |
| `autoscaling.enabled` | Enable Horizontal POD autoscaling for Python                             | `true`  |
| `autoscaling.minReplicas` | Minimum number of Python replicas                                        | `2`     |
| `autoscaling.maxReplicas` | Maximum number of Python replicas                                        | `10`    |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization percentage                                        | `70`    |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization percentage                                   | `80`    |

### Node parameters

| Name                | Description                                                                 | Value |
| ------------------- | --------------------------------------------------------------------------- | ----- |
| `nodeSelector`      | Node labels for pod assignment                                              | `{}`  |
| `tolerations`      | Tolerations for pod assignment                                              | `[]`  |
| `affinity`          | Affinity for pod assignment                                                 | `{}`  |

### Persistence parameters

| Name                | Description                                                                 | Value   |
| ------------------- | --------------------------------------------------------------------------- | ------- |
| `persistence.enabled` | Enable persistence using Persistent Volume Claims                         | `false` |
| `persistence.storageClass` | Persistent Volume storage class                                          | `""`    |
| `persistence.accessMode` | Persistent Volume access mode                                             | `ReadWriteOnce` |
| `persistence.size` | Persistent Volume size                                                      | `10Gi`  |
| `persistence.annotations` | Additional custom annotations for the PVC                               | `{}`    |

### Network Policy parameters

| Name                | Description                                                                 | Value   |
| ------------------- | --------------------------------------------------------------------------- | ------- |
| `networkPolicy.enabled` | Enable NetworkPolicy                                                      | `false` |
| `networkPolicy.ingress` | Ingress rules for the NetworkPolicy                                       | `{}`    |
| `networkPolicy.egress` | Egress rules for the NetworkPolicy                                        | `{}`    |

### Pod Disruption Budget parameters

| Name                | Description                                                                 | Value   |
| ------------------- | --------------------------------------------------------------------------- | ------- |
| `podDisruptionBudget.enabled` | Enable Pod Disruption Budget                                             | `true`  |
| `podDisruptionBudget.minAvailable` | Minimum number of pods that must be available                           | `1`     |
| `podDisruptionBudget.maxUnavailable` | Maximum number of pods that can be unavailable                          | `1`     |

### Environment variables

The chart supports a comprehensive set of environment variables for configuring the Python application. See the `values.yaml` file for the complete list of available environment variables.

### Secrets

The chart supports creating Kubernetes secrets for sensitive configuration data. All secrets are base64 encoded automatically. See the `values.yaml` file for the complete list of available secrets.

## Configuration and installation details

### Using custom values

You can customize the installation by providing a custom values file:

```bash
helm install my-python-app ./python-app -f my-values.yaml
```

### Using environment variables

You can also set environment variables directly:

```bash
helm install my-python-app ./python-app --set env.FLASK_ENV=production
```

### Using secrets

For sensitive data, use secrets:

```bash
helm install my-python-app ./python-app --set secrets.database.password=mysecretpassword
```

## Examples

### Basic installation

```bash
helm install my-python-app ./python-app
```

### Installation with custom values

```bash
helm install my-python-app ./python-app \
  --set replicaCount=5 \
  --set service.type=LoadBalancer \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=python-app.example.com
```

### Installation with persistence

```bash
helm install my-python-app ./python-app \
  --set persistence.enabled=true \
  --set persistence.size=20Gi \
  --set persistence.storageClass=fast-ssd
```

### Installation with autoscaling

```bash
helm install my-python-app ./python-app \
  --set autoscaling.enabled=true \
  --set autoscaling.minReplicas=3 \
  --set autoscaling.maxReplicas=20 \
  --set autoscaling.targetCPUUtilizationPercentage=60
```

## Troubleshooting

### Check pod status

```bash
kubectl get pods -l app.kubernetes.io/name=python-app
```

### Check logs

```bash
kubectl logs -l app.kubernetes.io/name=python-app -f
```

### Check service

```bash
kubectl get svc -l app.kubernetes.io/name=python-app
```

### Check ingress

```bash
kubectl get ingress -l app.kubernetes.io/name=python-app
```

### Check HPA

```bash
kubectl get hpa -l app.kubernetes.io/name=python-app
```

## Support

- CleanStart Website: https://www.cleanstart.com
- Python Official Documentation: https://docs.python.org/
- Flask Documentation: https://flask.palletsprojects.com/
- Kubernetes Documentation: https://kubernetes.io/docs/
- Helm Documentation: https://helm.sh/docs/
