#!/bin/python3

import datetime
import os
import glob
import sys

retention = 90
current_time = datetime.datetime.now()
retention_time = current_time - datetime.timedelta(days=retention)

print('Current time : {0}'.format(current_time))
print('Retention time : {0}'.format(retention_time))

artifacts_dir = '/ant-sre-twistlock-reports'
search_artifacts = os.path.join(artifacts_dir, '*.csv')

l_artifacts = glob.glob(search_artifacts)
# print(l_artifacts)

for t_file in l_artifacts:
    t_mod = os.path.getmtime(t_file)
    t_mod = datetime.datetime.fromtimestamp(t_mod)
    print('{0} : {1}'.format(t_file, t_mod))

    if retention_time > t_mod:
        try:
            os.remove(t_file)
            print('Delete : Yes')
        except Exception:
            print('Delete : No')
            print('Error : {0}'.format(sys.exc_info()))
        else:
            print('Delete : Not Necessary')
