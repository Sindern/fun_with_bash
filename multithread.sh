#! /bin/bash
# Just a fun exercise in multithreading with pure bash.

# Less efficient. Queues up $threads jobs and waits for them all to complete
#  before continuing on to the next batch.
multithread_test_1() {
  threads=4
  declare -a jobs=()
  for i in {1..20} ; do
    if [[ ${#jobs[@]} -gt ${threads} ]] ; then
      for job in ${jobs[@]} ; do
       wait $job
      done
      jobs=()
    fi
    echo ${i}
    sleep ${i} & jobs=(${jobs[@]} $! )
  done
}

# Rewrite of above so that it keeps ${threads} processes running concurrently
#  without waiting for a batch to finish.  As jobs are started, they're added
#  to an array (bottom line), then the while loop will find any that have
#  finished (pid gone), and will delete them from the array, allowing a new one.
multithread_test_2() {
  threads=4
  declare -a jobs=()
  for i in {1..20} ; do
    while [[ ${#jobs[@]} -ge ${threads} ]] ; do
      for job in ${jobs[@]} ; do
       if [[ $(kill -0 $job &>/dev/null;echo $?) == 1 ]]; then
         jobs=(${jobs[@]/$job/})
       fi
      done
    done
    echo ${i}
    sleep ${i} & jobs=(${jobs[@]} $! )
  done
}

# the easy way, but where's the fun in that?
echo {1..10} | xargs -n1 | xargs -I@ -P 4 sleep @
