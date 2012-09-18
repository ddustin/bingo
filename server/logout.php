<?php
    include(dirname(__FILE__)."/modules/user.php");
    
    $device_name = $_REQUEST["device_name"];
    
    logout($device_name);
?>
