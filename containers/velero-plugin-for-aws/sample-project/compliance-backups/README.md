# Compliance Backups with Velero

This sample project demonstrates automated backup scheduling and compliance reporting for audit requirements using Velero plugin for AWS.

## What You'll Learn

- Automated backup scheduling with Velero
- Backup retention policies and lifecycle management
- Compliance reporting and audit trails
- Backup validation and integrity checking
- Regulatory compliance best practices

## Compliance Requirements

### Common Compliance Standards

1. **SOC 2 Type II**
   - Daily backups with 30-day retention
   - Weekly backups with 1-year retention
   - Monthly backups with 7-year retention

2. **HIPAA**
   - Daily backups with 6-year retention
   - Encrypted backup storage
   - Audit trail maintenance

3. **PCI DSS**
   - Daily backups with 1-year retention
   - Backup integrity validation
   - Secure backup access controls

4. **ISO 27001**
   - Regular backup testing
   - Documented backup procedures
   - Business continuity planning

## Prerequisites

- Kubernetes cluster with Velero installed
- AWS credentials with appropriate permissions
- S3 bucket for backup storage
- Sample application deployed
- Compliance requirements documented

## Backup Strategy Setup

### 1. Create Backup Schedules

#### Daily Backups
```bash
# Create daily backup schedule
velero schedule create daily-backup \
  --schedule="0 2 * * *" \
  --include-namespaces=sample-app \
  --ttl=720h \
  --annotations backup-type=daily,compliance=soc2,retention=30days \
  --labels compliance=soc2,environment=production

# Verify schedule
velero schedule describe daily-backup
```

#### Weekly Backups
```bash
# Create weekly backup schedule
velero schedule create weekly-backup \
  --schedule="0 3 * * 0" \
  --include-namespaces=sample-app \
  --ttl=8760h \
  --annotations backup-type=weekly,compliance=soc2,retention=1year \
  --labels compliance=soc2,environment=production

# Verify schedule
velero schedule describe weekly-backup
```

#### Monthly Backups
```bash
# Create monthly backup schedule (first day of month)
velero schedule create monthly-backup \
  --schedule="0 4 1 * *" \
  --include-namespaces=sample-app \
  --ttl=61320h \
  --annotations backup-type=monthly,compliance=soc2,retention=7years \
  --labels compliance=soc2,environment=production

# Verify schedule
velero schedule describe monthly-backup
```

### 2. Compliance-Specific Schedules

#### HIPAA Compliance
```bash
# HIPAA daily backups with 6-year retention
velero schedule create hipaa-daily \
  --schedule="0 1 * * *" \
  --include-namespaces=sample-app \
  --ttl=52560h \
  --annotations backup-type=daily,compliance=hipaa,retention=6years \
  --labels compliance=hipaa,environment=production

# HIPAA weekly backups
velero schedule create hipaa-weekly \
  --schedule="0 2 * * 0" \
  --include-namespaces=sample-app \
  --ttl=52560h \
  --annotations backup-type=weekly,compliance=hipaa,retention=6years \
  --labels compliance=hipaa,environment=production
```

#### PCI DSS Compliance
```bash
# PCI daily backups with 1-year retention
velero schedule create pci-daily \
  --schedule="0 3 * * *" \
  --include-namespaces=sample-app \
  --ttl=8760h \
  --annotations backup-type=daily,compliance=pci,retention=1year \
  --labels compliance=pci,environment=production

# PCI weekly backups
velero schedule create pci-weekly \
  --schedule="0 4 * * 0" \
  --include-namespaces=sample-app \
  --ttl=8760h \
  --annotations backup-type=weekly,compliance=pci,retention=1year \
  --labels compliance=pci,environment=production
```

## Backup Validation and Testing

### 1. Automated Backup Testing

