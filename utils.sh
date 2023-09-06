
# Function to check and clone a Git repositor if it doesn't exist
check_and_clone_repo() {
    local repo_url="$1"
    local destination_dir="$2"

    if [ ! -d "$destination_dir" ]; then
        log_work "GIT" "Cloning repository: $repo_url to $destination_dir${NORMAL}"
        git clone -q "$repo_url" "$destination_dir" 
    else
        log_done "GIT" "Repository already exists at: $destination_dir${NORMAL}"
    fi
}


update_file_if_different(){
  SRC=$1
  DST=$2
  CHANGED=0
  if [ -f $DST ]; then
      md5_match $SRC $DST
      MATCHES=$?
      if [ "$MATCHES" -eq 1 ];then
          log_done "CONF" "$SRC is already configured.${NORMAL}"
      else
          echo "${YELLOW}$DST file mismatch${NORMAL}"
          cp $SRC $DST
          CHANGED=1
      fi
  else
      log_work "CONF" "Configuring $DST${NORMAL}"
      mkdir -p $(dirname $DST)
      cp $SRC $DST
      CHANGED=1
  fi
}

md5_match(){
  md5_1="$(md5sum "$1" | awk '{ print $1 }')"
  md5_2="$(md5sum "$2"| awk '{ print $1 }')"
  # echo "$md5_1"
  # echo "$md5_2"
  if [ $md5_1  = $md5_2 ]; then
    return 1
  else 
    return 0
  fi
}

function log_done() {
  echo -e "${GREEN}$1:\t$2${NORMAL}"
}

function log_work() {
  echo -e "${BLUE}$1:\t$2${NORMAL}"
}

function log_prompt() {
  echo -e "${YELLOW}$1:\t$2${NORMAL}"
}
