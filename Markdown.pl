


 

                                           Server Administrator’s Guide
                                                                 Installation, configuration and administration of ownCloud
                                                                                                                                                                                  





















LEGAL NOTICE
Copyright © 2021 Red Hat, Inc
This document is developed with the proprietary information of Red Hat and owned by . No part of this document may be   reproduced, stored, copied, or transmitted in any form or by means of electronic, mechanical, photocopying or otherwise, without the express consent of Red Hat. 
The text of and illustrations in this document are licensed by Red Hat under a Creative Commons Attribution–Share Alike 3.0 Unported license ("CC-BY-SA"). An explanation of CC-BY-SA is available at http://creativecommons.org/licenses/by-sa/3.0/. In accordance with CC-BY-SA, if you distribute this document or an adaptation of it, you must provide the URL for the original version.
Red Hat, as the licensor of this document, waives the right to enforce, and agrees not to assert, Section 4d of CC-BY-SA to the fullest extent permitted by applicable law.
Red Hat, Red Hat Enterprise Linux, the Shadowman logo, the Red Hat logo, JBoss, OpenShift, Fedora, the Infinity logo, and RHCE are trademarks of Red Hat, Inc., registered in the United States and other countries.
Linux® is the registered trademark of Linus Torvalds in the United States and other countries.
Java® is a registered trademark of Oracle and/or its affiliates.
XFS® is a trademark of Silicon Graphics International Corp. or its subsidiaries in the United States and/or other countries.
MySQL® is a registered trademark of MySQL AB in the United States, the European Union and other countries.
Node.js® is an official trademark of Joyent. Red Hat is not formally related to or endorsed by the official Joyent Node.js open source or commercial project.
The OpenStack® Word Mark and OpenStack logo are either registered trademarks/service marks or trademarks/service marks of the OpenStack Foundation, in the United States and other countries and are used with the OpenStack Foundation's permission. We are not affiliated with, endorsed or sponsored by the OpenStack Foundation, or the OpenStack community.
All other trademarks are the property of their respective owners.











Table of Contents
CHAPTER 1. What is ownCloud Server?	4
CHAPTER 1.1   ownCloud Videos and Blogs	6
CHAPTER 1.2 Target Audience	7
CHAPTER 2. INSTALLATION	7
CHAPTER 2.1 Deployment Considerations	7
HARDWARE	7
SOFTWARE	7
Operating System	7
Web Server	7
Relational Database	7
File Storage	8
Session Storage	8
CHAPTER 2.2 SYSTEM REQUIREMENTS	8
Officially Recommended Environment	8
Officially Supported Environments	8
Server	8
Database Requirements	9
Memory Requirements	9
CHAPTER 2.3 Downloading ownCloud Server	9
Script Guided Installation	10
Command Line Guided Installation	10
Complete the Installation	10
Finalize Using the Graphical Installation Wizard	10
Finalize Using the Command Line	10
Post Installation Configuration	11









Introduction
This quickstart guide describes the system requirements and also explains how to install and configure an ownCloud server.
Understanding and ensuring your system meets all of the described prerequisites before you begin installing the product will help ensure a successful outcome.
Before installing the application for the first time, ensure that you have root privileges for the servers and the software described in the prerequisites section below has already been installed and configured.
Note: At the time of writing this manual, version 10.1 is the latest stable version of ownCloud server.

Prerequisites
Following prerequisites must be met for successful installation and configuration of an ownCloud server.
Installing ownCloud Server

Command Line Installation
There are different methods and platforms for installing an ownCloud server. However, administrators prefer using the command line over a graphic user interface (GUI). Command line installation involves five steps:
Ensure your server meets the following ownCloud prerequisites
Once all the prerequisites are met, download and unpack the tarball. (Follow the Preferred Linux Installation Method and Manual Installation on Linux)
To install ownCloud, first download the source (whether community or enterprise) directly from ownCloud, and then unpack the tarball in appropriate directories.
Once done, set your webserver user to be the owner of your unpacked ownCloud directory.
$ sudo chown -R www-data:www-data /var/www/owncloud/
Use the occ(ownCloud console) command to complete the installation process.
Note: occ is ownCoud’s command-line interface
Use the occ command, from the root directory of the ownCloud source, to perform the installation. This removes the need to run the Graphical Installation Wizard.
# Assuming you’ve unpacked the source to /var/www/owncloud/
$ cd /var/www/owncloud/
$ sudo -u www-data php occ maintenance:install \
   --database "mysql" --database-name "owncloud" \
   --database-user "root" --database-pass "password" \
 	   --admin-user "admin" --admin-pass "password"
