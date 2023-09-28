# Azure Launchpad Traffic Manager

Depends on

- Application web servers
- Application gateways

## Overview

The Traffic Manager is deployed with priority set to direct traffic to the us-va web servers with us-tx for failover.

## Outputs

| Name | Description |
|------|-------------|
| traffic_manager_id | ID of the traffic manager |
| traffic_manager_fqdn | FQDN of the traffic manager |
