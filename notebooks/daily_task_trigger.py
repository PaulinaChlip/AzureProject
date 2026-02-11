# Upgrade Databricks SDK to the latest version and restart Python to see updated packages
%pip install --upgrade databricks-sdk==0.70.0
%restart_python

from databricks.sdk.service.jobs import JobSettings as Job


New_Job_Feb_11_2026_02_18_PM = Job.from_dict(
    {
        "name": "AutomatedAggregation",
        "schedule": {
            "quartz_cron_expression": "0 0 23 * * ?",
            "timezone_id": "Europe/Warsaw",
            "pause_status": "PAUSED",
        },
        "tasks": [
            {
                "task_key": "Aggregating_parking_data",
                "notebook_task": {
                    "notebook_path": "/Workspace/Users/paulinachlip@student.agh.edu.pl/lambdabatchlayer",
                    "source": "WORKSPACE",
                },
                "existing_cluster_id": "0207-155121-wcra7ks0",
                "max_retries": 1,
                "min_retry_interval_millis": 900000,
            },
        ],
        "queue": {
            "enabled": True,
        },
    }
)

from databricks.sdk import WorkspaceClient

w = WorkspaceClient()
w.jobs.reset(new_settings=New_Job_Feb_11_2026_02_18_PM, job_id=496155559796299)
# or create a new job using: w.jobs.create(**New_Job_Feb_11_2026_02_18_PM.as_shallow_dict())