Note: You must Run occ As Your HTTP User.
If you want to use a directory other than the default (which is data inside the root ownCloud directory), you can also supply the --data-dir switch. For example, if you were using the command above and you wanted the data directory to be /opt/owncloud/data, then add --data-dir/opt/owncloud/data to the command.
Apply correct permissions to your ownCloud files and directories Once the command is executed, Set Strong Directory Permissions to your ownCloud files and directories.
Note: This is extremely important, as it helps protect your ownCloud installation and ensure that it will operate correctly.
(Optional) Post-Installation Steps
Other Installation Methods
Listed below are other methods you can use to install an OwnCloud server:
Linux Package Manager Installation is used for signle-server setups.
Installation Wizard is used when the ownCloud prerequisites are fulfilled and all ownCloud files are installed.
Manual Installation can also be done on different Linux distributions
Ubuntu 18.04 LTS Server
RHEL (RedHat Enterprise Linux) 7.2
CentOS 7
SLES (SUSE Linux Enterprise Server) 12
Configuring ownCloud server
ownCloud requires a separate database for storing administrative data. ownCloud currently supports the following databases:
MySQL or MariaDB
PostgreSQL
Oracle (ownCloud Enterprise edition only)
Prerequisites for Configuring MySQL or MariaDB Database
Configuring MYSQL/MariaDB database requires you to install and set up the server software.
Note: The choice of database will not alter the functionality of ownCloud. However, we recommend using MySQL or MariaDB database engines for configuring ownCloud.
MySQL or MariaDB with Binary Logging Enabled
To avoid data loss under high load scenarios, ownCloud is currently using a TRANSACTION_READ_COMMITTED transaction isolation. This requires a disabled or correctly configured binary logging when using MySQL or MariaDB. Your system is affected if you see the following in your log file during the installation or update of ownCloud:
An unhandled exception has been thrown: exception `PDOException' with
message `SQLSTATE[HY000]: General error: 1665 Cannot execute statement:
impossible to write to binary log since BINLOG_FORMAT = STATEMENT and at
least one table uses a storage engine limited to row-based logging.
InnoDB is limited to row-logging when transaction isolation level is
READ COMMITTED or READ UNCOMMITTED.'  
There are two solutions to rectify this problem:
Disable binary logging as it records all changes to your database, and the time for each change. The purpose of binary logging is to enable replication and to support backup operations.
Change the BINLOG_FORMAT = STATEMENT in your database configuration file, or possibly in your database startup script, to BINLOG_FORMAT = MIXED or BINLOG_FORMAT = ROW. See Overview of the Binary Log and The Binary Log for detailed information.
MySQL / MariaDB READ COMMITED Transaction Isolation Level
As discussed, ownCloud is using the TRANSACTION_READ_COMMITTED transaction isolation level to avoid data loss under high load scenarios (e.g., by using the sync client with many clients/users and many parallel operations). In this case, you need to configure the transaction isolation level accordingly. Please refer to the MySQL Reference Manual for detailed information.
MySQL or MariaDB Storage Engine
InnoDB is supported as a storage engine on ownCloud 7. There are some shared hosts who do not support InnoDB and only MyISAM and so running ownCloud on such an environment is not supported.
Parameters
Follow the instructions in The Installation Wizard for setting up ownCloud for using different database engines. You do not have to edit the respective values in the config/config.php. However, in special cases (for example, for connecting your ownCloud instance to a database created by a previous installation of ownCloud), some modification might be required.
MySQL or MariaDB Database Configuration
Ensure the following before you configure MySQL or MariaDB database:
Installing and enabling the pdo_mysql extension in PHP
If the database runs on the same server as ownCloud, mysql.default_socket points to the correct socket.
MariaDB is backwards compatible with MySQL. So you will not need to replace or revise any, existing, MySQL client commands.
This is how a PHP configuration in /etc/php5/conf.d/mysql.ini could look like:
# configuration for PHP MySQL module
extension=pdo_mysql.so

