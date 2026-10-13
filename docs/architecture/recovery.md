# SecureCloudGuardian EC2 Recovery Architecture

## Overview

SecureCloudGuardian automatically detects cloud security threats using
Amazon GuardDuty and responds through EventBridge and AWS Lambda.

For high-severity EC2 threats, the affected EC2 instance can be isolated
using the SecureCloudGuardian Quarantine Security Group.

After security investigation, the recovery mechanism allows the original
EC2 Security Group to be restored safely.

## Security Response Architecture

GuardDuty
    â†“
EventBridge
    â†“
Lambda Security Response
    â†“
Severity Evaluation
    â†“
High Severity Threat
    â†“
EC2 Quarantine Security Group
    â†“
SNS Security Alert
    â†“
CloudWatch Audit Logs

## Recovery Architecture

Quarantined EC2 Instance
    â†“
Security Investigation
    â†“
Administrator Approval
    â†“
restore_ec2_security_group.py
    â†“
Check Current Security Group
    â†“
Restore Original Security Group
    â†“
Verify EC2 Security Configuration

## Recovery Script

Recovery script location:

scripts/recovery/restore_ec2_security_group.py

The recovery script performs the following operations:

1. Connects to Amazon EC2 using boto3.
2. Identifies the target EC2 instance.
3. Retrieves the currently attached Security Groups.
4. Checks whether the original Security Group is already attached.
5. Restores the original Security Group when necessary.
6. Avoids unnecessary modifications when the EC2 instance is already recovered.

## Tested EC2 Instance

Instance ID:

i-0123456789abcdef0

Original Security Group:

sg-0123456789abcdef0

## Safety Mechanism

Recovery is intentionally controlled.

SecureCloudGuardian does not automatically restore a quarantined EC2
instance because the security incident should first be investigated.

The recovery script also checks whether the original Security Group is
already attached before attempting any modification.

## Day 28 Result

SecureCloudGuardian now supports:

Detection â†’ Automated Response â†’ Quarantine â†’ Alerting â†’ Auditing â†’ Recovery
