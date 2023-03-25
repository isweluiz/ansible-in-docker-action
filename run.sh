#!/bin/sh
# =====================================================================================================
# Ansible In Docker Action - by @isweluiz
#  This shell script aims to be used to set set the ansible parameters.
#  If you wanna clone the project and add more option, this is the file.
#  In the end of this file you will see how the ansible command will be prepared to run after all \
#  the variables are defined. 
#
#  The 'export' is used to export the variable to shell, then we check with 'if' if the conditional \
#  was defined or not. In case its defined we set it, otherwise it will not be used.
#
# !NOTE!
#   In case you have some doubt about any option used here, or want to add more option to achieve your \
#   goal, check ansible documention. Also to test the action locally you can use the act project. :) 
# =====================================================================================================

# Evaluate Vault key
export KEYFILEVAULTPASS=""
if [ ! -z "$INPUT_KEYFILEVAULTPASS" ]; then
  echo "Using \$INPUT_KEYFILE_VAULT_PASS to decrypt and access vault."
  mkdir -p ~/.ssh
  echo "${INPUT_KEYFILEVAULTPASS}" > ~/.ssh/vault_key
  export KEYFILEVAULTPASS="--vault-password-file ~/.ssh/vault_key"
else
  echo "\$INPUT_KEYFILEVAULTPASS not set. Won't be able to decrypt any encrypted file."
fi

# Evaluate keyfile
export KEYFILE=
if [ ! -z "$INPUT_KEYFILE" ]
then
  echo "\$INPUT_KEYFILE is set. Will use ssh keyfile for host connections."
  if [ ! -z "$KEYFILEVAULTPASS" ]
  then
    echo "Using \$INPUT_KEYFILE_VAULT_PASS to decrypt keyfile."
    ansible-vault decrypt ${INPUT_KEYFILE} ${KEYFILEVAULTPASS}
  fi
  export KEYFILE="--key-file ${INPUT_KEYFILE}"
else
  echo "\$INPUT_KEYFILE not set. You'll most probably only be able to work on localhost."
fi

# Evaluate verbosity
export VERBOSITY=
if [ -z "$INPUT_VERBOSITY" ]
then
  echo "\$INPUT_VERBOSITY not set. Will use standard verbosity."
else
  echo "\$INPUT_VERBOSITY is set. Will use verbosity level $INPUT_VERBOSITY."
  export VERBOSITY="-$INPUT_VERBOSITY"
fi

# Evaluate inventory file
export INVENTORY=
if [ -z "$INPUT_INVENTORY" ]
then
  echo "\$INPUT_INVENTORY not set. Won't use any inventory option at playbook call."
else
  echo "\$INPUT_INVENTORY is set. Will use ${INPUT_INVENTORY} as inventory file."
  export INVENTORY="-i ${INPUT_INVENTORY}"
fi

# Evaluate requirements
export REQUIREMENTS=
if [ -z "$INPUT_REQUIREMENTSFILE" ]
then
  echo "\$INPUT_REQUIREMENTSFILE not set. Won't install any additional external roles."
else
  REQUIREMENTS=$INPUT_REQUIREMENTSFILE
  export ROLES_PATH=
  if [ -z "$INPUT_ROLESPATH" ]
  then
    echo "\$INPUT_ROLESPATH not set. Will install roles in standard path."
  else
    echo "\$INPUT_ROLESPATH is set. Will install roles to ${INPUT_ROLESPATH}."
    export ROLES_PATH=$INPUT_ROLESPATH
  fi
  echo "\$INPUT_REQUIREMENTSFILE is set. Will use ${INPUT_REQUIREMENTSFILE} to install external roles."

  if [ ! -z "$INPUT_GALAXYGITHUBTOKEN" ]
  then
    if [ ! -z "$INPUT_GALAXYGITHUBUSER" ]
    then
      echo "\$INPUT_GALAXYGITHUBTOKEN and \$INPUT_GALAXYGITHUBUSER are set. Will substitue \$GALAXYGITHUBUSER and \$GALAXYGITHUBTOKEN in \$REQUIREMENTSFILE."
      envsubst < ${INPUT_REQUIREMENTSFILE} > $(dirname "${INPUT_REQUIREMENTSFILE}")/substituted_requirements.yml
      export REQUIREMENTS=$(dirname "${INPUT_REQUIREMENTSFILE}")/substituted_requirements.yml
    else
      echo "\$INPUT_GALAXYTOKEN is set. Will login to Ansible Galaxy."
      ansible-galaxy login --github-token ${INPUT_GALAXYGITHUBTOKEN} ${VERBOSITY}
    fi
  else
    echo "\$INPUT_GALAXYGITHUBTOKEN not set. Won't do any authentication for roles installation."
  fi

  ansible-galaxy install --force \
    --roles-path ${ROLES_PATH} \
    -r ${REQUIREMENTS} \
    ${VERBOSITY}
