cd /tmp

echo "Installing latest composer"

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer
