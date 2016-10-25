# PHP-FPM 7 Symfony docker image

This image includes:
* PHP-FPM 7 (and cli) with modules
    * mcrypt
    * ldap
    * mbstring
    * pdo
    * pgsql
    * pear 
    * apcu 
    * gd
    * intl
    * bcmath 
    * devel 
    * process 
    * pspell 
    * recode 
    * tidy 
    * xml 
    * xmlrpc 
    * opcache 
    * json 
    * xdebug 
    * apcu 
* PostgreSQL 9.6 client
* PHPUnit
* Node, npm with modules:
    * bower
    * uglifyjs
    * uglifycss
    * grunt-cli
    
* Scripts are prepared from:
    * /pause - (stopping) the PHP-FPM instance    
    * /resume - (starting) the PHP-FPM instance
    * /restart (stopping) the PHP-FPM instance
    
## Configure PhpStorm for xdebug remote debugger

Open Preferences -> Languages & Frameworks -> PHP -> Servers
Add a new server:
* Name: symfony
* Host: 0.0.0.0
* Port: 8000
* Debugger: XDebug
* Use path mappings [x]
* Add a mapping from project root -> filesystem path to symfony root

Open Preferences -> Languages & Frameworks -> PHP -> Debug -> XDebug
* Port: 9000
* Check everything under XDebug

To get bookmarklets in the browser for controlling the debugging go to https://www.jetbrains.com/phpstorm/marklets/ and generate...

## Test PhpStorm debugging

To test everything
1. Set a breakpoint in the DefaultController::indexAction()
2. Enable "Listen for debugger connections"
3. Activate debugging in the browser using the bookmarklet
4. Refresh the browser on http://localhost:8000

If everything works the breakpoint shall be triggered.

## XDebug troubleshooting

Since XDebug needs to know how to connect back to the host, it is configured by default with
```
xdebug.remote_host=10.254.254.254
```

### Debugging symfony commands

To allow debugging of symfony commands add server ip and port to the command line, like this:

```
$ docker exec -it devnapalm_php_1 /bin/bash
$ PHP_IDE_CONFIG="serverName=symfony" php -dxdebug.remote_autostart=1 -dxdebug.remote_enable=1 -dxdebug.remote_host=10.254.254.254 -dxdebug.idekey=PHPSTORM bin/console symfomy_command_here
```

To make callbacks work an alias to localhost is needed, under macOS this is created like this (see https://gist.github.com/ralphschindler/535dc5916ccbd06f53c1b0ee5a868c93): 

```
$ sudo ifconfig lo0 alias 10.254.254.254
```

If server configuration lookup fails, set the following in the php container
```
$ export PHP_IDE_CONFIG="serverName=symfony"
```

Where ```symfony``` is the name chosen for the server configuration.

Now copy that IP and replace the one in php-fpm/xdebug.ini. To activate the changes remove current containers and the ngpsapp image