fi

# Evaluate extra vars file
export EXTRAFILE=
if [ -z "$INPUT_EXTRAFILE" ]
then
  echo "\$INPUT_EXTRAFILE not set. Won't inject any extra vars file."
else
  echo "\$INPUT_EXTRAFILE is set. Will inject ${INPUT_EXTRAFILE} as extra vars file."
  export EXTRAFILE="--extra-vars @${INPUT_EXTRAFILE}"
fi

# Evaluate ssh user for target machines connection
export USER=
if [ -z "$INPUT_USER" ]
then
  echo "\$INPUT_USER not set. Won't inject."
else
  echo "\$INPUT_USER is set. Will inject ${INPUT_USER}."
  export USER="--user ${INPUT_USER}"
fi

# Evaluate diff mode - used to report the changes made
export DIFFMODE=
if [ -z "$INPUT_DIFFMODE" -o "$INPUT_DIFFMODE" = 'false' ]
then
  echo "\$INPUT_DIFFMODE not set. Won't inject."
elif [ -n "$INPUT_DIFFMODE" -a "$INPUT_DIFFMODE" = 'true' ]
then
  echo "\$INPUT_DIFFMODE is set. Will inject ${INPUT_DIFFMODE}."
  export DIFFMODE="--diff"
else
  echo "\$INPUT_DIFFMODE not set. Won't inject."
fi

# Evaluate check mode - to simulate an execution
export CHECKMODE=
if [ -z "$INPUT_CHECKMODE" -o "$INPUT_CHECKMODE" = 'false' ]
then
  echo "\$INPUT_DIFFMODE not set. Won't inject."
elif [ -n "$INPUT_CHECKMODE" -a "$INPUT_CHECKMODE" = 'true' ]
then
  echo "\$INPUT_CHECKMODE is set. Will inject ${INPUT_CHECKMODE}."
  export CHECKMODE="--check"
else
  echo "\$INPUT_DIFFMODE not set. Won't inject."
fi

# Evaluate limit selected hosts to an additional pattern
export LIMITGROUP=
if [ -z "$INPUT_LIMITGROUP" ]
then
  echo "\$INPUT_LIMITGROUP not set. Won't inject."
else
  echo "\$INPUT_LIMITGROUP is set. Will inject ${INPUT_LIMITGROUP}."
  export LIMITGROUP="--limit ${INPUT_LIMITGROUP}"
fi

# Evaluate check mode - to simulate an execution
export BECOME=
if [ -z "$INPUT_BECOMEMODE" -o "$INPUT_BECOMEMODE" = 'false' ]
then
  echo "\$INPUT_BECOMEMODE not set. Won't inject."
elif [ -n "$INPUT_BECOMEMODE" -a "$INPUT_BECOMEMODE" = 'true' ]
then
  echo "\$INPUT_BECOMEMODE is set. Will inject ${INPUT_BECOMEMODE}."
  export BECOME="--become"
else
  echo "\$INPUT_BECOMEMODE not set. Won't inject."
fi

# Evaluate tags values
export TAGS=
if [ -z "$INPUT_TAGS" ]
then
  echo "\$INPUT_TAGS not set. Won't inject tags."
else
  echo "\$INPUT_TAGS is set. Will inject ${INPUT_TAGS} tags."
  export TAGS="--tags=${INPUT_TAGS}"
fi

# Evaluate skip tags
export SKIP_TAGS=
if [ -z "$INPUT_SKIPTAGS" ]
then
  echo "\$INPUT_SKIPTAGS not set. No tags to skip"
else
  echo "\$INPUT_SKIPTAGS is set. Will inject ${INPUT_SKIPTAGS}."
  export SKIP_TAGS="--skip-tags=${INPUT_SKIPTAGS}"
fi

# Below the command that we're going to agregate and run after all the parameters filled on the action. 
# =====================================================================================================
echo "Going to execute:\n"
echo -e "ansible-playbook ${INPUT_PLAYBOOK} ${TAGS} ${SKIP_TAGS} ${INVENTORY} ${LIMITGROUP} ${EXTRAFILE} ${INPUT_EXTRAVARS} ${KEYFILE} ${KEYFILEVAULTPASS} ${USER} ${BECOME} ${VERBOSITY} ${DIFFMODE} ${CHECKMODE}"

ansible-playbook ${INPUT_PLAYBOOK} ${TAGS} ${SKIP_TAGS} ${INVENTORY} ${LIMITGROUP} ${EXTRAFILE} ${INPUT_EXTRAVARS} ${KEYFILE} ${KEYFILEVAULTPASS} ${USER} ${BECOME} ${VERBOSITY} ${DIFFMODE} ${CHECKMODE} 

