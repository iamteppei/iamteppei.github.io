---
layout: post
title: "Understanding MCP via Diagrams"
date: 2026-05-28 22:18:40 +1200
description: "Visual exploration of the Model Context Protocol (MCP) architecture, components, and interactions"
image: /assets/posts/2026/05/28/images/mcp-architecture.svg
image_alt: "MCP architecture diagram showing clients, servers, and protocol interactions"
author: "Teppei"
categories: [MCP, Architecture, Protocol, AI]
mermaid: true
---

Model Context Protocol (MCP) is an open standard that enables AI models to securely connect with external tools, data sources, and applications. It acts as a bridge between AI systems and services such as databases, APIs, file systems, and business platforms, allowing models to access real-time information and perform actions beyond their built-in knowledge. By standardizing these connections, MCP simplifies integration, improves interoperability, and helps developers build more powerful and context-aware AI applications.

<!--more-->

## High-Level MCP Architecture

```mermaid
flowchart TB

    Client["MCP Client"] <-->|Transport Layer| Server["MCP Server"]

    subgraph TransportLayer["Transport Layer"]
        STDIO["stdio (local)"]
        HTTP["Streaming HTTP"]
    end

    Client --> TransportLayer
    TransportLayer --> Server

    subgraph ClientFeatures["Client Features"]
        Sampling["Sampling"]
        Elicitation["Elicitation"]
        Logging["Logging"]
    end

    subgraph ServerFeatures["Server Features"]
        Tools["Tools"]
        Resources["Resources"]
        Prompts["Prompts"]
    end

    Client --> ClientFeatures
    Server --> ServerFeatures
```

## MCP Lifecycle Management

```mermaid
sequenceDiagram
    participant Client
    participant Server

    Note over Client,Server: Initialization Phase

    Client->>Server: Initialize Request
    Server->>Client: Version Compatibility
    Server->>Client: Exchange Capabilities
    Server->>Client: Share Implementation Details

    Note over Client,Server: Execution Phase

    Client->>Server: Tool / Resource / Prompt Requests
    Server->>Client: Responses / Notifications

    Note over Client,Server: Shutdown Phase

    Client->>Server: Shutdown Request
    Server->>Client: Session Closed
```

## Data Layer Features

```mermaid
mindmap
  root((MCP Data Layer))

    Lifecycle Management
      Initialization
      Execution
      Shutdown

    Server Features
      Tools
      Resources
      Prompts

    Client Features
      Sampling
        "Server asks client's AI/LLM"
      Elicitation
        "Ask user for more info"
      Logging
        "Debugging & logs"

    Utility Features
      Notifications
      Progress Tracking
```

## Transport Layer & Stateful Sessions

```mermaid
flowchart LR

    subgraph Local["Local Connection"]
        STDIO["stdio"]
        Process["Session == Process"]
    end

    subgraph Remote["Remote Connection"]
        HTTP["Streaming HTTP"]
        Session["mcp-session-id Header"]
    end

    STDIO --> Process
    HTTP --> Session
```

## OAuth 2 Security Flow for MCP

```mermaid
sequenceDiagram
    participant Client
    participant MCPServer as MCP Server
    participant AuthServer as Authorization Server

    Client->>MCPServer: Access Protected Resource
    MCPServer-->>Client: 401 Unauthorized + WWW-Authenticate

    Client->>MCPServer: Request Resource Metadata
    MCPServer-->>Client: Auth Server URI + Supported Scopes

    Client->>AuthServer: Discover OAuth/OpenID Config
    AuthServer-->>Client: authorize endpoint, token endpoint, issuer

    alt Pre-Registered Client
        Client->>AuthServer: Use Existing Client Registration
    else Dynamic Client Registration
        Client->>AuthServer: Dynamic Client Registration (DCR)
    end

    Client->>AuthServer: /authorize
    AuthServer-->>Client: Access Token + Refresh Token

    Client->>MCPServer: Authenticated Request + Access Token
    MCPServer->>AuthServer: Verify Token
    AuthServer-->>MCPServer: Token Valid
    MCPServer-->>Client: Protected Resource Response
```

## Primitive & Capability Relationship

```mermaid
flowchart LR

    Primitive["Primitive / Capability"]

    Primitive --> ServerCapabilities["Server Capabilities"]
    Primitive --> ClientCapabilities["Client Capabilities"]

    ServerCapabilities --> Tools
    ServerCapabilities --> Resources
    ServerCapabilities --> Prompts

    ClientCapabilities --> Sampling
    ClientCapabilities --> Elicitation
    ClientCapabilities --> Logging
```

## Developer Tooling

```mermaid
flowchart TB

    Developer["Developer"]
        --> Inspector["MCP Inspector"]
        --> Debugging["Debugging"]
        --> Testing["Capability Testing"]
        --> SessionTracing["Session Tracing"]
```

## MCP Security Risks & Mitigations

```mermaid
flowchart TD

    SSRF["SSRF"]
    Hijack["Session Hijacking"]
    Token["Token Passthrough"]
    Local["Local MCP Compromise"]
    Scope["Scope Minimization"]

    SSRF --> SSRFMitigation["HTTPS<br/>IP Whitelist<br/>Validate Redirect URI"]

    Hijack --> HijackMitigation["Do NOT use session for authentication"]

    Token --> TokenMitigation["Verify token issuer"]

    Local --> LocalMitigation["Validate user input<br/>Prevent dangerous commands"]

    Scope --> ScopeMitigation["Limit OAuth scopes"]
```
