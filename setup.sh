#!/bin/bash

VERSION=1.10.0

if [[ -n $1 ]]; then
    VERSION=$1
fi    

mkdir -p /var/lib/drill
chmod -R 777 /var/lib/drill/

cd /var/lib/drill

wget "http://apache.mirrors.hoobly.com/drill/drill-"$VERSION/apache-drill-"$VERSION.tar.gz"""

DRILLDIR="apache-drill-$VERSION"

tar -xzvf $DRILLDIR.tar.gz

mkdir -p /var/lib/drill/$DRILLDIR/jars/3rdparty
cd /var/lib/drill/$DRILLDIR/jars/3rdparty

wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-azure/2.7.1/hadoop-azure-2.7.1.jar
wget http://central.maven.org/maven2/com/microsoft/azure/azure-storage/2.0.0/azure-storage-2.0.0.jar

cd /var/lib/drill/$DRILLDIR/jars

wget http://central.maven.org/maven2/org/apache/hadoop/hadoop-azure-datalake/3.0.0-alpha1/hadoop-azure-datalake-3.0.0-alpha1.jar
wget http://central.maven.org/maven2/com/microsoft/azure/azure-data-lake-store-sdk/2.1.5/azure-data-lake-store-sdk-2.1.5.jar

cp /usr/lib/hdinsight-logging/microsoft-log4j-etwappender-1.0.jar /var/lib/drill/$DRILLDIR/jars/classb

cd /var/lib/drill/$DRILLDIR/conf
rm -f ./logback.xml
wget https://raw.githubusercontent.com/yaron2/hdinsight-drill/master/logback.xml 

cd /var/lib/drill

ZKHOSTS=`grep -R zookeeper /etc/hadoop/conf/yarn-site.xml | grep 2181 | grep -oPm1 "(?<=<value>)[^<]+"`
if [ -z "$ZKHOSTS" ]; then
    ZKHOSTS=`grep -R zk /etc/hadoop/conf/yarn-site.xml | grep 2181 | grep -oPm1 "(?<=<value>)[^<]+"`
fi

sed -i "s@localhost:2181@$ZKHOSTS@" $DRILLDIR/conf/drill-override.conf
ln -s /etc/hadoop/conf/core-site.xml $DRILLDIR/conf/core-site.xml
$DRILLDIR/bin/drillbit.sh restart

cd /var/lib/drill/$DRILLDIR

STATUS=$(./bin/drillbit.sh status)
echo $STATUS
if [[ $STATUS != "drillbit is running." ]]; then
	>&2 echo "Drill installation failed"
	exit 1
fi
