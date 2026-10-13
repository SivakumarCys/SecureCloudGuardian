# SecureCloudGuardian Architecture

## Overview

SecureCloudGuardian is an automated AWS cloud security
detection and incident-response system.

## Components

1. Amazon GuardDuty
2. Amazon EventBridge
3. AWS Lambda
4. Amazon EC2
5. Amazon SNS
6. AWS IAM
7. Amazon CloudWatch
8. Security Groups

## Security Workflow

GuardDuty detects suspicious activity and creates a security
finding.

EventBridge receives the GuardDuty event and invokes the
SecureCloudGuardian Lambda function.

Lambda analyzes the finding and determines its severity.

If the severity meets the automatic-response threshold,
Lambda identifies the affected EC2 instance.

Lambda replaces the existing security groups with the
SecureCloudGuardian quarantine security group.

The quarantine security group contains no inbound rules,
reducing the ability of an attacker to access the instance.

Lambda then publishes an SNS security alert.

SNS delivers the alert to the subscribed security email.

CloudWatch records Lambda execution logs for monitoring and
investigation.

## Automated Response

High-severity finding:
EC2 quarantine + SNS notification

Lower-severity finding:
Alert and monitoring without automatic quarantine
