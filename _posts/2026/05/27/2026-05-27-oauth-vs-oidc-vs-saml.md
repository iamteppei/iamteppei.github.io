---
layout: post
title: "OAuth vs OIDC vs SAML"
date: 2026-02-21 10:00:00 +0000
description: "A guide to understanding the differences between OAuth, OIDC, and SAML authentication protocols"
image: /assets/posts/2026/05/27/images/oauth-oidc-saml.svg
image_alt: "Comparison diagram showing OAuth, OIDC, and SAML protocols and their purposes"
author: "Teppei"
categories: [OAuth, Authentication, Security]
mermaid: true
---

OAuth, OIDC, and SAML are all identity and access management standards, but they serve different purposes. OAuth handles authorization by letting apps access resources on a user’s behalf without sharing passwords. OIDC builds on OAuth to provide authentication, confirming a user’s identity through ID tokens. SAML is an older protocol mainly used for enterprise single sign-on (SSO), allowing users to log in once and securely access multiple organisational applications.

<!--more-->

# OAuth vs OIDC vs SAML

Three standards that often come up together, but each solves a different problem.

**OAuth** is about _authorization_ — granting an app limited access to a resource on your behalf, without sharing your password. Think "Allow this app to read your Google Drive."

**OIDC** (OpenID Connect) is about _authentication_ — verifying who you are. It is built on top of OAuth and adds an ID token so the app knows _which_ user just logged in.

**SAML** is an older enterprise standard for _single sign-on (SSO)_. A user logs in once and gains access to all connected applications in an organisation, typically in a corporate environment.

---

|           | What it answers                  | Token type              |
| --------- | -------------------------------- | ----------------------- |
| **OAuth** | Can this app act on your behalf? | Access token            |
| **OIDC**  | Who are you?                     | ID token + Access token |
| **SAML**  | Are you allowed in?              | XML assertion           |

A simple rule of thumb: use **OIDC** (which gives you OAuth too) for modern apps, and **SAML** when integrating with legacy enterprise identity providers.

---

## How each flow works

### OAuth — Authorization Flow

The user grants an app permission to access a resource without sharing their password.

```mermaid
sequenceDiagram
    participant User
    participant App
    participant AuthServer as Authorization Server
    participant API as Resource Server

    User->>App: Click "Connect with Google"
    App->>AuthServer: Redirect with client_id + scope
    AuthServer->>User: Show consent screen
    User->>AuthServer: Grant permission
    AuthServer->>App: Authorization code
    App->>AuthServer: Exchange code for Access Token
    AuthServer->>App: Access Token
    App->>API: Request resource with Access Token
    API->>App: Protected resource
```

---

### OIDC — Authentication Flow

Built on OAuth. The Authorization Server also issues an ID Token so the app knows _who_ the user is.

```mermaid
sequenceDiagram
    participant User
    participant App
    participant AuthServer as Authorization Server (IdP)

    User->>App: Click "Log in with Google"
    App->>AuthServer: Redirect with scope=openid
    AuthServer->>User: Show login + consent screen
    User->>AuthServer: Authenticate
    AuthServer->>App: Authorization code
    App->>AuthServer: Exchange code for tokens
    AuthServer->>App: ID Token + Access Token
    Note over App: Decode ID Token to get user identity<br/>(name, email, sub, etc.)
```

---

### SAML — Enterprise SSO Flow

The user authenticates once with the Identity Provider (IdP) and is granted access to multiple Service Providers (SP) via a signed XML assertion.

```mermaid
sequenceDiagram
    participant User
    participant SP as Service Provider (App)
    participant IdP as Identity Provider (e.g. Okta, AD)

    User->>SP: Access protected resource
    SP->>User: Redirect to IdP with SAML Request
    User->>IdP: Authenticate (username + password / MFA)
    IdP->>User: SAML Response (signed XML assertion)
    User->>SP: Post SAML Response
    SP->>SP: Validate assertion signature
    SP->>User: Grant access
```
