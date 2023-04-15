#!/bin/python3

from datetime import datetime, timedelta
from zipfile import ZipFile
import os, time, shutil

# datetime objects
last_month = datetime.now() - timedelta(days=90)

# datetime objects to timestamp
timestamp = datetime.timestamp(last_month)

# list files in directory
file = [f for f in os.listdir() if os.path.isfile(f)]

# iterate over file and get their creation time

for file in file:
    created = os.stat(file).st_ctime
    print(created)

# add old files to ZIP archive
old = []
for file in file:
    created = os.stat(file).st_ctime
    if created < timestamp:
        old.append(file)

print(old)

# Loop to generate statement
old = [f for f in file if os.stat(f).st_ctime < timestamp]
with ZipFile('old.zip', 'w') as zipfile:
    for file in file:
        zipfile.write(file)


# Accept directory as command-line argument
# Accept ZIP file name as a command-line argument
# Implement the save code with the `time` module and timestamp arithmetic
# Delete the old files from the directory after saving to archive
