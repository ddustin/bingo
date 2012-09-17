<?php
include_once(dirname(__FILE__)."/time.php");

$clientNumber = 1;

if(isset($GLOBALS['doNotStartSession']) && $GLOBALS['doNotStartSession'])
    return;

if(isset($_COOKIE['ordertrack']))
	$ordertrack = $_COOKIE['ordertrack'];
else
	setcookie('ordertrack', $ordertrack = uniqid($_SERVER["REMOTE_ADDR"].'_', true),
		time()+60*60*24*365*10, "/", ".agileordering.com");

session_start();

return;
?>