[mysql]
mysql.allow_local_infile=On
mysql.allow_persistent=On
mysql.cache_size=2000
mysql.max_persistent=-1
mysql.max_links=-1
mysql.default_port=
mysql.default_socket=/var/lib/mysql/mysql.sock  # Debian squeeze: /var/run/mysqld/mysqld.sock
mysql.default_host=
mysql.default_user=
mysql.default_password=
mysql.connect_timeout=60
mysql.trace_mode=Off  
To create database tables, you first need to create a database user by using the MySQL command line interface. The database tables will be created by ownCloud when you login for the first time.
To get started, log into MySQL with the administrative account and use the following command line:
mysql -uroot -p  
which will give a mysql> or MariaDB [root]> command prompt. Now enter the following lines and confirm them by clicking the enter key:
CREATE DATABASE IF NOT EXISTS owncloud;
GRANT ALL PRIVILEGES ON owncloud.* TO 'username'@'localhost' IDENTIFIED BY 'password';  
Now you can quit the prompt by entering:
quit    
An ownCloud instance configured with MySQL would contain the hostname on which the database is running, a valid username and password to access it, and the name of the database. The config/config.php as created by the installation wizard would therefore contain entries like this:
<?php

  "dbtype"        => "mysql",  
  "dbname"        => "owncloud",  
  "dbuser"        => "username",  
  "dbpassword"    => "password",  
  "dbhost"        => "localhost",  
  "dbtableprefix" => "oc_",  
