
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

## How to get started

There is a shell script `private-stack-controls.sh`. This command contains arguments to initalize and control the entire stack.
``` bash
chmod +x private-stack-controls.sh
./private-stack-controls.sh
# Usage: private-stack-controls.sh [--init] [--generate-cert] [--start-traefik] [--start-all] [--stop-all] [--stop-traefik] [--delete-volumes]
```

First initalize and generate self-sign cert:
``` bash 
./private-stack-controls.sh --init --generate-cert
```

Start traefik first then the rest of the services:
``` bash
./private-stack-controls.sh --start-traefik
./private-stack-controls.sh --start-all
```

## ⚠️ Use With Caution

While this stack is designed for private, self-hosted environments, **it is your responsibility to implement additional security measures**. By default, these services may be accessible on your network. To protect sensitive data and prevent unauthorized access:

- **Restrict access**: Only allow specific IP addresses or trusted networks to reach these resources (e.g., via firewall rules or reverse proxy configuration).
- **Review default credentials**: Change any default passwords and disable unused accounts.
- **Keep software updated**: Regularly update all services to patch security vulnerabilities.
- **Monitor access logs**: Enable logging and monitor for suspicious activity.
- **Consider encryption**: Use HTTPS/TLS for all web interfaces, and secure internal communication where possible.

**Failure to secure your stack may expose your data and infrastructure to risk. Always follow best practices for network and application security.**


## To do

- [ ] Leverage Docker secrets
- [x] Self-sign cert generation
- [ ] If existing cert is provided, update script to include existing cert files
- [ ] Ensure Timezone is consistant across all services
- [ ] Control on logging
- [ ] Control on which services to keep running

