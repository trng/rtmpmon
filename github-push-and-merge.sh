#!/bin/bash

# Token from github crypted by ccencrypt
tokenfile=~/gh.secret.cpt

# Temporary branch name
tempbranchname=rptemp${RANDOM}

#ddd=` date +"%y%m%d%H%M%S"`

# escape ansi sequences for coloring
YEL='\033[1;33m' # Yellow
CYA='\033[1;36m' # Cyan
NC='\033[0m'     # No Color



for cmdneeded in ccdecrypt gh git ; do
  command -v ${cmdneeded} >/dev/null 2>&1 || { echo >&2 "${cmdneeded} not found.  Aborting..."; exit 1; }
done



gh auth status
if [ $? -ne 0 ]; then
  if [[ ! -f $tokenfile ]] ; then
    echo -e "GitHub token not found in file ${CYA}$tokenfile${NC}"
    exit
  fi
  echo "Opening a token file..."
  GH_TOKEN=`ccdecrypt -c ${tokenfile}`
  if [[ $? -ne 0 ]] ; then
    echo "GitHub token is not decrypted. Aborting..."
    exit 1
  fi
  echo $GH_TOKEN | gh auth login --with-token
  gh auth status
  echo -e "${YEL}\n\n\nGitHub authentication is not preserved between script runs."
  echo -e "If you need multiple pull requests/merges - login from bash with this command:\n"
  echo -e "${CYA}echo ${GH_TOKEN} | gh auth login --with-token${NC}\n"
fi




# check before run git
# git config --global user.email "username@mail.server"
# git config --global user.name "username"
# git pull (userchoice???)





git switch -C ${tempbranchname} origin/main
git add -A
git diff --cached --exit-code > /dev/null
if [[ $? -eq 0 ]] ; then
  echo -e "\nNothing to commit. Exiting...\n"
  git switch main
  git branch --delete ${tempbranchname}
  exit 1
fi

git commit
gh pr create -f
gh pr merge

