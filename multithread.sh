# Just a fun exercise in multithreading with pure bash.

multithread_test_1() {
  threads=4
  declare -a jobs=()
  for i in {1..20} ; do
    if [[ ${#jobs[@]} > ${threads} ]] ; then
      for job in ${jobs[@]} ; do
       wait $job
      done
      jobs=()
    fi
    echo ${i}
    sleep ${i} & jobs=(${jobs[@]} $! )
  done
}

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

# the easy way
echo {1..10} | xargs -n1 | xargs -I@ -P 4 sleep @
