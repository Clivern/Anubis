cd /tmp

echo "Installing latest composer"

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=$LOCAL_BIN/ --filename=composer
