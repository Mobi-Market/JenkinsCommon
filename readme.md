# Jenkins Common Pipeline

A common Jenkins pipeline process for PHP projects with autumn.dev repositories

## Usage
Add the following to your systems Jenkins file.
```
commonPipeline(system: 'SYSTEM_NAME')
```

NB: Change SYSTEM_NAME to the name of the project on Jenkins.

## Requirements

This common pipeline require you to have the following composer dev dependancies:

* [PHPUnit](https://packagist.org/packages/phpunit/phpunit)
* [PHP-Stan](https://packagist.org/packages/phpstan/phpstan)
* [PHP-CPD](https://packagist.org/packages/sebastian/phpcpd)
* [PHP-CS](https://packagist.org/packages/squizlabs/php_codesniffer)
* [PHP-CS-Fixer](https://packagist.org/packages/friendsofphp/php-cs-fixer)
* [PHP-Doc](https://packagist.org/packages/phpdocumentor/phpdocumentor#v2.9.0)

## Steps
The common Jenkins pipeline provides the following steps:

1. Build - builds the system using dev requirements
2. Unit Test - Runs PHP Unit tests
3. Functional Test - runs PHP functions/Database tests
4. Static Analysis - runs static analysis tools against the code base
5. Copy Paste Detector - Runs PHP CPD on the code base.
6. Documentation - Runs PHP Doc on the codebase
7. Package - Builds the code base using production flags ready for archiving and delivery
8. Archive - Zips the results of the Package step 
9. Tagging - tags the git repo with release candidate/release tags using the build number.

## ToDo
A few outstanding issues need to be resolved. Namely:

* Fix links to the PHP tools report output in Jenkins
* Fix issues with git tagging the origin with new rc/v tags
* Fix/add comunication with database for Functional Tests.