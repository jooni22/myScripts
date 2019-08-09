#!/bin/bash

service tomcat8 stop

mkdir /root/old_tomcat_8_0_14/
tar -zcvf /root/old_tomcat_8_0_14/var_lib_tomcat.tar.gz /var/lib/tomcat8
cp /etc/init.d/tomcat8 /root/old_tomcat_8_0_14

apt remove -y tomcat8
apt purge -y tomcat8

service tomcat8 status

cd /tmp
curl -O http://ftp.man.poznan.pl/apache/tomcat/tomcat-8/v8.5.43/bin/apache-tomcat-8.5.43.tar.gz
tar -xzvf apache-tomcat*
rm apache-tomcat*.tar.gz
mv apache-tomcat* /opt/tomcat

groupadd tomcat
useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

chgrp -R tomcat /opt/tomcat
chown -R tomcat /opt/tomcat
chmod -R 755 /opt/tomcat

##### stare conf
#GC i LIMIT
#export JAVA_OPTS="-Djava.awt.headless=true -XX:+UseG1GC -Xmx6144m -Xms6144m -Djavax.servlet.request.encoding=UTF-8 -Dfile.encoding=UTF-8"
##ficzer z ktorego builda java8
#export JAVA_OPTS="$JAVA_OPTS -XX:+UseStringDeduplication"
##JMX do monitorowania visualvm
#export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
#export JAVA_OPTS="$JAVA_OPTS -Djava.rmi.server.hostname=10.10.10.92"
#export JAVA_OPTS="$JAVA_OPTS -Duser.language=en -Duser.region=GB"

echo "[Unit]
Description=Apache Tomcat Web Server
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-8-oracle
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms6144M -Xmx6144M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=15
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/tomcat.service

echo '<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
<!--
  NOTE:  By default, no user is included in the "manager-gui" role required
  to operate the "/manager/html" web application.  If you wish to use this app,
  you must define such a user - the username and password are arbitrary. It is
  strongly recommended that you do NOT use one of the users in the commented out
  section below since they are intended for use with the examples web
  application.
-->
<!--
  NOTE:  The sample user and role entries below are intended for use with the
  examples web application. They are wrapped in a comment and thus are ignored
  when reading this file. If you wish to configure these users for use with the
  examples web application, do not forget to remove the <!.. ..> that surrounds
  them. You will also need to set the passwords to something appropriate.
-->
<!--
  <role rolename="tomcat"/>
  <role rolename="role1"/>
  <user username="tomcat" password="<must-be-changed>" roles="tomcat"/>
  <user username="both" password="<must-be-changed>" roles="tomcat,role1"/>
  <user username="role1" password="<must-be-changed>" roles="role1"/>
-->

<role rolename="manager-gui"/>
<user username="admin" password="@DMIN!(()" roles="manager-gui"/>


</tomcat-users>' > /opt/tomcat/conf/tomcat-users.xml

echo '<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<Context antiResourceLocking="false" privileged="true" >
<!--  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>' > /opt/tomcat/webapps/manager/META-INF/context.xml

echo '<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<Context antiResourceLocking="false" privileged="true" >
<!--  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" /> -->
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>' > /opt/tomcat/webapps/host-manager/META-INF/context.xml

sed -i 's/size>52428800/size>952428800/g' /opt/tomcat/webapps/manager/WEB-INF/web.xml

systemctl stop tomcat
systemctl start tomcat
systemctl status tomcat
systemctl enable tomcat
