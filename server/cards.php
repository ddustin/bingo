<head>
<style>
input[type=text] {
width: 75%;
}
form {
border: 1px solid black;
padding: 5px;
}
</style>
</head>
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

    $keys = array_keys($cards);

    $cards[0] = array("json" => json_decode('{
  "picture" : "<enter url>",
  "prizeName" : "<enter prize>",
  "prizeDescription" : "<enter description>",
  "name" : "<enter name>",
  "squares" : [
    
  ]
}'));

    $keys[] = 0;
    
    foreach($keys as $card_id) {
        $card = $cards[$card_id];
        echo "<h1>{$card["json"]->name}</h1>";
        ?>
<form action="edit_card.php">
<input type="hidden" name="card_id" value="<?php echo $card_id ?>"/>
<?php
    foreach($card["json"] as $key => $value) {
        
        if(!is_array($value))
            echo "$key <input type='text' name='json_$key' value='$value'/> <br/>\n";
        else {
            
            echo "<b>$key </b><br/>\n";
            
            for($i = 0; $i < 24 || $i < count($value); $i++)
                echo "* <input type='text' name='json_{$key}_$i' value='$value[$i]'/> <br/>\n";
        }
    }
    ?>
<input type="submit" /> <br/>
</form>
<?php
    }
?>
