K8S_CONTEXT=rpilab

all: sync

sync:
	cat addons/promtail/secret.yaml | kubeseal --context ${K8S_CONTEXT} --controller-namespace sealed-secrets --format yaml > addons/promtail/sealed-secret.yaml
	cat apps/hello-rpilab/otel-secret.yaml | kubeseal --context ${K8S_CONTEXT} --controller-namespace sealed-secrets --format yaml > apps/hello-rpilab/otel-sealed-secret.yaml
	cat apps/hello-rpilab/app-secret.yaml | kubeseal --context ${K8S_CONTEXT} --controller-namespace sealed-secrets --format yaml > apps/hello-rpilab/app-sealed-secret.yaml

reconcile:
	flux --context ${K8S_CONTEXT} reconcile source git -n rpilab-system rpilab && \
	flux --context ${K8S_CONTEXT} reconcile kustomization -n rpilab-system rpilab-addons && \
	flux --context ${K8S_CONTEXT} reconcile kustomization -n rpilab-system rpilab-apps

install:
	kapp deploy -a fluxcd -f https://github.com/fluxcd/flux2/releases/download/v2.4.0/install.yaml
	kapp deploy -a rpilab -f clusters/rpilab.yaml
