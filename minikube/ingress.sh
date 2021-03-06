kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-rbac.yaml

kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-deployment.yaml


kubectl --namespace=kube-system get pods

kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/ui.yaml


echo "$(./minikube ip) traefik-ui.minikube" | sudo tee -a /etc/hosts

kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/cheese-deployments.yaml


kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/cheese-services.yaml


kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/cheese-ingress.yaml


echo "$(./minikube ip) stilton.minikube cheddar.minikube wensleydale.minikube" | sudo tee -a /etc/hosts

echo -e "This script have set up below applications"
echo -e "Loadbalancer link:"
echo -e "http://traefik-ui.minikube:$(kubectl get services --namespace=kube-system | grep traefik-ingress-service | awk -F[:/] '{print $2}')"

echo -e "\n"

echo "Add below hosts file entries"
echo -e "$(./minikube ip) stilton.minikube cheddar.minikube wensleydale.minikube traefik-ui.minikube"
echo -e "http://stilton.minikube:$(kubectl get services --namespace=kube-system | grep traefik-ingress-service | awk -F[:/] '{print $2}')"
echo -e "http://cheddar.minikube:$(kubectl get services --namespace=kube-system | grep traefik-ingress-service | awk -F[:/] '{print $2}')"
echo -e "http://wensleydale.minikube:$(kubectl get services --namespace=kube-system | grep traefik-ingress-service | awk -F[:/] '{print $2}')"


