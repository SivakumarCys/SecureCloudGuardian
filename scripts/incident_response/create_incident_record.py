import json
import os
import sys
from datetime import datetime, timezone


def create_incident_record(
    instance_id,
    finding_type,
    severity,
    previous_security_groups,
    quarantine_security_group,
    action="EC2 instance quarantined"
):
    base_dir = os.path.abspath(
        os.path.join(
            os.path.dirname(__file__),
            "..",
            ".."
        )
    )

    incident_dir = os.path.join(
        base_dir,
        "incident_records"
    )

    os.makedirs(
        incident_dir,
        exist_ok=True
    )

    timestamp = datetime.now(
        timezone.utc
    )

    timestamp_iso = timestamp.isoformat()

    filename_timestamp = timestamp.strftime(
        "%Y%m%dT%H%M%SZ"
    )

    incident_record = {
        "project": "SecureCloudGuardian",
        "timestamp": timestamp_iso,
        "instance_id": instance_id,
        "finding_type": finding_type,
        "severity": float(severity),
        "previous_security_groups": previous_security_groups,
        "quarantine_security_group": quarantine_security_group,
        "action": action,
        "status": "RECORDED"
    }

    filename = (
        f"incident-{instance_id}-"
        f"{filename_timestamp}.json"
    )

    file_path = os.path.join(
        incident_dir,
        filename
    )

    with open(
        file_path,
        "w",
        encoding="utf-8"
    ) as file:
        json.dump(
            incident_record,
            file,
            indent=4
        )

    print("=" * 60)
    print("SecureCloudGuardian Incident Record")
    print("=" * 60)

    print(
        f"Instance ID: {instance_id}"
    )

    print(
        f"Finding Type: {finding_type}"
    )

    print(
        f"Severity: {severity}"
    )

    print(
        "Previous Security Groups: "
        f"{previous_security_groups}"
    )

    print(
        "Quarantine Security Group: "
        f"{quarantine_security_group}"
    )

    print(
        f"Action: {action}"
    )

    print(
        f"Timestamp: {timestamp_iso}"
    )

    print(
        f"Incident record created: {file_path}"
    )

    print("=" * 60)

    return file_path


if __name__ == "__main__":

    if len(sys.argv) < 6:
        print(
            "Usage:"
        )

        print(
            "py create_incident_record.py "
            "<INSTANCE_ID> "
            "<FINDING_TYPE> "
            "<SEVERITY> "
            "<PREVIOUS_SG> "
            "<QUARANTINE_SG>"
        )

        sys.exit(1)

    instance_id = sys.argv[1]
    finding_type = sys.argv[2]
    severity = sys.argv[3]
    previous_sg = sys.argv[4]
    quarantine_sg = sys.argv[5]

    create_incident_record(
        instance_id=instance_id,
        finding_type=finding_type,
        severity=severity,
        previous_security_groups=[
            previous_sg
        ],
        quarantine_security_group=quarantine_sg
    )
