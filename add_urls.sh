#! /bin/bash

# Peter Novotnak::2012, Flexion LLC


site='192.168.121.108/administrator/'
login='index.php'
login_html='./login.html'
cokie='./cookies.txt'
trace='./trace.txt'
token=''

user_param='username'
username='admin'
passwd_param='passwd'
password='222state'
extra_params='option=com_login&task=login&'


curl --cookie-jar $cokie $site > $login_html

token="$(extract_token.py $login_html)"

curl --cookie $cokie --cookie-jar $cokie --trace-ascii $trace --data \
"$user_param=$username&$extra_params$passwd_param=$passwd&$token=1"\
$site$login

