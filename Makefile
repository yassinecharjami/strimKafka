KUSTOMIZE_OVERLAY ?= k8s/overlays/dev

.PHONY: bootstrap apply delete port-forward

bootstrap:
kubectl apply -k k8s/base/monitoring
kubectl apply -k k8s/base/strimzi-operator
kubectl apply -k k8s/base/namespaces

apply:
kubectl apply -k $(KUSTOMIZE_OVERLAY)

delete:
kubectl delete -k $(KUSTOMIZE_OVERLAY) --ignore-not-found

port-forward:
kubectl -n kafka port-forward svc/akhq 8080:8080