#! /bin/bash

# Peter Novotnak::2012, Flexion INC

set -x # Debugging

site='192.168.121.108'
admin='/administrator/'
admin_gateway='index\.php\?'
url_gateway='index2.php?'
store_gateway=$admin_gateway
login_html='./login.html'
cookie='./cookies.txt'

trace='./trace.txt'
login_html='./login_page.html'
result='./result.html'
ww_dat='/var/www/scrape/'

token=''
user_param='username'
username='admin'
passwd_param='passwd'
passwd='222state'
extra_post_params='option=com_login&task=login&'
extra_get_params=''

check_url=''


# Get the login page
#curl --cookie-jar $cookie $site$admin > $login_html
# Extract the CSRF token
#token="$(./extract_token.py $login_html)"
# Establish a session
#curl --cookie $cookie --cookie-jar $cookie --trace-ascii $trace --data \
#    "$user_param=$username&$extra_post_params$passwd_param=$passwd&$token=1"\
#    $site$admin$admin_gateway > $result
# Make sure we can view the admin page
#curl --cookie $cookie --cookie-jar $cookie --trace-ascii $trace $site$admin\
#    > $result

# Loop through the file passed as argument
rm "./htaccess"
rm "./.htaccess"
touch "./htaccess"
echo "RewriteEngine On" > "./htaccess"

while read line
    do
        # Parse and clean the input
        line="$(echo $line | awk /http/)"
#        "$(echo $line | cut -d',' -f1 | awk -F'.com/' '{print $2}' )"
        old="$store_gateway$(echo $line | cut -d',' -f'1' |\
            sed "s/\ /-/g;s/www.cayuseshop.com/$site/g;s/?//g;" |\
            awk -F"index.php" '{print $2}' |\
            sed 's/\./\\\./g;s/=/\\\=/g;s/&/\\\&/g' )"

#        "$(echo $line | cut -d',' -f2 | awk -F'.com/' '{print $2}' )"
        new="$(echo $line | cut -d',' -f'2' | \
            sed "s/\ /-/g;" | awk -F'.com/' '{print $2}' )"

        Itemid="$(echo $old | awk -F'Itemid=' '{print $2}' | cut -c 1 )"

        # Check for blank lines
        if [ "$old" == "" ]
            then
                continue
        elif [ "$(echo $old | awk '!/\?$/' |  awk '!/\/$/')" == "" ]
            then
                continue
        fi

#        num_params="$(./num_params.py "$old")"

#        # Send the cleaned data to the plugin
#        curl --cookie $cookie --cookie-jar $cookie --trace-ascii $trace \
#            --data-urlencode "origurl=$old"\
#            --data "sefurl=$new&option=com_sef&\
#            id=0&task=save&controller=sefurls&\
#            Itemid=$Itemid"\
#            $site$admin$url_gateway$extra_get_param\
#            > $result
#
#        echo "NUM_PARAMS:: $num_params"
#        echo "OLD:: $old"
#        echo "NEW:: $new"

        echo "RewriteRule $new /$old  [R=301,L]" >> ./htaccess

    done <$1

rm "./redirect_urls.txt"
rm "./htaccess.old"

cp "/var/www/.htaccess" "./"

cp "./htaccess" "redirect_urls.txt"

cat "/var/www/.htaccess" |\
 awk '!/RewriteEngine/' |\
 awk '!/index.php/' |\
 awk '!/index\.php/' >> "./htaccess.old"

cat "./htaccess.old" >> "./htaccess"
chown www-data.www-data ./htaccess

# Clean Up
if [ "$?" == "0" ]
    then
        mv "./htaccess" "/var/www/.htaccess"
        exit 0
    else
        echo "FAILED!"
    fi

