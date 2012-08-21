#! /bin/bash

# Peter Novotnak::2012, Flexion INC

site='cayuseshop.com'
store_gateway='/index.php?'
www='/var/www'


debug=false




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




# Import pretty messages
. "$DIR/bsfl"




# Loop through the file passed as argument
rm "$DIR/htaccess" >/dev/null 2>&1
rm "$DIR/.htaccess" >/dev/null 2>&1
rm "$DIR/tmp"* >/dev/null 2>&1
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

        echo "$old, $new, $Itemid" >> "$DIR/tmp0"

done <$1

# Re apply 'http://[site]/[path] for the sitemap
while read line
    do
        N=$(echo $line | cut -d',' -f'2')
        echo "http://$site/${N:1}" >> "$DIR/tmp1"
    done <"$DIR/tmp0"

# Write the sitemap
cat "$DIR/tmp1" | "$DIR/sitemap_generator.py" "$DIR"

# Write the rewrite rules
while read line
    do
        echo "RewriteRule \
^$(echo $line | cut -d',' -f'2' | sed 's/ //g' )$ \
$(echo $line | cut -d',' -f'1') \
[R=301,L] #FLEXURL" >> "$DIR/htaccess"

    done <"$DIR/tmp0"


# Merge the old and new .htaccess files
cp "$www/.htaccess" "./"
cat "$www/.htaccess" |\
 awk '!/RewriteEngine/' |\
 awk '!/index.php/' |\
 awk '!/FLEXURL/'\ |
 awk '!/index\.php/' >> "$DIR/htaccess"
chown www-data.www-data "$DIR/htaccess"
chown www-data.www-data "$DIR/sitemap.xml"

# Move everything in
if $debug
    then
        exit 1
    else
        if $prompt
            then
                read -p "
                
Move { sitemap.xml } and { .htaccess } to $www ?

( Move sitemap and .htaccess to ~[] ) [y/n]  : "
                if [ "$REPLY" == "y" ]
                    then
                        echo -ne "Continuing "
                        for i in {3..1}
                            do
                                echo -ne "$i"
                                for x in {1..3}
                                    do
                                        echo -ne '.'
                                        sleep .25
                                    done
                                sleep .25
                        done
                        echo ''
                     else
                        echo " Aborted. "
                        exit 1
                   fi
            fi
        cmd "mv $www/sitemap.xml $www/~sitemap.xml"
        cmd "mv $www/.htaccess $www/~.htaccess"
        cmd "mv $DIR/sitemap.xml $www/sitemap.xml"
        cmd "mv $DIR/htaccess $www/.htaccess"
        cmd "rm tmp*"
        echo "Done!"
        exit 0
    fi

