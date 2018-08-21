#!/bin/bash

# ---
# Simple Ansible Module with Args
# 
# - simple_module_bash:
#     msg: Hello from module
#
# Ansible passes arguments to the module as file
#   ./module_name file_with_argumets

[ -f "$1" ] && source $1

if [ -z "${name_proc}" ] || [ -z "${user_proc}" ] || [ -z "${port_proc}" ] || [ -z "${url}" ] || [ -z "${content_regexp_str}" ] || [ -z "${server_regexp_str}" ]; then
    printf '{"failed": true, "args": "Missing required arguments!"}'
    exit 1
fi

if ! ps aux | grep ${name_proc} | grep -v grep | grep Ss | awk '{print $1}' | grep ${user_proc} > /dev/null; then
    printf '{"failed": true, "msg": "Service is not working under necessary user!"}'
    exit 1
fi

pid_proc=$(ps aux | grep ${name_proc} | grep -v grep | grep Ss | awk '{print $2}')

if ! netstat -ntlp | grep "${port_proc}.*LISTEN.*" > /dev/null; then
    printf '{"failed": true, "msg": "Service is not working under necessary port!"}'
    exit 1
fi

if ! curl ${url} | grep "${content_regexp_str}" > /dev/null; then
    printf '{"failed": true, "msg": "url has not returned necessary content !"}'
    exit 1
fi

if ! curl -IL ${url} | grep "${server_regexp_str}" > /dev/null; then
    printf '{"failed": true, "msg": "url has not returned necessary header !"}'
    exit 1
fi

cat << EOF
{
    "changed": false,
    "name_proc": "${name_proc}",
    "user_proc": "${user_proc}",
    "port_proc": "${port_proc}",
    "url": "${url}",
    "content_regexp_str": "${content_regexp_str}",
    "server_regexp_str": "${server_regexp_str}",
    "state": true,
    "pid_proc": "$pid_proc"
}
EOF

exit 0
