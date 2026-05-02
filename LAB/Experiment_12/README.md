## Experiment 12: Study and Analyse Container Orchestration using Kubernetes


#### **What is Kubernetes?**
Kubernetes (K8s) is an open-source container orchestration platform that automates deployment, scaling, and management of containerized applications. It ensures your app keeps running, scales automatically, and recovers from failures — without manual intervention.

#### **Why Kubernetes over Docker Swarm?**

| Reason | Explanation |
|--------|-------------|
| Industry standard | Most companies use Kubernetes |
| Powerful scheduling | Automatically decides where to run your app |
| Large ecosystem | Many tools and plugins available |
| Cloud-native support | Works on AWS, Google Cloud, Azure, etc. |

#### **Core Kubernetes Concepts:**

| Docker Concept | Kubernetes Equivalent | What it means |
|---------------|----------------------|---------------|
| Container | **Pod** | A group of one or more containers. Smallest unit in K8s. |
| Compose service | **Deployment** | Describes how your app should run (e.g., 2 copies, which image to use) |
| Load balancing | **Service** | Exposes your app to the outside world or other pods |
| Scaling | **ReplicaSet** | Ensures a certain number of pod copies are always running |

#### **Tool Selection Guide:**

| Tool | Best for |
|------|----------|
| **k3d** | Quick learning on your laptop |
| **Minikube** | Single-node cluster testing |
| **kubeadm** | Real, production-style cluster |



---

### Part A — Basic Deployment & Service (k3d)

---

**Step-1:- Create `wordpress-deployment.yaml`**
```bash
nano wordpress-deployment.yaml
```
```yaml
# wordpress-deployment.yaml
apiVersion: apps/v1          # Which Kubernetes API to use
kind: Deployment             # Type of resource
metadata:
  name: wordpress            # Name of this deployment
spec:
  replicas: 2                # Run 2 identical pods
  selector:
    matchLabels:
      app: wordpress         # Pods with this label belong to this deployment
  template:
    metadata:
      labels:
        app: wordpress       # Label applied to each pod
    spec:
      containers:
      - name: wordpress
        image: wordpress:latest   # Docker image
        ports:
        - containerPort: 80       # Port inside the container
```
![Create Deployment YAML](img1.png)


**Step-2:- Apply the Deployment**
```bash
kubectl apply -f wordpress-deployment.yaml
```
>  Kubernetes creates 2 pods running WordPress.

![Apply Deployment](img2.png)


**Step-3:- Create `wordpress-service.yaml`**

Pods are **temporary** (they can be deleted or recreated). A **Service** gives them a fixed IP and exposes them to the outside.
```bash
nano wordpress-service.yaml
```
```yaml
# wordpress-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: wordpress-service
spec:
  type: NodePort                  # Exposes service on a port of each node (VM)
  selector:
    app: wordpress                # Send traffic to pods with this label
  ports:
    - port: 80                    # Service port
      targetPort: 80              # Pod port
      nodePort: 30007             # External port (range: 30000-32767)
```
![Create Service YAML](img3.png)


**Step-4:- Apply the Service**
```bash
kubectl apply -f wordpress-service.yaml
```
![Apply Service](img5.png)


**Step-5:- Verify Pods are Running**
```bash
kubectl get pods
```
Expected output:
```
NAME                         READY   STATUS    RESTARTS   AGE
wordpress-xxxxx-yyyyy        1/1     Running   0          1m
wordpress-xxxxx-zzzzz        1/1     Running   0          1m
```
![Get Pods](img6.png)


**Step-6:- Verify the Service**
```bash
kubectl get svc
```
Expected output:
```
NAME                TYPE       CLUSTER-IP    PORT(S)        AGE
wordpress-service   NodePort   10.43.x.x     80:30007/TCP   1m
```
![Get Services](img7.png)


**Step-7:- Access WordPress in Browser**
```
http://<node-ip>:30007
```


![Access WordPress](img8.png)


**Step-8:- Scale the Deployment**

Increase the number of pods from 2 to 4:
```bash
kubectl scale deployment wordpress --replicas=4
```
Verify:
```bash
kubectl get pods
```
> I now see **4 running pods**.
>  More traffic → more copies → better performance.

![Scale Deployment](img9.png)


**Step-9:- Self-Healing Demonstration**

Kubernetes automatically replaces failed pods. Delete one pod manually to observe:
```bash
# First, get pod names
kubectl get pods

# Delete one (replace <pod-name> with an actual name from above)
kubectl delete pod <pod-name>
```
Now check pods again:
```bash
kubectl get pods
```
> I still see **4 pods** — the deleted one was **automatically recreated**.
>
> **Why?** The deployment ensures the desired number (4) is always running.

![Self Healing](img10.png)

---

### Part B — Docker Swarm vs Kubernetes Comparison

---

| Feature | Docker Swarm | Kubernetes |
|---------|-------------|------------|
| Setup | Very easy | More complex |
| Scaling | Basic | Advanced (auto-scaling) |
| Ecosystem | Small | Huge (monitoring, logging) |
| Industry use | Rare | Standard |



---



| Goal | Command |
|------|---------|
| Apply a YAML file | `kubectl apply -f file.yaml` |
| See all pods | `kubectl get pods` |
| See all services | `kubectl get svc` |
| Scale a deployment | `kubectl scale deployment <name> --replicas=N` |
| Delete a pod | `kubectl delete pod <pod-name>` |
| See all nodes | `kubectl get nodes` |
| Describe a pod | `kubectl describe pod <pod-name>` |
| View pod logs | `kubectl logs <pod-name>` |
