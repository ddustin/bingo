<html>
<body>
<?php
    
    $show_id = intval($_REQUEST['show_id']);
    
    if(!$show_id) {
        
        ?>
<form>
Show id: <input type="text" name="show_id"/> <br/>
<input type="submit"/>
</form>
<?php
        
        exit;
    }
?>
