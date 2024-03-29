<?php
include_once(dirname(__FILE__)."/database.php");

/******* Functions *********
 
 tryLogin(device_name, fbId, email, password)
 // Attempts to login the device referred to by 'device_name'
 // Either fbId or email + password are required. Unused
 // parameters should be null.
 // 
 // If device_name does not refer to a user_device row that will be created.
 // 
 // The user_device row will be corrilated with the user_id if the login is
 // successful.
 // 
 // Returns true on success and false on failure.

 logout(device_name)
 // Attempts to log out the device referred to by 'device_name'
 
 tryRegister(device_name, fbId, name, email, password, repeatPassword)
 // Attempts to register a new user using either fbId or email + password + repeatPassword.
 // An optional parameter name sets the full name of the user.
 // 
 // If device_name does not refer to a user_device row that will be created.
 // 
 // The user_device row will be corrilated with the new user_id if the login
 // is successful.
 // 
 // Returns true on success or a string on failure. The string will describe the error
 // in human readable form.
 
 getLogin(device_name)
 // Checks if device_name has a corrilated user and loads it.
 //
 // Returns the user_id as an int if successful, or false on failure.
 
 */

function getLogin($device_name) {
    
    global $database;
    
    if(!$device_name)
        return false;
    
    $device_name = $database->escape($device_name);
    
    $query = "select `user_id` from `user_device` where `device_name` = $device_name limit 1";
    
    $res = $database->query($query);
    
    $row = mysql_fetch_row($res);
    
    if(!$row)
        return false;
    
    return $row[0];
}

function logout($device_name) {
    
    global $database;
    
    if(!$device_name)
        return;
    
    $device_name = $database->escape($device_name);
    
    $query = "update `user_device` set `user_id`=0 where `device_name`=$device_name limit 1";
    
    $database->query($query);
}

function getUserDeviceId($device_name) {
    
    global $database;
    
    if(!$device_name)
        return false;
    
    $device_name = $database->escape($device_name);
    
    $query = "select `id` from `user_device` where `device_name` = $device_name limit 1";
    
    $res = $database->query($query);
    
    $row = mysql_fetch_row($res);
    
    if(!$row)
        return false;
    
    return $row[0];
}

function addUserDevice($device_name) {
    
    global $database;
    
    $device_name = $database->escape($device_name);
    
    $query = "insert into `user_device` (`device_name`) VALUES ($device_name)";
    
    return $database->insert($query);
}

function generatePasswordSalt() {
    
    return sha1(time());
}

function getPasswordSalt($email) {
    
    global $database;
    
    $email = $database->escape($email);
    
    $saltQuery = "select `salt` from `user` where `email`=$email limit 1";
    
    $res = $database->query($saltQuery);
    
    $row = mysql_fetch_row($res);
    
    if(!$row)
        return NULL;
    
    return $row[0];
}

function encryptPassword($password, $salt) {
    
    return sha1($password . $salt);
}

function tryLogin($device_name, $fbId, $email_unsafe, $password_unsafe) {
    
    global $database;
    
    if(!$device_name)
        return false;
    
    if(!$fbId && (!$email_unsafe || !$password_unsafe))
        return false;
    
    $userDeviceId = getUserDeviceId($device_name);
    
    if($userDeviceId === false)
        $userDeviceId = addUserDevice($device_name);
    
    if(!$userDeviceId)
        return false;
    
    $device_name = $database->escape($device_name);
    $fbId = $database->escape($fbId);
    $email = $database->escape($email_unsafe);
    
    $query = NULL;
    
    if($fbId) {
        
        $query = "select `id` from `user` where `fb_id`=$fbId limit 1";
    }
    else {
        
        $salt = getPasswordSalt($email_unsafe);
        
        if($salt) {
            
            $password = encryptPassword($password_unsafe, $salt);
            
            $password = $database->escape($password);
            
            $query = "select `id` from `user` where `email`=$email and `password`=$password limit 1";
        }
    }
    
    if($query == NULL)
        return false;
    
    $res = $database->query($query);
    
    $row = mysql_fetch_row($res);
    
    if(!$row)
        return false;
    
    $user_id = $row[0];
    
    $query = "update `user_device` set `user_id`=$user_id where `id`=$userDeviceId limit 1";
    
    $database->query($query);
    
    return true;
}

function tryRegister($device_name, $fbId, $name, $email_unsafe, $password_unsafe, $repeatPassword_unsafe) {
    
    global $database;
    
    if(!$device_name)
        return "Server error: no device_name specified.";
    
    if(!$fbId && $email_unsafe && !$password_unsafe)
        return "You must specify a password";
    
    if(!$fbId && (!$email_unsafe || !$password_unsafe))
        return "You must specify a facebook login or email & password.";
    
    $userDeviceId = getUserDeviceId($device_name);
    
    if($userDeviceId === false)
        $userDeviceId = addUserDevice($device_name);
    
    if(!$userDeviceId)
        return "Server error: unable to aquire device id.";
    
    $device_name = $database->escape($device_name);
    $fbId = $database->escape($fbId);
    $name = $database->escape($name);
    $email = $database->escape($email_unsafe);
    
    $facebookLogin = false;
    
    if($fbId)
        $facebookLogin = true;
    
    $query = NULL;
    
    if($facebookLogin) {
        
        if($name && $email) {
            
            $query = "insert into `user` (`fb_id`, `name`, `email`) values ($fbId, $name, $email) on duplicate key update `name`=$name, `email`=$email";
        }
        else if($name) {
            
            $query = "insert into `user` (`fb_id`, `name`) values ($fbId, $name) on duplicate key update `name`=$name";
        }
        else if($email) {
            
            $query = "insert into `user` (`fb_id`, `email`) values ($fbId, $email) on duplicate key update `email`=$email";
        }
        else {
            
            $query = "insert into `user` (`fb_id`) values ($fbId) on duplicate key update `fb_id`=$fbId";
        }
    }
    else {
        
        if(!$email_unsafe)
            return "You must specify an email address.";
        
        if(FALSE == strstr($email_unsafe, '@'))
            return "You must specify a valid email address.";
        
        if(!$password_unsafe || !strlen($password_unsafe))
            return "You must specify a password.";
        
        if($password_unsafe != $repeatPassword_unsafe)
            return "The passwords must match.";
        
        $salt = generatePasswordSalt();
        $password = encryptPassword($password_unsafe, $salt);
        
        $salt = $database->escape($salt);
        $password = $database->escape($password);
        
        if($name) {
            
            $query = "insert into `user` (`name`, `email`, `password`, `salt`) values ($name, $email, $password, $salt)";
        }
        else {
            
            $query = "insert into `user` (`email`, `password`, `salt`) values ($email, $password, $salt)";
        }
    }
    
    if($facebookLogin) {
        
        $user_id = $database->insert($query);
    }
    else {
        
        $user_id = $database->insert($query, false);
        
        if(!$user_id)
            return "That email addressed is already registered, please use another.";
    }
    
    if(!$user_id)
        return "Server error: Invalid user_id.";
    
    $query = "update `user_device` set `user_id`=$user_id where `id`=$userDeviceId limit 1";
    
    $database->query($query);
    
    return true;
}

?>
