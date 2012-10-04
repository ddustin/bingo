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
    
    foreach($cards as $card_id => $card) {
        ?>
<form action="edit_card.php">
<input type="hidden" name="card_id" value="$card_id"/>
<?php
    foreach($card["json"] as $key => $value) {
        
        if(!is_array($value))
            echo "$key <input type='text' name='json_$key' value='$value'/> <br/>\n";
        else {
            
            echo "<b>$key </b><br/>\n";
            
            for(int i = 0; i < 24; i++)
                echo '* <input type='text' name='json_{$key}_$i' value='$value[$i]'/> <br/>\n";
        }
    }
    ?>
</form>
<?php
    }
?>