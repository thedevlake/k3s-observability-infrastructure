# Architecture Decision Records

This document records important technical decisions and their reasoning.

## ADR-001: Terraform for infrastructure provisioning

**Decision:** Use Terraform to provision and manage AWS infrastructure.

**Reason:** Terraform provides declarative infrastructure management, reusable modules, state tracking and repeatable deployments.

## ADR-002: Modular Terraform architecture

**Decision:** Use separate root modules for independent infrastructure layers and reusable child modules for cohesive components.

**Reason:** This improves maintainability, reusability and isolation of changes.

We will avoid creating a separate module for every individual resource.

## ADR-003: AWS EC2 with K3s

**Decision:** Use two EC2 instances to host a K3s server and worker.

**Reason:** K3s provides a lightweight Kubernetes distribution suitable for this learning environment without the overhead and cost of a managed Kubernetes control plane.

## ADR-004: Public subnet deployment for the initial environment

**Decision:** Initially place both EC2 instances in public subnets with restricted inbound access.

**Reason:** Avoid recurring NAT Gateway costs while allowing instances to access required external services.

**Trade-off:** Public IP assignment increases the importance of restrictive security groups. No unrestricted SSH or public Kubernetes API access will be allowed.

## ADR-005: AWS Systems Manager instead of SSH

**Decision:** Use Systems Manager for instance administration and automated commands.

**Reason:** Avoid exposing SSH and centralise access through IAM-controlled permissions.

## ADR-006: Secure worker joining

**Decision:** Store the K3s join token in AWS Systems Manager Parameter Store as a SecureString.

**Reason:** Avoid hardcoding or manually transferring cluster credentials.

## ADR-007: Terraform remote state

**Decision:** Use an encrypted, versioned S3 bucket with native S3 state locking.

**Reason:** Provide shared state storage, recovery through versioning and protection against concurrent state modifications.

## ADR-008: GitHub Actions and AWS OIDC

**Decision:** Use GitHub Actions with AWS OIDC authentication.

**Reason:** Avoid long-lived AWS access keys and automate infrastructure validation and deployment.

## ADR-009: Terraform-managed Helm releases

**Decision:** Use Terraform Helm provider resources to manage chart installations and upgrades.

**Reason:** Keep Kubernetes platform deployments version-controlled and reproducible.

## ADR-010: Version pinning

**Decision:** Pin Terraform providers, modules where applicable, and Helm chart versions.

**Reason:** Reduce unexpected changes and make upgrades deliberate and reviewable.

## ADR-011: Pull-request deployment workflow

**Decision:** Run validation and Terraform plans on pull requests. Apply approved changes after merging into main.

**Reason:** Ensure infrastructure changes are reviewed before deployment.

Only one infrastructure deployment PR should be merged and applied at a time.
