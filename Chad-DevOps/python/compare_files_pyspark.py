
from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()

df1 = spark.read.csv('master_file-bf-vul-C.results.csv', header = True, inferSchema = True)
df2 = spark.read.csv('bf-vul-scan-C.results.csv', header = True, inferSchema = True)

record_present_in_df1_not_in_df2 = df1.join(other = df2,
                                                    on = df1.columns,
                                                    how = 'anti')


record_present_in_df2_not_in_df1 = df2.join(other = df1,
                                                    on = df1.columns,
                                                    how = 'anti')
