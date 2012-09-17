<?php
    include(dirname(__FILE__)."/modules/user.php");
    
    $device_name = $_REQUEST["device_name"];
    $fbId = $_REQUEST["fbId"];
    $name = $_REQUEST["name"];
    $username = $_REQUEST["username"];
    $password = $_REQUEST["password"];
    $passwordRepeat = $_REQUEST["passwordRepeat"];
    
    $resp = array();
    
    $result = tryRegister($device_name, $fbId, $name, $email, $password, $passwordRepeat);
    
    $resp["success"] = ($result === true ? 1 : 0);
    
    if($result !== true)
        resp["message"] = $result;
    
    echo json_encode($resp);
?>