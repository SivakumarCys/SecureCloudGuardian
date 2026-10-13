import json
import boto3
import os

sns = boto3.client("sns")
ec2 = boto3.client("ec2")

TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]


def lambda_handler(event, context):

    detail = event.get("detail", {})

    finding_type = detail.get("type", "Unknown")
    severity = detail.get("severity", {}).get("label", "LOW")
    title = detail.get("title", "Unknown")
    description = detail.get("description", "No description")
    region = detail.get("region", "Unknown")
    account = detail.get("accountId", "Unknown")
    service = detail.get("service", {}).get("serviceName", "Unknown")
    time = detail.get("updatedAt", "Unknown")

    message = f"""
ðŸš¨ SecureCloudGuardian Security Alert

Finding Type : {finding_type}

Severity : {severity}

Title : {title}

Service : {service}

Region : {region}

Account ID : {account}

Time : {time}

Description:
{description}
"""

    print(message)

    # Auto-remediation
    if severity in ["MEDIUM", "HIGH", "CRITICAL"]:

        INSTANCE_ID = os.environ["INSTANCE_ID"]

        try:

            ec2.stop_instances(
                InstanceIds=[INSTANCE_ID]
            )

            ec2.create_tags(
                Resources=[INSTANCE_ID],
                Tags=[
                    {
                        "Key": "Quarantined",
                        "Value": "True"
                    },
                    {
                        "Key": "Status",
                        "Value": "Isolated"
                    },
                    {
                        "Key": "ManagedBy",
                        "Value": "SecureCloudGuardian"
                    }
                ]
            )

            message += f"""

âœ… Auto Remediation Successful

Stopped EC2 Instance:
{INSTANCE_ID}

Applied Tags:
Quarantined=True
Status=Isolated
ManagedBy=SecureCloudGuardian
"""

        except Exception as e:

            message += f"""

âŒ Auto Remediation Failed

{str(e)}
"""

    sns.publish(
        TopicArn=TOPIC_ARN,
        Subject="ðŸš¨SecureCloudGuardian Security Alert",
        Message=message
    )

    return {
        "statusCode": 200,
        "body": json.dumps("Notification sent successfully.")
    }
