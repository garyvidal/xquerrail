<?php

error_reporting(E_ALL ^ E_NOTICE);

try {
    $dbh = new PDO('sqlite:/tmp/editable.sqlite');
} catch(PDOException $e) {
    print $e->getMessage();
}


??>