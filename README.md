# cloud-bursting
Auto-Scaling VM Script
This script automatically starts or deletes a Google Cloud VM (scaled-vm) based on CPU usage.

How It Works:
CPU > 75% → Starts a VM if not running.
CPU < 50% → Deletes the VM if running.
50% ≤ CPU ≤ 75% → No action taken.

Usage
Ensure you have gcloud CLI installed & authenticated.

Run the script:   ./monitor_cpu.sh

Monitor logs to see VM creation or deletion.

Requirements:
-Google Cloud SDK (gcloud)
-Bash Shell

Notes:
The VM uses Ubuntu 22.04 LTS in us-west3-a.
Modify THRESHOLD_UP & THRESHOLD_DOWN as needed.

