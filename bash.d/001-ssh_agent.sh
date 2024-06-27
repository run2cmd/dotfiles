# SSH AGENT
SSH_ENV="${HOME}/.ssh/environment"
function start_agent {
  echo "Initialising new SSH agent..."
  /usr/bin/ssh-agent | grep export > "${SSH_ENV}"
  echo succeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}"
  for key in ~/.ssh/id*[^.pub] ;do
    /usr/bin/ssh-add $key
  done
}
if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}"
  ps --pid ${SSH_AGENT_PID} > /dev/null || start_agent
else
  start_agent
fi
