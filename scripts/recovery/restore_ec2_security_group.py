import boto3
import json
import os
import sys
from datetime import datetime, timezone


ec2 = boto3.client("ec2")


def write_recovery_record(
    instance_id,
    original_security_group_id,
    current_security_groups,
    result
):
    base_dir = os.path.abspath(
        os.path.join(
            os.path.dirname(__file__),
            "..",
            ".."
        )
    )

    recovery_dir = os.path.join(
        base_dir,
        "incident_records"
    )

    os.makedirs(
        recovery_dir,
        exist_ok=True
    )

    timestamp = datetime.now(
        timezone.utc
    )

    record = {
        "project": "SecureCloudGuardian",
        "record_type": "RECOVERY",
        "timestamp": timestamp.isoformat(),
        "instance_id": instance_id,
        "original_security_group": original_security_group_id,
        "security_groups_before_recovery": current_security_groups,
        "result": result
    }

    filename = (
        f"recovery-{instance_id}-"
        f"{timestamp.strftime('%Y%m%dT%H%M%SZ')}.json"
    )

    file_path = os.path.join(
        recovery_dir,
        filename
    )

    with open(
        file_path,
        "w",
        encoding="utf-8"
    ) as file:
        json.dump(
            record,
            file,
            indent=4
        )

    print(
        f"Recovery record created: {file_path}"
    )


def restore_security_group(
    instance_id,
    original_security_group_id
):

    print("=" * 60)
    print("SecureCloudGuardian EC2 Recovery")
    print("=" * 60)

    print(
        f"EC2 Instance: {instance_id}"
    )

    print(
        "Original Security Group: "
        f"{original_security_group_id}"
    )

    response = ec2.describe_instances(
        InstanceIds=[instance_id]
    )

    reservations = response.get(
        "Reservations",
        []
    )

    if not reservations:
        raise Exception(
            f"Instance not found: {instance_id}"
        )

    instances = reservations[0].get(
        "Instances",
        []
    )

    if not instances:
        raise Exception(
            f"Instance details not found: {instance_id}"
        )

    instance = instances[0]

    current_security_groups = [
        sg["GroupId"]
        for sg in instance.get(
            "SecurityGroups",
            []
        )
    ]

    print(
        "Current Security Groups: "
        f"{current_security_groups}"
    )

    if (
        original_security_group_id
        in current_security_groups
    ):

        result = (
            "Original Security Group already attached. "
            "No changes required."
        )

        print(result)

        write_recovery_record(
            instance_id,
            original_security_group_id,
            current_security_groups,
            result
        )

        return

    ec2.modify_instance_attribute(
        InstanceId=instance_id,
        Groups=[
            original_security_group_id
        ]
    )

    result = (
        "Original Security Group restored successfully."
    )

    print(
        "SUCCESS: Original Security Group restored."
    )

    print(
        f"Instance: {instance_id}"
    )

    print(
        "Restored Security Group: "
        f"{original_security_group_id}"
    )

    write_recovery_record(
        instance_id,
        original_security_group_id,
        current_security_groups,
        result
    )

    print("=" * 60)


if __name__ == "__main__":

    if len(sys.argv) != 3:

        print("Usage:")

        print(
            "py restore_ec2_security_group.py "
            "<INSTANCE_ID> "
            "<ORIGINAL_SECURITY_GROUP_ID>"
        )

        sys.exit(1)

    instance_id = sys.argv[1]

    original_security_group_id = sys.argv[2]

    restore_security_group(
        instance_id,
        original_security_group_id
    )
