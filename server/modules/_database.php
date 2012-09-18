<?php
include_once("time.php");
include_once("error.php");

// A database connection...
class Database {
    var $link;
    var $lastResultResource = NULL;
    
    // Escapes a given SQL string, optionally adding quotes.
    // Returns the resulting string.
    function escape($str, $addQuotes = true)
    {
        if($str === NULL)
            return NULL;
        
        $str = mysql_real_escape_string($str, $this->link);
        
        if($addQuotes)
            return "'".$str."'";
        
        return $str;
    }
    
    // Runs a generic query, returning the result variable (of mysql_query).
    function query($query, $freakOutOnError = true)
    {
        $res = mysql_query($query, $this->link);
        
        $this->lastResultResource = $res;
        
        if($res === false) {
            
            if($freakOutOnError) {
                
                declare_error('A query failed: '.$query);
                
                die('Query failure.');
            }
            
            return false;
        }
        
        return $res;
    }
    
    // Returns the id of the insert statement
    function insert($query, $freakOutOnError = true)
    {
        $res = mysql_query($query, $this->link);
        
        $this->lastResultResource = $res;
        
        if($res === false) {
            
            if($freakOutOnError) {
                
                declare_error('A query failed: '.$query);
                
                die('Query failure.');
            }
            
            return false;
        }
        
        return mysql_insert_id();
    }
    
    // Returns the number of affected rows
    function delete($query, $freakOutOnError = true)
    {
        $res = mysql_query($query, $this->link);
        
        $this->lastResultResource = $res;
        
        if($res === false) {
            
            if($freakOutOnError) {
                
                declare_error('A query failed: '.$query);
                
                die('Query failure.');
            }
            
            return false;
        }
        
        return mysql_affected_rows();
    }
    
    function freeLastResult()
    {
        /*if($this->lastResultResource != NULL)
            mysql_free_result($this->lastResultResource);
        
        $this->lastResultResource = NULL;*/
    }
    
    // Returns the number of seconds until $sql_unsafe_time_statement according
    // to the database's clock.
    function getTimeFromNow($sql_unsafe_time_statement)
    {
        $query = "
            SELECT TIME_TO_SEC(TIMEDIFF(NOW(), ($sql_unsafe_time_statement)));
        ";
        
        $result = $this->query($query);
        
        $row = mysql_fetch_row($result);
        
        mysql_free_result($result);
        
        return intval($row[0]);
    }
    
    // Connects to the database!
    function Database()
    {
        include(dirname(__FILE__)."/database_info.php");
        
        /* database_info.php needs to set the following variables:
         * $mysql_server, $mysql_username, $mysql_password, $mysql_dbname
         */         
        
        $this->link = mysql_connect($mysql_server, $mysql_username, $mysql_password)
            or declare_error('Unable to connect to database.');
        
        mysql_select_db($mysql_dbname, $this->link)
            or declare_error('Unable to select database.');
        
        register_shutdown_function('databaseCleanup', $this);
        
        $offset = 8;
        
        // Is daylight savings?
        if(1 == date('I', time() - 3 * 360))
            $offset--;
        
        $query = "SET time_zone = '-0$offset:00'";
        
        $this->query($query);
        $this->freeLastResult();
    }
    
}

// This function should be called automatically.  You shouldn't
// need to call it explicitly
function databaseCleanup($database)
{
    mysql_close($database->link);
}

// Global (default) database object.
$database = new Database();

return;
?>
