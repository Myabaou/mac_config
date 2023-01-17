#!/bin/bash

echo " =========== EC2 RI 確認 ============="
aws ec2 describe-reserved-instances \
  | jq -r '.ReservedInstances[] | 
  [
	  .InstanceType,
	  .InstanceCount,
	  .Start,
	  .End,
      .State
	  ] | @tsv' | \
         column -t | sort -k5


echo " =========== RDS RI 確認 ============="
aws rds describe-reserved-db-instances \
  | jq -r '.ReservedDBInstances[] |
  [
.DBInstanceClass,
.DBInstanceCount,
.StartTime,
.Duration,
.State
	  ] | @tsv' | \
         column -t | sort -k5


echo " =========== ElastiCache RI 確認 ============="
aws elasticache describe-reserved-cache-nodes \
  | jq -r '.ReservedCacheNodes[] |
  [
.CacheNodeType,
.CacheNodeCount,
.StartTime,
.Duration,
.State
	  ] | @tsv' | \
         column -t | sort -k5



echo " =========== OpenSearch RI 確認 ============="
aws opensearch describe-reserved-instances \
  | jq -r '.ReservedInstances[] |
  [
.InstanceType,
.InstanceCount,
.StartTime,
.Duration,
.State
	  ] | @tsv' | \
         column -t | sort -k5

echo " =========== SavingsPlans確認 ============="
_DATE=$(date +%Y-%m-%d)
_DATE_1Y=$(date -v-1y +%Y-%m-%d)
aws ce get-savings-plans-utilization-details --time-period Start=${_DATE_1Y},End=${_DATE} | jq -r '.SavingsPlansUtilizationDetails[].Attributes |
[
.InstanceFamily,
.HourlyCommitment,
.StartDateTime,
.EndDateTime,
.Status
] | @tsv'