#!/bin/python3

"""
IBM CIO Network Engineering:
Compare Image Artifacts 
Chad Perry <Chad.Perry1@us.ibm.com>
This tool will:
	Rename two files
	Create a merged CSV 
  	CSV will Contain Open Issues
  	Date stamp the results
"""

import os
import pandas as pd
import numpy as np
from datetime import datetime

# adding date-time to the file name
current_timestamp = datetime.today().strftime('%d-%b-%Y')
old_name = r"master_file-vul-M.results.csv"
new_name = r"master_file-vul-M.results" + current_timestamp + ".csv"
os.rename(old_name, new_name)

former_name = r"master.csv"
makeshift_name = r"master" + current_timestamp + ".csv"
os.rename(former_name, makeshift_name)

df1=pd.read_csv("master_file-vul-M.results" + current_timestamp + ".csv")
df2=pd.read_csv("master" + current_timestamp + ".csv")

df_final=pd.concat([df1, df2].drop_duplicates(subset=['scanTime', 'scanID', 'scanVersion', 'scanConsole',
                                                              'scanIntelligenceTime', 'image',	'registry', 'repository',
                                                              'tag', 'digest', 'twistlockImageID', 'osDistro',
                                                              'osDistroRelease', 'osDistroVersion', 'architecture'
                                                              'size', 'hostname', 'issueType',	'severity',
                                                              'severityCHML', 'cvss', 'riskFactors', 'cve',
                                                              'link', 'hasFix',	'status', 'packageType',
                                                              'packageName', 'packageVersion', 'packageLicense',
                                                              'packageBinaryPkgs', 'packagePath', 'description',
                                                              'title', 'cause', 'complianceID']).reset_index(drop=True)
print(df_final)

df_final2=df_final.drop_duplicates(subset=['image', 'osDistro', 'osDistroRelease',
                                    'osDistroVersion', 'issueType', 'severity','severityCHML',
                                    'cve,description'], keep='last', implace='False').reset_index(drop=True)

df_final2=df.final2_to_csv('final.csv', index=False)

old_final = r"final.csv"
derivative_final = r"final" + current_timestamp + ".csv"
os.rename(old_final, derivative_final) 
                                  
