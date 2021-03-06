#!/bin/bash
#
# description: Starts and stops Graphouse.

### BEGIN INIT INFO
# Provides:          graphouse
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start the graphouse.
# Description:       Start the graphouse.
### END INIT INFO


. /lib/lsb/init-functions
 
USER="graphouse"
SERVICE="graphouse"
GRAPHOUSE_ROOT=/opt/graphouse
SHELL_LOG=/opt/graphouse/log/graphouse.shell.log
PID_FILE=/var/run/$SERVICE.pid
 
case "$1" in
  start)
    log_begin_msg "Starting $DAEMON..."

    if start-stop-daemon --quiet --stop --signal 0 --pidfile $PID_FILE 1>$SHELL_LOG 2>&1; then
      log_failure_msg "$DAEMON already running"
    else
      /sbin/start-stop-daemon --start --exec $GRAPHOUSE_ROOT/bin/graphouse --make-pidfile --pidfile $PID_FILE --background --no-close --chuid $USER 1>$SHELL_LOG 2>&1
      log_end_msg $?
    fi
    PID=$(<$PID_FILE)
  ;;
 
  stop)
    log_begin_msg "Stopping $DAEMON..."
    start-stop-daemon --quiet --oknodo --retry=TERM/15/KILL/5 --stop --pidfile $PID_FILE 1>$SHELL_LOG 2>&1
    log_end_msg $?
    rm -f $PID_FILE 2>/dev/null
  ;;
 
  restart)
    log_begin_msg "Restarting $DAEMON..."
    $0 stop
    sleep 1
    $0 start
  ;;
 
*)
  log_success_msg "Usage $0 {start|stop|restart}"
  exit 1
 
esac

exit 0
