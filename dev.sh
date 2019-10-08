# TODO: Check for existing versions / files to make it more idempotent
# Install the deps for a decent webdev environment

brew update

mkdir -p "${HOME}/bin"

# Get the latest PHP / MySQL
brew install php
brew install mysql@5.7  

#Composer
echo "Install Composer"
echo ""

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --filename=composer --install-dir=bin
php -r "unlink('composer-setup.php');"

pecl install xdebug

if [ ! -f /usr/local/etc/php/${PHP_VERSION}/conf.d/ext-xdebug.ini ]; then
    echo "Copying over base debug config to /usr/local/etc/php/${PHP_VERSION}/conf.d/ext-xdebug.ini"
    sudo cp init/ext-xdebug.ini /usr/local/etc/php/${PHP_VERSION}/conf.d/ext-xdebug.ini
    echo ""
fi;

echo "Installing NVM"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash


echo "NVM Installed, installing node versions"
nvm install latest
nvm install --lts=carbon
nvm install --lts=dubnium
nvm use latest

brew install yarn

echo ""
echo "Installing WP CLI"
echo ""

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
php wp-cli.phar --info
chmod +x wp-cli.phar
mv wp-cli.phar bin/wp

echo ""
echo "Installing Valet"
echo ""
composer global require laravel/valet
valet install


echo ""
echo "Installing PHP CS and WordPress Coding Standards"
echo ""
composer global require "squizlabs/php_codesniffer=*" "dealerdirect/phpcodesniffer-composer-installer" "wp-coding-standards/wpcs" 