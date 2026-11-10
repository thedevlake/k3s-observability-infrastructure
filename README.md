# K3s Observability Infrastructure

An AWS-based, Terraform-managed K3s cluster with an integrated observability, runtime security, resource optimisation and cost-monitoring stack.

## Project objectives

- Provision AWS infrastructure using reusable Terraform modules.
- Deploy a two-node K3s cluster on EC2.
- Manage Kubernetes applications and Helm releases through Terraform.
- Integrate Prometheus, Grafana, Loki, Alloy, Falco, VPA and OpenCost.
- Automate infrastructure provisioning, upgrades, rollback and recovery.
- Use GitHub Actions and AWS OIDC for secure CI/CD.

## Architecture

See [Architecture](docs/architecture.md).

## Engineering principles

- Infrastructure as Code: no manual infrastructure changes.
- Reusable Terraform modules.
- Configurable inputs instead of unnecessary hardcoding.
- Least-privilege IAM and security groups.
- Remote Terraform state with locking.
- Pinned provider and Helm chart versions.
- Pull requests for infrastructure changes.
- Automated validation and Terraform plans.
- Documentation of important decisions and operational procedures.

## Repository structure

| Directory | Purpose |
|---|---|
| bootstrap/ | Initial Terraform backend resources |
| infrastructure/ | Independent infrastructure root modules |
| modules/ | Reusable Terraform modules |
| kubernetes/ | K3s configuration |
| platform/ | Observability, logging, security and cost tools |
| scripts/ | Reusable automation scripts |
| docs/ | Architecture, decisions and operational documentation |
| .github/workflows/ | CI/CD workflows |

## Current deployment region

The initial deployment target is AWS Europe (Ireland), `eu-west-1`. The region will remain configurable.

## Project status

Currently in the foundation and architecture phase.
