# Infrastructure

## AWS Zones

The availability zones for the regions can be checked in CloudConsole or using the AWS CLI.

```bash
aws ec2 describe-availability-zones --region us-east-2 --output table # Ohio
aws ec2 describe-availability-zones --region us-west-1 --output table # N. California
```

- Zone 1: "us-east-2a", "us-east-2b", "us-east-2c"
- Zone 2: "us-west-1a", "us-west-1b"

## Servers and Clusters

### Table 1.1 Summary

| Asset                     | Purpose                                  | Size        | Qty | DR                                                            |
|---------------------------|------------------------------------------|-------------|-----|---------------------------------------------------------------|
| EC2 Instances (VM)        | Hosts for HA workloads                   | t3.micro    | 3   | Deployed across multiple availability zones                   |
| EKS Kubernetes Nodes      | Containers for application orchestration | t3.medium   | 2   | Nodes distributed across multiple availability zones          |
| VPC                       | Networking for resources                 | N/A         | 1   | Contains IPs distributed across multiple availability zones   |
| Application Load Balancer | Distribute traffic across instances      | N/A         | 1   | Deployed in each region                                       |
| SQL Primary Node          | Primary database cluster node            | db.t2.small | 1   | Deployed in zone1, replicates to zone2                        |
| SQL Secondary Node        | Secondary database cluster node          | db.t2.small | 1   | Deployed in zone2 for high availability and disaster recovery |
| SQL Backup Retention      | Backup retention for SQL cluster         | N/A         | 1   | Backups retained for 5 days, accessible for recovery          |

### Descriptions

- EC2 Instances (VM): Require a minimum of 3 instances for HA workloads.
  Deployed across multiple availability zones.
  A small t3.micro instance type is sufficient for this workload.
- EKS Kubernetes Nodes: Require a minimum of 2 nodes for application orchestration.
- Load Balancer: It is mandatory to deploy an application load balancer in each region.
- SQL Cluster: The primary and secondary nodes are deployed in different availability zones.
  The primary node is deployed in zone1 and replicates to the secondary node in zone2.
  The backup retention window shall be set to 5 days.

## DR Plan

### Pre-Steps:

Checklist before starting the DR process:

- [ ] Confirm zone1 and zone2 have identical configurations
      (networking, resources, and dependencies).
- [ ] Use Terraform to plan both deployments, carefully review the changes,
      and ensure there are no conflicts, missing resources or deprecated elements.
- [ ] Test failover procedures in a staging environment to validate the DR plan.

## Steps:

- [ ] Check healthchecks for all critical services in zone1
      to confirm the issue and assess the situation.
- [ ] Redirect DNS traffic to the secondary region and monitor DNS propagation.
- [ ] Confirm the application is fully operational in the secondary region
      (by re-running healthchecks, monitor tools, etc).
- [ ] Update the application configuration to point to the secondary SQL cluster as primary
      and ensure all database connections are successful.
- [ ] Validate application functionality with live traffic
- [ ] Confirm data consistency between zones.
