MAVEN_HOME=/usr/local/maven
JAVA_HOME=/usr/java/jdk

PATH=$MAVEN_HOME/bin:$JAVA_HOME/bin:$PATH

export MAVEN_HOME JAVA_HOME PATH

cd `echo ${0%/*}`
abspath=`pwd`

while read LINE
do
    project=$LINE
    cd $project
    git pull
    git checkout app-ad-1.3.1-MS20160201
    git pull
    mvn clean compile package -Dmaven.test.skip

    pids1=`ps -ef | grep apache-tomcat-app-test | awk  '{print $2}'`
    kill -9 $pids1

    pids2=`ps -ef | grep apache-tomcat-app-test | awk '{print $2}'`
    kill -9 $pids2

    rm -rf /nh/appdir/java/app-test/ROOT/*
    rm -rf /nh/appdir/java/app-test/ROOT/*
    

    cp -rf */target/app-ad-front/* /nh/appdir/java/app-test/ROOT/
    cp -rf */target/app-ad-back/* /nh/appdir/java/app-test/ROOT/
    
    /usr/local/apache-tomcat-app-test/bin/startup.sh &
    /usr/local/apache-tomcat-app-test/bin/startup.sh &

done < $abspath/projects.txt
