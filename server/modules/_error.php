<?php

// If true, errors are output.  If false errors are emailed.
$errorDebugMode = true;

function declare_error($errstr)
{
    $email = "$errstr\n\n"
        . "\nMysql Error: " . mysql_error()
        . "\n\nDebug info:\n";
    
    if(!$GLOBALS['SECUIRY_IS_IMPORTANT']) {
    	
	    ob_start();
	    debug_print_backtrace();
	    $trace = ob_get_contents();
	    ob_end_clean();
		
	    // Remove first item from backtrace as it's this function which
	    // is redundant.
	    $trace = preg_replace ('/^#0\s+' . __FUNCTION__ . "[^\n]*\n/", '', $trace, 1);
		
	    // Renumber backtrace items.
	    $trace = preg_replace ('/^#(\d+)/me', '\'#\' . ($1 - 1)', $trace);
		
		$email .= "$trace\n";
    }
    
    $email .=  "_SESSION: " . print_r($_SESSION, true)
        . "_SERVER: " . print_r($_SERVER, true)
        . "\n\nSincerely,\nYour Server";
    
    $headers  = '';
    
    if($GLOBALS['errorDebugMode'])
        echo '<pre>'.$email."</pre> <br>\n";
    else
        mail("dustinpaystaxes@gmail.com", "[{$_SERVER['HTTP_HOST']}] $errstr", "$errstr\n\n\n$email", $headers);
    
    header("Location: /");
    exit;
}

function declare_warning($errstr)
{
    $email = "$errstr\n\n"
        . "\nMysql Error: " . mysql_error()
        . "\n\nDebug info:\n";
    
    if(!$GLOBALS['SECUIRY_IS_IMPORTANT']) {
    	
	    ob_start();
	    debug_print_backtrace();
	    $trace = ob_get_contents();
	    ob_end_clean();
		
	    // Remove first item from backtrace as it's this function which
	    // is redundant.
	    $trace = preg_replace ('/^#0\s+' . __FUNCTION__ . "[^\n]*\n/", '', $trace, 1);
		
	    // Renumber backtrace items.
	    $trace = preg_replace ('/^#(\d+)/me', '\'#\' . ($1 - 1)', $trace);
		
		$email .= "$trace\n";
    }
    
    $email .=  "_SESSION: " . print_r($_SESSION, true)
        . "_SERVER: " . print_r($_SERVER, true)
        . "\n\nSincerely,\nYour Server";
    
    $headers  = '';
    
    if($GLOBALS['errorDebugMode'])
        echo '<pre>'.$email."</pre> <br>\n";
    else
        mail("dustinpaystaxes@gmail.com", "[{$_SERVER['HTTP_HOST']}] $errstr", "$errstr\n\n\n$email", $headers);
}

function php_error_handler($errno, $errstr, $errfile, $errline, $errcontext)
{
    if(!($errno & (E_ALL & ~E_NOTICE)))
        return true;
    
    $dt = date("Y-m-d H:i:s (T)");
    
    $errortype = array (
                E_ERROR              => 'Error',
                E_WARNING            => 'Warning',
                E_PARSE              => 'Parsing Error',
                E_NOTICE             => 'Notice',
                E_CORE_ERROR         => 'Core Error',
                E_CORE_WARNING       => 'Core Warning',
                E_COMPILE_ERROR      => 'Compile Error',
                E_COMPILE_WARNING    => 'Compile Warning',
                E_USER_ERROR         => 'User Error',
                E_USER_WARNING       => 'User Warning',
                E_USER_NOTICE        => 'User Notice',
                E_STRICT             => 'Runtime Notice',
                E_RECOVERABLE_ERROR  => 'Catchable Fatal Error'
                );
    
    switch ($errno) {
    case E_ERROR:
        declare_error("<b>My ERROR</b> $dt [$errno: {$errortype[$errno]}] $errstr<br />\n
            Fatal error on line $errline in file $errfile\n
            Context: ".(!$GLOBALS['SECURITY_IS_IMPORTANT'] && !$GLOBALS['SECURITY_IS_IMPROTANT'] ? print_r($errcontext, true) : 'blocked'));
        break;

    case E_WARNING:
        declare_warning("<b>My WARNING</b> $dt [$errno: {$errortype[$errno]}] $errstr<br />\n
            Warning on line $errline in file $errfile\n
            Context: ".(!$GLOBALS['SECURITY_IS_IMPORTANT'] && !$GLOBALS['SECURITY_IS_IMPROTANT'] ? print_r($errcontext, true) : 'blocked'));
        return true;
        break;
    
    }

    declare_error("<b>Unknown ERROR</b> $dt [$errno: {$errortype[$errno]}] $errstr<br />\n
        Fatal error on line $errline in file $errfile\n
        Context: ".(!$GLOBALS['SECURITY_IS_IMPORTANT'] && !$GLOBALS['SECURITY_IS_IMPROTANT'] ? print_r($errcontext, true) : 'blocked'));
    
    /* Don't execute PHP internal error handler */
    return true;
}

set_error_handler("php_error_handler");

return;
?>
