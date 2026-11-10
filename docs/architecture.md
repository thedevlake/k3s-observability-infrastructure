# Architecture

## 1. Project overview

This project provisions and manages a two-node K3s Kubernetes cluster on AWS EC2.

Terraform manages the infrastructure and Helm releases. GitHub Actions provides the CI/CD workflow, while AWS OIDC provides secure authentication without long-lived AWS credentials stored in GitHub.

## 2. High-level architecture

```text
                    GitHub Repository
                           |
                     Pull Requests
                           |
                    GitHub Actions
                           |
                     AWS OIDC Role
                           |
                    Terraform Apply
                           |
                    AWS VPC
                           |
                  Internet Gateway
                           |
                    Public Subnet
                     /         \
                    /           \
             EC2 Server       EC2 Worker
                 |                |
                 |<-------------->|
                 |                |
              K3s Control Plane + Workloads
                           |
                     Helm Releases
                           |
        -----------------------------------------
        |          |          |         |        |
     Prometheus  Grafana     Loki     Falco    OpenCost
        |          |          |         |        |
        -----------------------------------------
                           |
                    VPA Recommendations
                           |
                    Sample Application
                           |
                    Traefik Ingress


