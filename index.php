<?php

use Symfony\Component\Intl\Timezones;

require_once('vendor/autoload.php');

$locale = locale_get_default();

foreach(\IntlTimeZone::createTimeZoneIDEnumeration(\IntlTimeZone::TYPE_ANY) as $id) {
    try {
        Timezones::getName($id, 'en');
    } catch (\Exception $e) {
        echo $e->getMessage() . PHP_EOL;
    }
}
