#!/bin/python2.7.18

import pandas as pd
import numpy as np
import os

# https://pynative.com/python-rename-file/
old_name: =r"~/src/NetEngTools/ant-sre-twistlock-reports/${}/${}/master_file-bf-vul-C.results.csv"
new_mame: =r"~/src/NetEngTools/ant-sre-twistlock-reports/${}/${}/${DATE}/master_file-bf-vul-C.results.csv"

if os.path.isfile(new_file):
   print("File exist")
else:
   os.rename(old_name, new_name)

df1 = pd.read_csv('master_file-bf-vul-C.results.csv')
df2 = pd.read_csv('bf-vul-scan-C.results.csv')

comparevalues = df1.values == df2.values

print(comparevalues)

rows,cols = np.where(comparevalues==False)

for item in zip(rows,cols):
    df1.iloc[item[0],item[1]] = ' {} --> {} '.format(df1.iloc[item[0], item[1]], df2.iloc[item[0],item[1]])

df1.to_csv('compliance_results.csv', index=False,header=True)