For supporting additional features such as emoji, both MySQL and ownCloud needs to be configured to use 4-byte Unicode Support.
Changing Your ownCloud URL and Port Configuration
ownCloud server is accessible under the route /owncloud (which is the default, e.g. https://example.com/owncloud). However, you can change this in your web server configuration, by changing the URL from https://example.com/owncloud to https://example.com/).
Config.php Parameters
To control server operations, ownCloud uses the config/config.php file. config/config.sample.php lists all the configurable parameters within ownCloud, along with example or default values.
Note: You do not need to copy everything from config/config.sample.php. Add only the parameters you wish to modify.
To do the changes on Debian/Ubuntu Linux operating systems, you need to edit these files:
/etc/apache2/sites-enabled/owncloud.conf
/var/www/owncloud/config/config.php
Default Parameters
Once config.php file has been configured by the ownCloud server, you can customize the default values of the given parameters.
Mentioned below are the default parameters configured by the ownCloud installer and are required by your ownCloud server to operate.
'instanceid' => '', A valid **instanceid** is auto-generated by the ownCloud installer once you install ownCloud.  

'passwordsalt' => '', The salt is used to hash all passwords and is auto-generated by the ownCloud installer. Do remember, if you lose this salt you lose all your passwords.  

'trusted_domains' =>
  array (
    'demo.example.org',
    'otherdomain.example.org',
  ), This gives a list of trusted domains that users can log into. Specifying trusted domains prevents host header poisoning. You are not supposed to remove this, as it performs necessary security checks.

'datadirectory' => '/var/www/owncloud/data', This defines the location of the user files **data/** in the ownCloud directory.

'version' => '', Identifies the current version number of your ownCloud installation. This is set up and updated during installation, and so it does not require any changes.

'dbtype' => 'mysql', Identifies the database used with this installation.  

'dbhost' => '',   This defines the host server name, for example **localhost**, **hostname**, **hostname.example.com**, or the **IP address**. To specify a port use **hostname:####**   For example,

'dbhost' => 'x.x.x.x:8080', where x.x.x.x is server’s IP address  
             
'dbname' => 'owncloud',       Defines the name of the ownCloud database, which is set during installation. 

'dbuser' => '', Defines the user that ownCloud uses to write to the database. This must be unique across ownCloud instances using the same SQL database.

'dbpassword' => '', Defines the password for the database user, which is set up during installation.
  
'dbtableprefix' => '', Prefix for the ownCloud tables in the database.

'installed' => false, Indicates whether the ownCloud instance was installed successfully; **true** indicates a successful installation, and **false** indicates an unsuccessful installation.    

Default config.php Example
This is how your config.php will look like after installing ownCloud using MySQL database.
<?php
$CONFIG = array (
  'instanceid' => 'oc8c0fd71e03',
  'passwordsalt' => '515a13302a6b3950a9d0fdb970191a',
  'trusted_domains' =>
  array (
    0 => 'localhost',
    1 => 'studio',
    2 => '192.168.10.155'
  ),
  'datadirectory' => '/var/www/owncloud/data',
  'dbtype' => 'mysql',
   'version' => '7.0.2.1',
  'dbname' => 'owncloud',
  'dbhost' => 'localhost',
  'dbtableprefix' => 'oc_',
  'dbuser' => 'oc_carla',
  'dbpassword' => '67336bcdf7630dd80b2b81a413d07',
  'installed' => true,
);  
Once the changes are made and all the files have been saved, restart the Apache server. You can now access ownCloud from either, https://example.com/ or https://localhost/.
Proxy Configurations
The automatic hostname, protocol or webroot detection of ownCloud can fail in certain reverse proxy situations. This configuration allows the automatic detection to be manually overridden. You can find the detailed explanation in the Overwrite Parameters section.
'overwritehost' => '', This option allows you to manually override the automatic detection; for example **www.example.com**, or specify the port **www.example.com:8080**.

'overwriteprotocol' => '',   When generating URLs, ownCloud attempts to detect whether the server is accessed via **https** or **http**. However, if ownCloud is behind a proxy and the proxy handles the **https** calls, ownCloud would not know that **ssl** is in use, which would result in incorrect URLs being generated.  

'overwritewebroot' => '', ownCloud attempts to detect the webroot for generating URLs automatically. For example, if **www.example.com/owncloud** is the URL pointing to the ownCloud instance, the webroot is **/owncloud**. When proxies are in use, it may be difficult for ownCloud to detect this parameter, resulting in invalid URLs.

'overwritecondaddr' => '', This option allows you to define a manual override condition as a regular expression for the remote IP address. For example, defining a range of IP addresses starting with **10.0.0.** and ending with 1 to 3: **^10\.0\.0\.[1-3]$**

'overwrite.cli.url' => '', Use this configuration parameter to specify the base URL for any URLs which are generated within ownCloud using any kind of command line tools (cron or occ). The value should contain the full base URL: **https://www.example.com/owncloud**

Adding User Accounts to ownCloud Server

Overview
ownCloud is an enterprise file sharing service for online collaboration and storage. To access this service, the user needs to have their user account which is created and managed by the admin group.
Prerequisites for Adding User Accounts by the Admin Team
Sign in to the ownCloud server 10.1 using an administrator account.
Once the user administration page is displayed, click on the username(admin). A drop-down menu appears with options to enter the following sections: Personal, Users, Apps, Admin, Help, and Log out.
 
3.	Click on the Users item from the drop-down menu. A default table appears displaying basic information about the users whose accounts have already been created.
 
4.	Create groups based on user’s access limitations.
To add groups, go to the Groups field. Hover over the + add group field, enter a name for the group and hit the Enter button.
 
Now you can start adding users and adding them to specific groups as per defined access controls.
Adding or Creating New User Accounts
Enter the new user’s Login Name and the initial Password
(Optional) Assign Groups membership
Click the Create button
Note: Login names may contain letters (a-z, A-Z), numbers (0-9), dashes (-), underscores (_), periods (.), and at signs (@). ownCloud usernames cannot be changed. These are user’s permanent-owned cloud user IDs. However, user’s Full Name can be changed. The admin can also edit the passwords and can change group assignments as and when needed. This is a useful mechanism for delegating some admin chores and also enabling groups to manage themselves.
After creating the user, you may fill in their Full Name if it is different from the login name or you can leave it for the user to complete.
 
Note: Press Ctrl-R to refresh the page. This is done to make sure your new entry is visible.
To summarize, the steps involved in creating or adding a new user are entering a name and password and delegating the user to a group. The new user can now log in to the ownCloud server and start collaborating with other users.


Connecting to ownCloud Server Using Desktop Client

Overview
The ownCloud Desktop Synchronization Client is used for synchronizing files with the desktop computer. As a user, you can download the latest version of the ownCloud Desktop Synchronization Client from the ownCloud download page, and can run on various platforms like Microsoft Windows, Mac OS X, and variants of Linux distributions.
ownCloud Desktop Synchronization Client enables the user to:
Create folders in the home directory and keep the contents of those folders synced with the ownCloud server.
Synchronize all the latest files irrespective of their location.
You can find more advanced usage in the ownCloud Advanced Usage section.
Step-by-Step Instructions for Connecting ownCloud Server
Once you have installed the ownCloud Desktop Synchronization Client on your operating system, follow these steps to connect with your ownCloud server:
Launch the ownCloud Desktop Client.
In the ownCloud Connection Wizard dialog box, enter the IP address for your server. Click Next to proceed.
 
3.	Enter your Username and Password and click Next.
 
4.	Specify whether to synchronization all of your files on the ownCloud server or only selected files. Also, specify a location for the local files to reside.
 
5.	Click the Connect button. The ownCloud Desktop Synchronization Client will attempt to connect to your ownCloud server. Once connected, you will see two buttons:
Open ownCloud in Browser
Open Local Folder
Choose the button where you want to synchronize your files. Then click the Finish button, and you are all done.
 



