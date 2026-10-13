# Security Monitoring and Audit Logging

## Purpose

Day 27 improves SecureCloudGuardian's ability to monitor,
investigate, and audit automated security responses.

## Audit Flow

GuardDuty
    â†“
EventBridge
    â†“
Lambda
    â†“
Security Decision
    â†“
EC2 Quarantine
    â†“
SNS Notification
    â†“
CloudWatch Audit Logs

## Lambda Audit Information

Lambda records:

1. Security event received
2. Event timestamp
3. GuardDuty finding type
4. Finding severity
5. Affected EC2 instance
6. Automatic response decision
7. Existing Security Groups
8. Quarantine Security Group
9. SNS notification
10. Completion status

## Security Benefits

The audit logs make it possible to determine:

- What happened?
- When did it happen?
- Which resource was affected?
- Why was the resource quarantined?
- Which Security Group was applied?
- Was the security team notified?
- Did the Lambda function complete successfully?

## Result

SecureCloudGuardian now provides both automated security
response and an auditable record of the response.
