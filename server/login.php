<?php
    include(dirname(__FILE__)."/modules/user.php");
    
    $device_name = $_REQUEST["device_name"];
    $fbId = $_REQUEST["fbId"];
    $email = $_REQUEST["email"];
    $password = $_REQUEST["password"];
    
    $resp = array();
    
    error_log("tryLogin($device_name, $fbId, $email, $password)");
    
    $resp["success"] = (tryLogin($device_name, $fbId, $email, $password) === true ? 1 : 0);
    
    echo json_encode($resp);
?>
