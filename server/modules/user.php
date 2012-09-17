<?ph
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

function tryLogin(device_name) {
    
    
}

?>