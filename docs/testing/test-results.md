# SecureCloudGuardian â€”  Test Results

## Objective

Verify the complete automated AWS security detection and
response workflow.

## Architecture

GuardDuty
    â†“
EventBridge
    â†“
Lambda
    â†“
EC2 Quarantine
    â†“
SNS
    â†“
Email

## Test Finding

Finding Type:
UnauthorizedAccess:EC2/SSHBruteForce

Severity:
8.0

EC2 Instance:
i-0123456789abcdef0

## Results

GuardDuty Detection: PASS

EventBridge Trigger: PASS

Lambda Execution: PASS

Severity Detection: PASS

EC2 Instance Identification: PASS

Automatic Quarantine: PASS

Quarantine Security Group Applied: PASS

SNS Notification: PASS

Email Notification: PASS

## Conclusion

SecureCloudGuardian successfully detected a high-severity
GuardDuty security finding and automatically quarantined the
affected EC2 instance using the dedicated quarantine security
group. The system also generated an SNS security notification.