#### Create Test Restore Script
```bash
#!/bin/bash
# test-backup.sh

BACKUP_NAME=$1
TEST_NAMESPACE="test-restore-$(date +%Y%m%d-%H%M%S)"

if [ -z "$BACKUP_NAME" ]; then
    echo "Usage: $0 <backup-name>"
    exit 1
fi

echo "Testing backup: $BACKUP_NAME"

# Create test restore
velero restore create test-restore-$TEST_NAMESPACE \
  --from-backup=$BACKUP_NAME \
  --namespace-mappings sample-app:$TEST_NAMESPACE \
  --wait

# Verify restore
kubectl get all -n $TEST_NAMESPACE

# Run basic functionality test
kubectl run test-pod --image=busybox --rm -it --restart=Never -- \
  wget -qO- http://sample-app-service.$TEST_NAMESPACE.svc.cluster.local

# Cleanup test restore
kubectl delete namespace $TEST_NAMESPACE

echo "Backup test completed for: $BACKUP_NAME"
```

#### Test Recent Backups
```bash
# Test the most recent daily backup
LATEST_DAILY=$(velero backup get --output json | jq -r '.items[] | select(.Metadata.Annotations.backup-type == "daily") | .Metadata.Name' | head -1)
./test-backup.sh $LATEST_DAILY

# Test the most recent weekly backup
LATEST_WEEKLY=$(velero backup get --output json | jq -r '.items[] | select(.Metadata.Annotations.backup-type == "weekly") | .Metadata.Name' | head -1)
./test-backup.sh $LATEST_WEEKLY
```

### 2. Backup Integrity Checks

#### Verify Backup Contents
```bash
# Check backup details
velero backup describe <backup-name>

# Verify backup logs
velero backup logs <backup-name>

# Check backup storage location
velero get backup-storage-location
```

#### Validate Backup Data
```bash
# List all backups with compliance labels
velero backup get --labels compliance=soc2

# Check backup status
velero backup get --output wide

# Verify backup completion
velero backup get --output json | jq '.items[] | select(.Status.Phase != "Completed") | {name: .Metadata.Name, status: .Status.Phase}'
```

## Compliance Reporting

### 1. Backup Status Report

#### Generate Compliance Report
```bash
#!/bin/bash
# compliance-report.sh

REPORT_DATE=$(date +%Y-%m-%d)
REPORT_FILE="compliance-report-$REPORT_DATE.md"

echo "# Compliance Backup Report - $REPORT_DATE" > $REPORT_FILE
echo "" >> $REPORT_FILE

# SOC 2 Compliance
echo "## SOC 2 Compliance Status" >> $REPORT_FILE
echo "" >> $REPORT_FILE

# Daily backups
DAILY_BACKUPS=$(velero backup get --labels compliance=soc2 --output json | jq '.items[] | select(.Metadata.Annotations.backup-type == "daily") | .Metadata.Name' | wc -l)
echo "- Daily Backups: $DAILY_BACKUPS (Required: 30 days)" >> $REPORT_FILE

# Weekly backups
WEEKLY_BACKUPS=$(velero backup get --labels compliance=soc2 --output json | jq '.items[] | select(.Metadata.Annotations.backup-type == "weekly") | .Metadata.Name' | wc -l)
echo "- Weekly Backups: $WEEKLY_BACKUPS (Required: 52 weeks)" >> $REPORT_FILE

# Monthly backups
MONTHLY_BACKUPS=$(velero backup get --labels compliance=soc2 --output json | jq '.items[] | select(.Metadata.Annotations.backup-type == "monthly") | .Metadata.Name' | wc -l)
echo "- Monthly Backups: $MONTHLY_BACKUPS (Required: 84 months)" >> $REPORT_FILE

echo "" >> $REPORT_FILE

# HIPAA Compliance
echo "## HIPAA Compliance Status" >> $REPORT_FILE
echo "" >> $REPORT_FILE

HIPAA_BACKUPS=$(velero backup get --labels compliance=hipaa --output json | jq '.items[] | .Metadata.Name' | wc -l)
echo "- HIPAA Backups: $HIPAA_BACKUPS (Required: 6 years)" >> $REPORT_FILE

echo "" >> $REPORT_FILE

# PCI DSS Compliance
echo "## PCI DSS Compliance Status" >> $REPORT_FILE
echo "" >> $REPORT_FILE

PCI_BACKUPS=$(velero backup get --labels compliance=pci --output json | jq '.items[] | .Metadata.Name' | wc -l)
echo "- PCI DSS Backups: $PCI_BACKUPS (Required: 1 year)" >> $REPORT_FILE

echo "" >> $REPORT_FILE

# Backup Health
echo "## Backup Health Status" >> $REPORT_FILE
echo "" >> $REPORT_FILE

FAILED_BACKUPS=$(velero backup get --output json | jq '.items[] | select(.Status.Phase == "Failed") | .Metadata.Name' | wc -l)
echo "- Failed Backups: $FAILED_BACKUPS" >> $REPORT_FILE

COMPLETED_BACKUPS=$(velero backup get --output json | jq '.items[] | select(.Status.Phase == "Completed") | .Metadata.Name' | wc -l)
echo "- Completed Backups: $COMPLETED_BACKUPS" >> $REPORT_FILE

echo "" >> $REPORT_FILE
echo "Report generated on: $(date)" >> $REPORT_FILE

echo "Compliance report generated: $REPORT_FILE"
```

