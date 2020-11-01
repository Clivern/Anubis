cd /tmp

curl -LO https://mirror.serverion.com/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.zip
unzip apache-maven-3.6.3-bin.zip
rm apache-maven-3.6.3-bin.zip
mv -f apache-maven-3.6.3 ~/mvn-3.6.3
