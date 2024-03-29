# SSH AGENT
SSH_ENV="${HOME}/.ssh/environment"
function start_agent {
  echo "Initialising new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  for key in ~/.ssh/id*[^.pub] ;do
    /usr/bin/ssh-add $key
  done
}
if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null
  ps -ef | grep -i ssh| grep ${SSH_AGENT_PID} | grep ssh-agent &> /dev/null || { start_agent; }
else
  start_agent;
fi