#### Run Compliance Report
```bash
# Generate daily compliance report
./compliance-report.sh

# View the report
cat compliance-report-$(date +%Y-%m-%d).md
```

### 2. Audit Trail Maintenance

#### Backup Audit Log
```bash
# Get backup audit information
velero backup get --output json | jq '.items[] | {
  name: .Metadata.Name,
  created: .Metadata.CreationTimestamp,
  type: .Metadata.Annotations.backup-type,
  compliance: .Metadata.Annotations.compliance,
  retention: .Metadata.Annotations.retention,
  status: .Status.Phase,
  ttl: .Spec.TTL
}'

# Export audit data to CSV
velero backup get --output json | jq -r '.items[] | [.Metadata.Name, .Metadata.CreationTimestamp, .Metadata.Annotations.backup-type, .Metadata.Annotations.compliance, .Metadata.Annotations.retention, .Status.Phase, .Spec.TTL] | @csv' > backup-audit.csv
```

## Retention Policy Management

### 1. Automatic Cleanup

#### Set Retention Policies
```bash
# Update existing schedules with proper TTL
velero schedule patch daily-backup --ttl=720h
velero schedule patch weekly-backup --ttl=8760h
velero schedule patch monthly-backup --ttl=61320h
```

#### Manual Cleanup
```bash
# List backups older than retention period
OLD_BACKUPS=$(velero backup get --output json | jq -r '.items[] | select(.Metadata.CreationTimestamp < "'$(date -d '30 days ago' -u +%Y-%m-%dT%H:%M:%SZ)'") | .Metadata.Name')

# Delete old backups
for backup in $OLD_BACKUPS; do
    echo "Deleting old backup: $backup"
    velero backup delete $backup --confirm
done
```

### 2. Compliance Retention Enforcement

#### SOC 2 Retention Enforcement
```bash
# Delete SOC 2 daily backups older than 30 days
SOC2_OLD_DAILY=$(velero backup get --labels compliance=soc2 --output json | jq -r '.items[] | select(.Metadata.Annotations.backup-type == "daily" and .Metadata.CreationTimestamp < "'$(date -d '30 days ago' -u +%Y-%m-%dT%H:%M:%SZ)'") | .Metadata.Name')

for backup in $SOC2_OLD_DAILY; do
    echo "Deleting old SOC2 daily backup: $backup"
    velero backup delete $backup --confirm
done
```

## Monitoring and Alerting

### 1. Backup Health Monitoring

#### Check Backup Status
```bash
# Monitor backup schedules
velero schedule get

# Check recent backup status
velero backup get --output wide

# Monitor backup storage usage
velero get backup-storage-location
```

