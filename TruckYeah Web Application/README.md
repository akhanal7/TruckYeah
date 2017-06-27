# TruckYeah! Food Truck Website
#### Junior Design Georgia Tech Food Truck Project.
TruckYeah! Food Truck Owner's Website is a web application that allows food truck owner's to easily add, delete and edit their Food Truck's on the website so that students can discover their Food Truck's on Gergia Tech's campus and browse their menus using the [iOS applicaiton](https://github.gatech.edu/nteissler3/truckyeah).

## Building and Deployment
The TruckYeah! web application can be built and run on macOS and Windows with any text editor. The steps are as follows:
#### MacOS Install Guide
1. Download [MySQL](https://dev.mysql.com/downloads/mysql/) and [PHPMyadmin](https://www.phpmyadmin.net/).
1. First, open the Terminal app and run the following commands 
    - Switch to the root user. This allows you to avoide any permission issues. 
    
        ```
        $ sudo su ~
        ```
    - Enable Apache
        ```
        $ apachectl start
        ```
    - Enable PHP for Apache
    
        ```
        $ cd /etc/apache2/
        ``` 
        
        ```
        $ cp httpd.conf httpd.conf.bak
        ```
        - Uncomment the pound sign in front of LoadModule php5_module libexec/apache2/libphp5.so.
        - Save and Restart Apache: 
        
        ```
        $ apachectl restart
        ```
        - Set priority for .php files:
        
        ```
        $ nano /etc/apache2/httpd.conf
        ```
        - Scroll all the way down until you find DirectoryIndex. Add index.php into DirectoryIndex.
        - Save and Restart Apache: 
        
        ```
        $ apachectl restart
        ```
    - MySQL Installation
        - Create MYSQL Symlink Folder:
        
        ```
        $  mkdir /var/mysql
        ```
        - Create MYSQL Symlink: 
        
        ```
        $  ln -s /tmp/mysql.sock /var/mysql/mysql.sock
        ```
        - Start MySQL in System Preferences
        - Go To MYSQL Folder: 
        
        ```
        $  cd /usr/local/mysql/bin
        ```
        - Log into MYSQL: 
        
        ```
        $  ./mysql -u root -p (PASSWORD YOU RECIEVED WHEN INSTALLING MYSQL)
        ```
        - Change Admin Password: 
        
        ```
        $  Alter user 'root'@'localhost' identified by 'PASSWORD'
        ```
        - Exit MYSQL: exit
        
        ```
        $  exit
        ```
    - PHPMyadmin Installation
        - Extract phpMyAdmin and move it to /Library/Webserver/Documents 
        - Go to Documents Folder:  
        
        ```
        $  cd /Library/WebServer/Documents
        ```
        - Go into phpmyadmin:  
        
        ```
        $  cd phpMyAdmin
        ```
        - Create config folder:  
        
        ```
        $  mkdir config
        ```
        - Adjust Rights: 
        
        ```
        $  chmod o+x config
        ```
        - Open Web Browser and enter localhost/phpMyAdmin/setup
        - Click on NEW SERVER and in authentication type the Password and save
        - Click on Download and Drag config into phpMyAdmin folder inside /Library/WebServer/Documents
1. Download the TruckYeah Source Code by cloning this repository into /Library/WebServer/Documents
1. Finally Create 4 new [tables](https://github.gatech.edu/akhanal7/TruckYeah-webapp/blob/master/tables.sql) in your database. Make sure you [update](https://github.gatech.edu/akhanal7/TruckYeah-webapp/blob/master/db.php) your database information.
1. Go to you web browser and enter localhost

#### Windows Install Guide
1. Download and install [MySQL](https://dev.mysql.com/downloads/mysql/) and [PHPMyadmin](https://www.phpmyadmin.net/).
1. Open the Command Prompt app and run the following commands 
    ```
    mysql -u root -p
    ```
   - This is to ensure that MySQL installed correctly
1. Download the TruckYeah Source Code by cloning this repository into /Library/WebServer/Documents
1. Finally Create 4 new [tables](https://github.gatech.edu/akhanal7/TruckYeah-webapp/blob/master/tables.sql) in your database. Make sure you [update](https://github.gatech.edu/akhanal7/TruckYeah-webapp/blob/master/db.php) your database information.
1. Go to you web browser and enter localhost
   
## Version 0.9.0 Release Notes
This is the beta release of our web app. All features are new and listed below: 

- Register a truckyeah account under any email
- Truck owners are able to add new food trucks, their descriptions and their menus.
- Truck owners can view details of their trucks and make changes to them accordingly

## Features for Next Release

- Ability for truck owners to add the location of their truck to a campus map

### Known Bugs and Chores
Bugs and chores, along with incomplete features are documented at the project's [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/1859347). Contact <nteissler@gatech.edu> if you need access.

### Troubleshooting

Most issues enountered will be related to the configuration and installation of Apache, PHP, MySQL, and PHPmyadmin. If any of these issues are encountered, follow the [step-by-step guide for MacOS](https://coolestguidesontheplanet.com/get-apache-mysql-php-phpmyadmin-working-osx-10-10-yosemite/) and/or [step-by-step guide for Windows](http://www.tutorialchip.com/php/how-to-install-apache-php-mysql-and-phpmyadmin-on-windows/).
