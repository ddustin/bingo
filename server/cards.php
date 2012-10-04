<?php
    include(dirname(__FILE__)."/modules/cards.php");
    
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
    
    $cards = allCards($show_id);
    
    echo "<pre>";
    print_r($cards);
?>

