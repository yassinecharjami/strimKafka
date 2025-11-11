# 🧭 strimKafka

**A production-grade, GitOps-driven Kafka ecosystem on Kubernetes** — fully observable, secure, and extensible.

---

## 🚀 Overview

This project implements a complete **Kafka Platform** for production environments using:
- **Strimzi** for Kafka cluster orchestration (KRaft, TLS, SASL/SCRAM)
- **Cruise Control** for dynamic rebalancing
- **Prometheus & Grafana** for observability
- **AKHQ** for topic & consumer management
- **Argo CD** for GitOps deployment
- **Kustomize overlays** for environment isolation

---

## 🏗️ Architecture

```
┌────────────────────────────────────────────────────────┐
│                        Argo CD                        │
│              (GitOps App-of-Apps Model)               │
└──────────────┬────────────────────────────────────────┘
               │
               ├── Namespaces
               ├── Monitoring Stack (Prometheus + Grafana)
               ├── Strimzi Operator
               ├── Kafka Cluster (KRaft + TLS + SCRAM)
               └── AKHQ & Demo Apps (Producer/Consumer)
```

Each component is declaratively managed through **Argo CD**, ensuring consistency, auditability, and rollback capabilities.

---

## 🧩 Repository Structure

```
repo-root/
├─ k8s/
│  ├─ base/                  # Core manifests (Kafka, Strimzi, AKHQ, Monitoring)
│  └─ overlays/
│     ├─ dev/                # Local testing environment
│     └─ prod-secure/        # Production-grade configuration
├─ apps/                     # Example producer/consumer
├─ argocd/                   # GitOps manifests (App-of-Apps)
└─ .github/workflows/        # CI/CD pipelines
```

---

## ⚙️ Quick Start

### Local (Kind or Minikube)

```bash
# 1. Create a local cluster
kind create cluster --name kafka-lab

# 2. Deploy base stack
kubectl apply -k k8s/overlays/dev

# 3. Access AKHQ UI
kubectl -n kafka port-forward svc/akhq 8080:8080
open http://localhost:8080
```

### Production (Argo CD)

```bash
# 1. Install Argo CD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 2. Apply project and root application
kubectl apply -f argocd/projects/platform.yaml
kubectl apply -f argocd/apps/platform-root.yaml
```

Argo CD will automatically deploy:
- Namespaces → Monitoring Stack → Strimzi → Kafka + AKHQ → Demo Apps

---

## 🔐 Security Features

✅ **KRaft mode** — no ZooKeeper, improved resiliency  
✅ **TLS + SASL/SCRAM** authentication  
✅ **NetworkPolicies** for namespace isolation  
✅ **PodDisruptionBudgets (PDBs)** for controlled maintenance  
✅ **Resource limits and requests**  
✅ **RBAC-scoped Strimzi Operator**

---

## 📊 Observability

| Component | Metrics Source | Visualization |
|------------|----------------|----------------|
| Kafka Brokers | JMX Exporter | Grafana Dashboard |
| Cruise Control | JMX Exporter | Grafana Dashboard |
| AKHQ | HTTP | Grafana / Logs |
| Prometheus | Operator | Alertmanager / Grafana |

Access Grafana:
```bash
kubectl -n monitoring port-forward svc/grafana 3000:3000
open http://localhost:3000
```

---

## 🧪 Continuous Integration

**GitHub Actions** pipeline (`.github/workflows/deploy-kafka-platform.yml`):
- YAML & Kustomize linting
- Security scanning (Trivy)
- Docker build & push (Producer/Consumer)
- Kubernetes deployment (staging/prod)
- Slack notifications

---

## 🧾 Environments

| Environment | Path | Description |
|--------------|------|--------------|
| **dev** | `k8s/overlays/dev` | Lightweight local deployment |
| **prod-secure** | `k8s/overlays/prod-secure` | KRaft, TLS/SCRAM, PDB, NetworkPolicies |

---

## 🔄 Operations

| Task | Command |
|------|----------|
| Scale Kafka | `kubectl scale statefulset/my-cluster-kafka -n kafka --replicas=5` |
| Check status | `kubectl get kafkas -n kafka` |
| Inspect topics | `kubectl exec -it <broker-pod> -n kafka -- kafka-topics.sh --list --bootstrap-server localhost:9092` |

---

## 🧩 Future Enhancements

- [ ] Add Schema Registry & Kafka Connect
- [ ] Implement Argo Rollouts for canary deployments
- [ ] Integrate External Secrets Operator (Vault/GCP Secret Manager)
- [ ] Add Chaos Mesh for fault injection testing

---

## 📚 References

- [Strimzi Documentation](https://strimzi.io/docs)
- [Argo CD](https://argo-cd.readthedocs.io)
- [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator)
- [AKHQ](https://akhq.io)
- [Cruise Control](https://github.com/linkedin/cruise-control)

---

**License:** MIT