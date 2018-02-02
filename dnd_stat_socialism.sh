#!/bin/bash

# Simulate socialized stats.
# Each player rolls for their stats, then all stats are pooled.
# Stats are assigned from the pool in order of highest to lowest
#  in order of Player 1-5, then Player 5-1, repeating.
#
# Greatly evens out the stats of the party to avoid over/underpowered
#  members of the party.  Compare totals before/after mixing.

dice_roll(){
  num_rolls="${1%d*}"
  num_sides="${1#*d}"
  unset rolls roll_t roll
  for r in $(seq 1 $num_rolls); do
    roll=$((${RANDOM}%${num_sides}+1))
    rolls+="${roll} "
    roll_t=$((${roll_t} + ${roll}))
  done
  if [[ $2 == "v" ]] ; then
    echo "${rolls} : ${roll_t}"
  else
    echo "${roll_t}"
  fi
}

# 5 6 = 5 players, 6 stat rolls each.
num_players=$1
num_stats=$2
roll_code=$3

echo -e "Rolling ${roll_code} ${num_stats} times for ${num_players} players.\n"

echo -e "Simulating individual player rolls: \n"
for p in $(seq 1 ${num_players}) ; do
  unset stat_rolls
  for s in $(seq 1 ${num_stats}) ; do
    stat_rolls+="$(dice_roll ${roll_code}) "
  done
  roll_total=$(echo ${stat_rolls}| tr ' ' '\n' | awk '{t+=$1};END{print t}')
  echo "Player $p rolled: " ${stat_rolls} " :: Total: ${roll_total}"
  all_stats+="${stat_rolls} "
done

all_stats=$(echo ${all_stats}| xargs -n 1 | sort -gr | tr '\n' ' ')
echo -e "\nAll Stat Rolls: ${all_stats}"

socialism() {
  n_players=$1 ; shift
  echo -e "Distributing among $n_players players.\n"
  for i in $(seq 1 ${n_players}) ; do
     eval unset player${i}
  done
  while [[ -n $1 ]]; do
    for i in $(seq 1 ${n_players}) ; do
      eval player${i}+="${1}\ " ; shift
  done
    for i in $(seq ${n_players} 1) ; do
      eval player${i}+="${1}\ " ; shift
    done
  done
  for i in $(seq 1 ${n_players}); do
    pn=player$i
    pntotal=$(echo ${!pn} | tr ' ' '\n' | awk '{t+=$1};END{print t}')
    echo "${pn} : ${!pn} :: Total: ${pntotal}"
  done
}

echo -e "\nSocialized stats: \n"
socialism ${num_players} ${all_stats}
