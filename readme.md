
# Private Self-Hosted Stack

## Overview

This repository provides a curated stack of **self-hosted tools** designed for running in **private environments**—whether for personal use, internal company setups, or isolated client instances. The goal is to make it simple to deploy, manage, and scale a reliable collection of open-source services without relying on third-party SaaS providers.

The stack emphasizes:

* **Privacy** → All data stays within your infrastructure.
* **Isolation** → Run independent instances for different clients or projects.
* **Flexibility** → Deploy only the tools you need.
* **Portability** → Easily run on Docker or Kubernetes across various environments.

## Use Cases

* Personal self-hosting (cloud drive, notes, password manager, etc.)
* Internal company tools (monitoring, collaboration, automation)
* Client-specific isolated environments
* Labs, testing, or air-gapped deployments

## Why This Stack?

Instead of relying on scattered one-off setups, this repository provides:

* Standardized configs for repeatable deployments
* Version-controlled infrastructure
* Easy customization for private or client-based needs


### To do
- [ ] Leverage Docker secrets
- [ ] Self-sign cert generation
- [ ] If existing cert is provided, update script to include existing cert files
- [ ] Ensure Timezone is consistant across all services
- [ ] Control on logging
- [ ] Control on which services to keep running

