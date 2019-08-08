#! /bin/bash
# Couple methods of formatting and printing off elapsed time.

start_time=$(date +%s)
echo 'Waiting for something to complete.'
while true ; do
   current_time=$(date +%s)
   seconds=$(($current_time - $start_time))
   # Just get elapses seconds with no special formatting. Easy Peasy.
   elapsed_seconds="${seconds}S"
   # Print off human-readable format with fixed format.  Ugly.
   human_readable_fixed="$(($seconds / 86400))d$((($seconds % 86400)  / 3600 ))h$(((($seconds % 86400) % 3600) / 60 ))m$(($seconds % 60))s"
   # Print off human readable format, only adding units as needed:
   human_readable_dynamic=''
   hr_days=$(( $seconds / 86400 ))
   let seconds=seconds-$(($hr_days*86400))
   [[ ${hr_days} -gt 0 ]] && human_readable_dynamic="${hr_days}d"
   hr_hours=$(( $seconds / 3600 ))
   let seconds=seconds-$(($hr_hours*3600))
   [[ ${hr_hours} -gt 0 ]] && human_readable_dynamic="${human_readable_dynamic}${hr_hours}h"
   hr_minutes=$(( $seconds / 60 ))
   let seconds=seconds-$(($hr_minutes * 60))
   [[ $hr_minutes -gt 0 ]] && human_readable_dynamic="${human_readable_dynamic}${hr_minutes}m"
   [[ $seconds -gt 0 ]] && human_readable_dynamic="${human_readable_dynamic}${seconds}s"

   echo -ne "Elapsed Time: ${human_readable_fixed} | ${human_readable_dynamic} |  ${elapsed_seconds}\r"
   sleep 1
done
