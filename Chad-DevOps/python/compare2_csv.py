#!/bin/python3.8.4

import pandas as pd
import numpy as np
# CSV1="master_file-bf-vul-C.results.csv"
# CSV2="bf-vul-scan-C.results.csv"

df1 = pd.read_csv('CSV1.csv')
df2 = pd.read_csv('CSV2.csv')

# Method1 see if one dataframe is equal to another, return all values true or false
array1 = np.array(df1)
array2 = np.array(df2)

df_CSV_1 = pd.DataFrame(array1, columns=['image', 'severity', 'riskFactors', 'cve', 'packageType', 'description'])
df_CSV_2 = pd.DataFrame(array1, columns=['image', 'severity', 'riskFactors', 'cve', 'packageType', 'description'])

#df1.reset_index(drop=True, inplace=True)
#df2.reset_index(drop=True, inplace=True)
#df = pd.concat([df1, df2], axis=1)

df_CSV_1.index += 1
df_CSV_2.index += 1


print(df_CSV_1.eq(df_CSV_2).to_string(index=True))
print("\n")

# method2 - find the values that are different

# a = df1[df1.eq(df2).all(axis=1) == False]
# a.index +=1
# print(a.to_string(index=False))
# print("\n")

# method3 - create a new column to check for differences

