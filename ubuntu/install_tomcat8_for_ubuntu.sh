sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
curl -O http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.20/bin/apache-tomcat-8.5.20.tar.gz
sudo mv apache-tomcat-8.5.20.tar.gz /tmp
sudo mkdir /opt/tomcat
sudo tar xzvf /tmp/apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r /opt/tomcat/conf
sudo chmod g+x /opt/tomcat/conf
sudo chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl status tomcat
sudo systemctl enable tomcat
