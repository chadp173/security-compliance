#!/usr/bin/env python3 

import os 
import subprocess

# Replace the following values with the appropriate values for your environment
appscan_cli_path = "/path/to/appscancli.sh"
appscan_workspace_path = "/path/to/appscan/workspace"
appscan_config_path = "/path/to/appscan/config"

# Run AppScan CLI using subprocess
process = subprocess.Popen([
    appscan_cli_path,
    "scan",
    "-a", appscan_workspace_path,
    "-c", appscan_config_path
], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

# Wait for the process to finish and get the output
stdout, stderr = process.communicate()

# Print the output
print(stdout.decode())
print(stderr.decode())
