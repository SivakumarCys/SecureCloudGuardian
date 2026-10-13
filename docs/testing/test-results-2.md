# SecureCloudGuardian -Test Results-2

## Objective

Improve security monitoring and create an auditable security
response workflow.

## Test Environment

AWS Region:

ap-south-1

Lambda Function:

SecureCloudGuardian-SecurityResponse

GuardDuty:

Enabled

EventBridge:

SecureCloudGuardian-GuardDuty-Rule

Automatic Quarantine:

Enabled

## Security Finding

Finding Type:

UnauthorizedAccess:EC2/SSHBruteForce

Severity:

8

Affected EC2 Instance:

i-0123456789abcdef0

## Test Results

| Test | Result |
|---|---|
| Lambda deployment | PASS |
| Lambda execution | PASS |
| GuardDuty event processing | PASS |
| Severity extraction | PASS |
| EC2 identification | PASS |
| High severity detection | PASS |
| Automatic quarantine | PASS |
| Quarantine Security Group | PASS |
| SNS notification | PASS |
| CloudWatch logging | PASS |
| Audit logging | PASS |

## CloudWatch Audit Evidence

The Lambda function records:

- Event received
- Timestamp
- Finding type
- Severity
- EC2 instance ID
- Security decision
- Current Security Groups
- Quarantine operation
- SNS notification
- Event completion

## Security Response

When the finding severity is greater than or equal to 7 and
automatic quarantine is enabled, the Lambda function replaces
the existing EC2 Security Groups with the dedicated
SecureCloudGuardian-Quarantine-SG.

## Final Result

TEST STATUS: PASS

SecureCloudGuardian successfully processed the high-severity
security finding, quarantined the affected EC2 instance,
generated an SNS notification, and recorded an auditable
security response in CloudWatch.
