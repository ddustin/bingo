<?php
    include(dirname(__FILE__)."/modules/user.php");
    
    $device_name = $_REQUEST["device_name"];
    $fbId = $_REQUEST["fbId"];
    $username = $_REQUEST["username"];
    $password = $_REQUEST["password"];
    
    $resp = array();
    
    $resp["success"] = (tryLogin($device_name, $fbId, $username, $password) === true ? 1 : 0);
    
    echo json_encode($resp);
?>