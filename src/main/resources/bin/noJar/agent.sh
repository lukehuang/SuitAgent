#!/usr/bin/env bash

if [ "x${JAVA_HOME}" == "x" ]; then
    echo "JAVA_HOME is not valid"
    exit 1
fi

JAVA="${JAVA_HOME}/bin/java"

if [ ! -f "$JAVA" ]
then
        echo Invalid Java Home detected at ${JAVA_HOME}
        exit 1
fi

FINDNAME=$0
while [ -h $FINDNAME ] ; do FINDNAME=`ls -ld $FINDNAME | awk '{print $NF}'` ; done
RUNDIR=`echo $FINDNAME | sed -e 's@/[^/]*$@@'`
unset FINDNAME

# cd to top level agent home
if test -d $RUNDIR; then
  cd $RUNDIR/..
else
  cd ..
fi

agentHome=`pwd`

agent_classpath="${agentHome}/lib/falcon-agent-1.0.jar"
agent_classpath="${agent_classpath}:${agentHome}/lib/c3p0-0.9.1.1.jar"
agent_classpath="${agent_classpath}:${agentHome}/lib/commons-codec-1.9.jar"
agent_classpath="${agent_classpath}:${agentHome}/lib/commons-lang-2.6.jar"
agent_classpath="${agent_classpath}:${agentHome}/lib/commons-logging-1.2.jar"
agent_classpath="${agent_classpath}:${agentHome}/lib/httpclient-4.5.1.jar"
agent_classpath="${agent_classpath}:${agentHome}/lib/httpcore-4.4.4.jar"
agent_classpath="${agent_classpath}:${agentHome}/lib/json-20140107.jar"
agent_classpath="${agent_classpath}:${agentHome}/lib/log4j-1.2.12.jar"
agent_classpath="${agent_classpath}:${agentHome}/lib/quartz-2.2.1.jar"
agent_classpath="${agent_classpath}:${agentHome}/lib/slf4j-api-1.7.5.jar"
agent_classpath="${agent_classpath}:${agentHome}/lib/slf4j-log4j12-1.7.5.jar"
agent_classpath="${agent_classpath}:${agentHome}/lib/tools.jar"
agent_class=com.yiji.falcon.agent.Agent

client_cmd="${JAVA} \
	-Dagent.conf.path=${agentHome}/conf/agent.properties \
	-Dagent.quartz.conf.path=${agentHome}/conf/quartz.properties \
	-Dagent.log4j.conf.path=${agentHome}/conf/log4j.properties \
	-cp ${agent_classpath} ${agent_class} $1
"
nohup $client_cmd > ${agentHome}/logs/console.log 2>&1 < /dev/null &