#! /bin/bash

# Peter Novotnak::2012, Flexion INC

set -x # Debugging


#///////  stackoverflow.com/q/59895#answer-246128

SOURCE="${BASH_SOURCE[0]}"
DIR="$( dirname "$SOURCE" )"
while [ -h "$SOURCE" ]
do 
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
  DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd )"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


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




# Loop through the file passed as argument
rm "$DIR/htaccess"
rm "$DIR/.htaccess"
touch "$DIR/htaccess"
echo "RewriteEngine On" > "$DIR/htaccess"

while read line
    do
        # Parse and clean the input
        line="$(echo $line | awk /http/)"
        old="$store_gateway$(echo $line | cut -d',' -f'1' |\
            sed "s/\ /-/g;s/www.cayuseshop.com/$site/g;s/?//g;" |\
            awk -F"index.php" '{print $2}' |\
            sed 's/\./\\\./g;s/=/\\\=/g;s/&/\\\&/g' )"

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

        echo "RewriteRule $new /$old  [R=301,L] #FLEXURL" >> "$DIR/htaccess"

    done <$1


cp "/var/www/.htaccess" "./"

cp "$DIR/htaccess" "redirect_urls.txt"

cat "/var/www/.htaccess" |\
 awk '!/RewriteEngine/' |\
 awk '!/index.php/' |\
 awk '!/FLEXURL/'\ |
 awk '!/index\.php/' > "$DIR/htaccess.old"

cat "$DIR/htaccess.old" >> "$DIR/htaccess"
chown www-data.www-data "./htaccess"

# Clean Up
if [ "$?" == "0" ]
    then
        mv "$DIR/htaccess" "/var/www/.htaccess"
        exit 0
    else
        echo "FAILED!"
    fi

