#! /bin/bash
## Parse & update config ini with bash.  Why would you do this?

# Colors make things prettier, don't you think?
BLACK=$(tput setaf 0) RED=$(tput setaf 1) GREEN=$(tput setaf 2) YELLOW=$(tput setaf 3) LIME_YELLOW=$(tput setaf 190) POWDER_BLUE=$(tput setaf 153) BLUE=$(tput setaf 4) MAGENTA=$(tput setaf 5) CYAN=$(tput setaf 6) WHITE=$(tput setaf 7) BRIGHT=$(tput bold) BOLD=$(tput bold) NORMAL=$(tput sgr0) BLINK=$(tput blink) REVERSE=$(tput smso) UNDERLINE=$(tput smul)

config_parser_help="
${BOLD}Usage Info:${NORMAL}
  get_config \$config_file \$section \$key
  set_config \$config_file \$section \$key \$value${NORMAL}
"

# Read a key's value from a specified section.
get_config() {
  if [[ -z ${3} ]] ; then
    echo -e "${BOLD}  =(xᴥx)=  ${RED}Not enough arguments.${NORMAL}${config_parser_help}"
  elif [[ -n ${4} ]] ; then
    echo -e "${BOLD}  =(xᴥx)=  ${RED}Too many arguments.${NORMAL}${config_parser_help}"
  else
    awk '/\['"${2}"'\]/{t=1}; t==1{print; if (/^\[/){c++}}; c==2{exit}' "${1}" |
      grep "^${3}" | cut -d= -f2-
  fi
}

# Update a key's value in a specified section.
set_config(){
  if [[ -z ${4} ]] ; then
    echo -e "${BOLD}  =(xᴥx)=  ${RED}Not enough arguments.${NORMAL}${config_parser_help}"
  elif [[ -n ${5} ]] ; then
    echo -e "${BOLD}  =(xᴥx)=  ${RED}Too many arguments.${NORMAL}${config_parser_help}"
  else
  new_conf=$(awk '/^\['"${2}"'\]/{t++} ; t==0{print}' "${1}"
  awk '/\['"${2}"'\]/{t=1}; t==1{print; if (/^\[/){c++}}; c==2{exit}' "${1}" | sed 's|'"${3}"'=.*|'"${3}"'='"${4}"'|'
  awk '/^\['"${2}"'\]/{t++}; t>=1{if(t>2){print}; if(/^\[/){t++}}' "${1}")
  mv "${1}"{,.bak}
  echo "${new_conf}" > "${1}"
  fi
}
