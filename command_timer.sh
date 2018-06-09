#!
## Show how long a command has been executing while it's running as a stopwatch.

countercmd ()  {
    starttime=$(date +%s);
    echo "[cmd]  ${BOLD}$*${NORMAL}";
    bash -c "$*" & cpid=$!;
    while kill -0 ${cpid}; do
        seconds=$(($(date +%s) - ${starttime}));
        minutes=$((${seconds}/60));
        seconds=$((${seconds}%60));
        echo -ne "RunTime: ${minutes}m${seconds}s     \r";
        sleep 1;
    done
}
