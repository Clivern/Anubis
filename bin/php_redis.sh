cd /tmp

git clone https://www.github.com/phpredis/phpredis.git

cd phpredis

phpize && ./configure && make && sudo make install

# Add extension=redis.so in your php.ini (Get loaded ones $ php --ini)

brew services restart php@7.2

make test

# Final Check
# php -r "if (new Redis() == true){ echo \"\r\n OK \r\n\"; }"
