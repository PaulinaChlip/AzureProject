# Databricks notebook source
# Konfiguracja połączenia JDBC z Azure SQL
import os

jdbcHostname = os.environ["SQL_HOST"]
jdbcDatabase = os.environ["SQL_DB"]
username = os.environ["SQL_DATABASE_LOGIN"]
password = os.environ["SQL_DATABASE_PASSWORD"]

jdbcPort = 1433
jdbcUrl = f"jdbc:sqlserver://{jdbcHostname}:{jdbcPort};database={jdbcDatabase}"



# COMMAND ----------

from pyspark.sql import functions as F

events_df = spark.read \
    .format("jdbc") \
    .option("url", jdbcUrl) \
    .option("dbtable", "ParkingEvents") \
    .option("user", username) \
    .option("password", password) \
    .load()

events_df.printSchema()

# COMMAND ----------

aggregated_df = (
    events_df
    .withColumn(
        "event_time",
        F.date_trunc("hour", F.col("event_time"))
    )
    .groupBy("event_time")
    .agg(
        F.sum(F.when(F.col("status") == "free", 1).otherwise(0)).alias("free_spots"),
        F.count("*").alias("all_spots")
    )
    .orderBy("event_time")
)

# COMMAND ----------

display(aggregated_df)

# COMMAND ----------

aggregated_df.write \
    .format("jdbc") \
    .option("url", jdbcUrl) \
    .option("dbtable", "ParkingAggregates") \
    .option("user", username) \
    .option("password", password) \
    .mode("overwrite") \
    .save()

# COMMAND ----------

normalized_df = (
    events_df
    .withColumn(
        "event_time",
        F.date_trunc("hour", F.col("event_time"))
    )
    .withColumn(
        "occupied",
        F.when(F.col("status") == "occupied", 1).otherwise(0)
    )
)

# COMMAND ----------

pivot_df = (
    normalized_df
    .groupBy("event_time")
    .pivot("id")
    .agg(F.max("occupied"))
    .orderBy("event_time")
)

# COMMAND ----------

pivot_df.write \
    .format("jdbc") \
    .option("url", jdbcUrl) \
    .option("dbtable", "ParkingOccupancyMatrix") \
    .option("user", username) \
    .option("password", password) \
    .mode("overwrite") \
    .save()
