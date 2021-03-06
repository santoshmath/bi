#!/bin/sh


/usr/bin/env | grep ^BUILD_ > BUILD_ENV.txt

set -e

PREFIX=mifos_bi-1.3.1

mkdir -p ${PREFIX}/ETL
cp -r BUILD_ENV.txt README INSTALL LICENSE reports DashboardsTemplate ${PREFIX}/
rm -rf ${PREFIX}/reports/MiscdataAccess
rm -rf ${PREFIX}/reports/MiscReports
cp -r Dashboards ${PREFIX}/reports
cp -r DashboardsMenu ${PREFIX}/reports
cp -r ETL/MifosDataWarehouseETL ${PREFIX}/ETL
/usr/bin/zip -r ${PREFIX}.zip ${PREFIX}
