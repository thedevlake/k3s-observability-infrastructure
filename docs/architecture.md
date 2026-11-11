
# Architecture

## 1. Project overview

This project provisions and manages a two-node K3s Kubernetes cluster on AWS EC2.

Terraform manages AWS infrastructure and Helm releases. GitHub Actions provides CI/CD, while AWS OIDC enables secure authentication without storing long-lived AWS credentials in GitHub.

## 2. High-level architecture

```text
                  GitHub Repository
                         |
                   Pull Requests
                         |
                  GitHub Actions
                         |
                    AWS OIDC
                         |
                    Terraform
                         |
                    AWS VPC
                         |
                  Internet Gateway
                         |
                    Public Subnet
                    /           \
             K3s Server       K3s Worker
                    \           /
                     Kubernetes
                          |
                    Helm Releases
                          |
       ------------------------------------------
       |              |             |            |
  Monitoring       Logging       Security      Cost
       |              |             |            |
  Prometheus         Loki          Falco       OpenCost
  Grafana            Alloy      Falcosidekick
  Alertmanager
       |
  Dashboards and Alerts

       Kubernetes workloads
              |
       ----------------
       |              |
   Sample App        VPA
       |
    Traefik
       |
  Application Access
```

## 3. Infrastructure layers

### Bootstrap
Creates the resources required for remote Terraform state:
- S3 state bucket.
- Bucket versioning.
- Encryption.
- Public access blocking.
- Native S3 state locking.

The bootstrap layer initially uses local state. We will migrate it to S3 after creating the bucket.

### Networking
Creates:
- VPC.
- Public subnet(s).
- Internet Gateway.
- Route tables and routes.
- Security groups.

### Compute
Creates:
- K3s server EC2 instance.
- K3s worker EC2 instance.
- IAM roles and instance profiles.
- Systems Manager access.
- Required instance configuration.

### Kubernetes
Installs and configures K3s using EC2 user data.

The server securely provides the worker with the required cluster join information through AWS Systems Manager Parameter Store.

### Platform
Terraform manages Helm releases and their configuration:

- kube-prometheus-stack.
- Loki.
- Grafana Alloy.
- Falco and Falcosidekick.
- Vertical Pod Autoscaler.
- OpenCost.

K3s includes Traefik by default, which we will configure for application ingress.

### CI/CD
GitHub Actions handles:
- Terraform formatting and validation.
- Pull request plans.
- Approved deployment after merge.
- Infrastructure upgrades and rollback workflows.

AWS authentication uses OIDC and IAM roles.

## 4. State management

Terraform configurations will be separated into independent root modules:

- Bootstrap.
- Networking.
- Compute.
- Kubernetes/platform.

Each layer will have its own state and explicit dependencies through outputs and remote-state references where appropriate.

## 5. Security principles

- No AWS credentials committed to Git.
- GitHub Actions authenticates through OIDC.
- EC2 instances use least-privilege IAM roles.
- The worker retrieves only the specific parameter it needs.
- No publicly exposed Kubernetes API.
- No unrestricted SSH access.
- Security group rules are restricted to required sources and ports.
- Secrets are not stored in Terraform source files.

## 6. Cost considerations

This is a learning environment, so cost is an architectural consideration.

The initial design uses public subnets and an Internet Gateway to avoid NAT Gateway charges. Inbound access remains restricted through security groups and Systems Manager.

We will evaluate EC2 sizing, persistent storage, logging retention and other recurring costs before deployment.

## 7. Deployment lifecycle

1. Bootstrap remote state.
2. Provision networking.
3. Provision EC2 and IAM resources.
4. Install K3s and join the worker.
5. Deploy Helm releases.
6. Configure dashboards, alerts and data sources.
7. Deploy and test a sample application.
8. Test monitoring, logging, security and cost visibility.
9. Upgrade K3s and Helm charts through pull requests.
10. Demonstrate rollback and recovery.
11. Destroy and recreate infrastructure through automation.

