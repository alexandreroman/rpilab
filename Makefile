K8S_CONTEXT=rpilab

all: sync

sync:
	cat addons/promtail/secret.yaml | kubeseal --context ${K8S_CONTEXT} --controller-namespace sealed-secrets --format yaml > addons/promtail/sealed-secret.yaml
	cat apps/rpilab-router/app-secret.yaml | kubeseal --context ${K8S_CONTEXT} --controller-namespace sealed-secrets --format yaml > apps/rpilab-router/app-sealed-secret.yaml
	cat apps/hello-rpilab/otel-secret.yaml | kubeseal --context ${K8S_CONTEXT} --controller-namespace sealed-secrets --format yaml > apps/hello-rpilab/otel-sealed-secret.yaml
	cat apps/hello-rpilab/app-secret.yaml | kubeseal --context ${K8S_CONTEXT} --controller-namespace sealed-secrets --format yaml > apps/hello-rpilab/app-sealed-secret.yaml
	cat apps/html-assistant/app-secret.yaml | kubeseal --context ${K8S_CONTEXT} --controller-namespace sealed-secrets --format yaml > apps/html-assistant/app-sealed-secret.yaml
	cat apps/chess-ai/app-secret.yaml | kubeseal --context ${K8S_CONTEXT} --controller-namespace sealed-secrets --format yaml > apps/chess-ai/app-sealed-secret.yaml
	cat apps/resumebot/app-secret.yaml | kubeseal --context ${K8S_CONTEXT} --controller-namespace sealed-secrets --format yaml > apps/resumebot/app-sealed-secret.yaml
	cat apps/temporal-story/app-secret.yaml | kubeseal --context ${K8S_CONTEXT} --controller-namespace sealed-secrets --format yaml > apps/temporal-story/app-sealed-secret.yaml

reconcile:
	flux --context ${K8S_CONTEXT} reconcile source git -n rpilab-system rpilab && \
	flux --context ${K8S_CONTEXT} reconcile kustomization -n rpilab-system rpilab-addons && \
	flux --context ${K8S_CONTEXT} reconcile kustomization -n rpilab-system rpilab-apps

install:
	kapp deploy -a fluxcd -f https://github.com/fluxcd/flux2/releases/download/v2.7.5/install.yaml
	kapp deploy -a rpilab -f clusters/rpilab.yaml
