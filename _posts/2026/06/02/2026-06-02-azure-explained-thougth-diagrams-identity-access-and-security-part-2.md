---
layout: post
title: "Azure explained thougth diagrams - identity, access and security part-2"
date: 2026-06-02 14:50:32 +1200
mermaid: true
description: "Part 2 - identity, access and security"
author: "Teppei"
categories: [Azure, Learning, Cloud]
---

<!--more-->

## Microsoft Entra ID

## Lift-and-shift migration using Microsoft Entra Domain Services

A demonstrated approach to lift-and-shift migration using Microsoft Entra Domain with Microsoft Entra ID and (optionally) on-prem Active Directory.

Migration roadmap: 3 stages (demonstration)

```mermaid
flowchart LR
%% =========================
%% 1. ON-PREM AD (LEGACY)
%% =========================
subgraph A["Stage 1: On-Prem Active Directory (Legacy)"]
    A1[Users & Devices]
    A2[Active Directory Domain Controllers]
    A3[LDAP / Kerberos / NTLM Apps]
    A4["Group Policy (GPO)"]

    A1 --> A2
    A2 --> A3
    A2 --> A4
end

%% =========================
%% 2. HYBRID + LIFT & SHIFT
%% =========================
subgraph B["Stage 2: Hybrid + Lift-and-Shift (Migration Phase)"]
    B1[On-Prem AD]
    B2[Entra Connect Sync]
    B3[Microsoft Entra ID]
    B4[Entra Domain Services]
    B5[Lifted Legacy Apps in Azure VMs]

    B1 --> B2 --> B3 --> B4 --> B5
end

%% =========================
%% 3. MODERN CLOUD NATIVE
%% =========================
subgraph C["Stage 3: Cloud-Native Identity (Target State)"]
    C1[Users & Devices]
    C2[Microsoft Entra ID]
    C3[Modern Apps SaaS / Cloud Apps]
    C4[API / Microservices]

    C1 --> C2
    C2 --> C3
    C2 --> C4
end

%% =========================
%% TRANSITION ARROWS
%% =========================
A --> B
B --> C
```

### Stage 2: lift-and-shift

```mermaid
sequenceDiagram
    autonumber

    participant User as End User
    participant App as Legacy App (Lifted VM in Azure)
    participant CloudApp as Modern App (SaaS / Cloud App)
    participant OnPremAD as On-Prem Active Directory
    participant AAD as Microsoft Entra ID
    participant Sync as Entra Connect / Cloud Sync
    participant AADDS as Entra Domain Services
    participant DC as Managed Domain Controllers (AAD DS)

    %% Identity synchronization (hybrid setup)
    Note over OnPremAD,AAD: Hybrid identity foundation
    OnPremAD->>Sync: Users, groups, password hashes
    Sync->>AAD: Sync identities into Entra ID
    AAD->>AADDS: Replicate identities into managed domain

    %% Cloud app modern authentication
    Note over User,CloudApp: Modern app path (no Domain Services needed)
    User->>CloudApp: Sign-in request
    CloudApp->>AAD: Redirect for authentication (OAuth/OIDC)
    AAD->>User: MFA / Conditional Access challenge
    User->>AAD: Complete MFA
    AAD-->>CloudApp: Issue token (JWT)
    CloudApp-->>User: Access granted

    %% Legacy lift-and-shift app flow
    Note over User,App: Lift-and-shift legacy workload (LDAP/Kerberos)
    User->>App: Access legacy application (RDP / web / client)
    App->>AADDS: LDAP / Kerberos authentication request
    AADDS->>DC: Validate credentials / issue ticket
    DC-->>AADDS: Authentication success
    AADDS-->>App: Kerberos ticket / auth response
    App-->>User: Access granted

    %% Optional modernization path
    Note over App,CloudApp: Application modernization path (future state)
    App->>AAD: Migrate auth from LDAP/Kerberos to OAuth/OIDC
    AAD-->>App: Token-based authentication enabled

```

Hybrid identity foundation

- On-prem AD still exists (common in real enterprises)
- Identity is synchronized into Microsoft Entra ID
- Then propagated into Microsoft Entra Domain Services for legacy workloads

Two authentication worlds running in parallel

1/ Modern apps (preferred path)

- OAuth / OpenID Connect
- Entra ID issues tokens
- MFA + Conditional Access enforced

2/ Legacy lifted apps

- LDAP / Kerberos / NTLM
- Domain-joined VMs in Azure
- Authentication handled via Entra Domain Services

Migration end-state direction - Move applications away from LDAP/Kerberos → toward Entra ID token-based auth

- Entra Domain Services usage decreases
- Legacy dependencies are removed
- Identity becomes fully cloud-native

### Stage 3: Cloud-Native Identity, No Domain Services

> **Main idea:** identity becomes token-based, not domain-based

```mermaid
sequenceDiagram
    autonumber

    participant User as End User
    participant Device as Managed Device (Intune / Azure AD Joined)
    participant App as Modern App (SaaS / Cloud Native)
    participant API as Cloud APIs / Microservices
    participant AAD as Microsoft Entra ID

    %% Device identity
    Note over User,Device: Device is cloud-managed and identity-bound
    User->>Device: Sign in to device
    Device->>AAD: Device registration + user authentication
    AAD-->>Device: Device + user token issued

    %% Modern app access
    Note over User,App: Modern authentication (OAuth2 / OIDC)
    User->>App: Access application
    App->>AAD: Redirect for authentication
    AAD->>User: MFA / Conditional Access (if required)
    User->>AAD: Complete authentication
    AAD-->>App: JWT / Access Token
    App-->>User: Access granted

    %% API / microservices access
    Note over App,API: Token-based service-to-service communication
    App->>AAD: Request service token
    AAD-->>App: Access token (scoped)
    App->>API: Call API with token
    API-->>App: Response

    %% Governance layer
    Note over AAD: Centralized identity governance
    AAD-->>User: Conditional Access, Risk-based policies, Identity Protection
```

Everything uses:

- OAuth2 / OpenID Connect
- JWT tokens
- Conditional Access
- Zero Trust

No need for:

- LDAP
- Kerberos
- Domain join for apps
- Domain Services