#### Set Up Alerts
```bash
#!/bin/bash
# backup-monitor.sh

# Check for failed backups
FAILED_BACKUPS=$(velero backup get --output json | jq '.items[] | select(.Status.Phase == "Failed") | .Metadata.Name')

if [ -n "$FAILED_BACKUPS" ]; then
    echo "ALERT: Failed backups detected:"
    echo "$FAILED_BACKUPS"
    # Send alert (email, Slack, etc.)
fi

# Check for missing daily backups
TODAY=$(date +%Y-%m-%d)
DAILY_BACKUP_TODAY=$(velero backup get --labels compliance=soc2 --output json | jq -r '.items[] | select(.Metadata.Annotations.backup-type == "daily" and (.Metadata.CreationTimestamp | startswith("'$TODAY'")) | .Metadata.Name')

if [ -z "$DAILY_BACKUP_TODAY" ]; then
    echo "ALERT: No daily backup created today"
    # Send alert
fi
```

### 2. Compliance Monitoring

#### Compliance Status Check
```bash
#!/bin/bash
# compliance-check.sh

COMPLIANCE_STATUS="PASS"

# Check SOC 2 compliance
SOC2_DAILY_COUNT=$(velero backup get --labels compliance=soc2 --output json | jq '.items[] | select(.Metadata.Annotations.backup-type == "daily") | .Metadata.Name' | wc -l)

if [ "$SOC2_DAILY_COUNT" -lt 30 ]; then
    echo "FAIL: SOC 2 daily backup requirement not met (Current: $SOC2_DAILY_COUNT, Required: 30)"
    COMPLIANCE_STATUS="FAIL"
fi

# Check HIPAA compliance
HIPAA_COUNT=$(velero backup get --labels compliance=hipaa --output json | jq '.items[] | .Metadata.Name' | wc -l)

if [ "$HIPAA_COUNT" -lt 2190 ]; then  # 6 years * 365 days
    echo "FAIL: HIPAA backup requirement not met (Current: $HIPAA_COUNT, Required: 2190)"
    COMPLIANCE_STATUS="FAIL"
fi

echo "Compliance Status: $COMPLIANCE_STATUS"
```

## Best Practices

### 1. Compliance Strategy
- Document all compliance requirements
- Implement automated backup schedules
- Regular backup testing and validation
- Maintain audit trails

### 2. Retention Management
- Set appropriate TTL values
- Regular cleanup of expired backups
- Monitor storage costs
- Validate retention policies

### 3. Testing and Validation
- Test backup restores regularly
- Validate backup integrity
- Document test procedures
- Maintain test results

### 4. Documentation
- Document backup procedures
- Maintain compliance reports
- Record audit trails
- Update procedures regularly

## Troubleshooting

### Common Compliance Issues

1. **Backup Failures**
   - Check Velero pod status
   - Verify AWS credentials
   - Check S3 bucket permissions
   - Review backup logs

2. **Retention Issues**
   - Verify TTL settings
   - Check cleanup policies
   - Monitor storage usage
   - Validate retention requirements

3. **Compliance Violations**
   - Review backup schedules
   - Check backup counts
   - Validate retention periods
   - Update compliance reports

### Debug Commands

```bash
# Check backup schedules
velero schedule get

# Verify backup status
velero backup get --output wide

# Check backup storage
velero get backup-storage-location

# View backup details
velero backup describe <backup-name>

# Check Velero logs
kubectl logs -n velero -l app=velero
```

## Next Steps

After completing compliance backups:

1. **Set up automated monitoring**
2. **Implement alerting systems**
3. **Create compliance dashboards**
4. **Regular compliance audits**
5. **Update procedures based on findings**

## Additional Resources

- [Velero Schedule Reference](https://velero.io/docs/v1.11/schedule-reference/)
- [Backup Storage Locations](https://velero.io/docs/v1.11/storage-locations/)
- [Compliance Best Practices](https://velero.io/docs/v1.11/best-practices/)
- [SOC 2 Compliance Guide](https://www.aicpa.org/soc2)
- [HIPAA Compliance Guide](https://www.hhs.gov/hipaa/)
