---
layout: post
title: "Azure explained through diagrams - core components of Azure - part 1"
date: 2026-05-31 21:23:48 +1200
mermaid: true
description: "Part 1 - core components of Azure"
author: "Teppei"
categories: [Azure, Learning, Cloud]
---

Core components of Azure can be categorized into 2 main groups: the physical infrastructure and the management infrastructure

<!--more-->

## Physical Infrastructure

How Azure organize resources:

```mermaid

graph LR
    G["`Geography`"] --> Region
    Region --> A["`**Available Zone**
        - Physical separate datacenter
    `"]
    A --> D["`**Data Center**
        - Servers
        - Cooling
        - Power
        - Network
    `"]

```

Azure Region & availability zones:

- To ensure the resiliency, a minimum of 3 AZs are present in availability zone-enabled region.

```mermaid
flowchart LR

    subgraph Region["Azure Region (e.g., East US)"]

        subgraph AZ1["Availability Zone 1"]
            DC2["Datacenter(s)"]
        end

        subgraph AZ2["Availability Zone 2"]
            DC3["Datacenter(s)"]
        end
    end

    AZ1 --- Fiber["Connected through high-speed private fiber-optic network"]
    Fiber --- AZ2
```

Azure region pairs:

- Replicate resource across geography. Reducing natural disaster, power outages, or physical network outages.
- Not all azure service automatically replicate data or fall back from a failed region.
- Most regions are paired in 2 directions.

```mermaid
graph LR

    subgraph G["Geography ie United State"]
        direction LR
        subgraph R1["Region 1: East US (Active)"]

            AZ1["Availability Zone 1"]

        end

        subgraph R2["Region 1: West US (Passive)"]

            AZ2["Availability Zone 2"]
        end

        AZ1 --> FailOver["`Failedover Replication
            - 300 miles apart
        `"]
        FailOver --> AZ2
    end
```

## Management Infrastructure

```mermaid
graph TB

    A[Azure Account]

    A --> MG1[Management Group - Corporate]
    A --> MG2[Management Group - Development]

    MG1 --> S1[Subscription - Production]
    MG1 --> S2[Subscription - Shared Services]

    MG2 --> S3[Subscription - Dev]
    MG2 --> S4[Subscription - Test]

    S1 --> RG1[Resource Group]
    S2 --> RG2[Resource Group]
    S3 --> RG3[Resource Group]
    S4 --> RG4[Resource Group]

    RG1 --> R1[Azure Resources]
    RG2 --> R2[Azure Resources]
    RG3 --> R3[Azure Resources]
    RG4 --> R4[Azure Resources]
```

| Level            | Purpose                                                                           |
| ---------------- | --------------------------------------------------------------------------------- |
| Azure Account    | Identity used to create and manage Azure environment and billing                  |
| Management Group | It's logical. Used for governance, policies, and permission across subscriptions. |
| Subscription     | Billing, and administrative boundary for Azure resources                          |
| Resource Group   | Logicall container for Azure resource                                             |
| Resource         | Azure resource such as database, VM, App                                          |

Resource Group:

- Each resource can belong to only 1 resource group. Resource can be moved to other group.
- Delete resource group will delete all attached resource
- Can rename after created.
- Resource group can't be nested inside other groups.
- Access permissions are applied to all resources.

Management Group:

- A directory can have up to 1000 management group.
- Each subcription and management group can have only 1 parent
- Nesting: up to 6 level deep (exclude root and subscription levels)

An example how large organizations commonly structure governance using the management group.

```mermaid
graph TD

    Root[Azure Tenant Root Management Group]

    Root --> Corp[Corporate]
    Root --> Platform[Platform]
    Root --> Sandbox[Sandbox]

    Corp --> Prod[Production Subscription]
    Corp --> DR[Disaster Recovery Subscription]

    Platform --> Network[Network Subscription]
    Platform --> Identity[Identity Subscription]

    Sandbox --> Dev[Development Subscription]
    Sandbox --> Test[Testing Subscription]
```
