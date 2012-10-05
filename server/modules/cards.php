<?php
    include_once(dirname(__FILE__)."/database.php");
    
    /******* Functions *********
     
     allCards(show_id)
     // Returns all the data for all cards
     // The format is a hash table, keys are bingo_card_id integers while
     // values are hash table with one key, "json" which refers to the card's
     // json data parsed into a php object.
     // 
     // On error or no matches, returns an empty array.
     
     updateCard(card_id, json)
     // Updates 'card_id' to have to given json. 'json' is a php object that will
     // be json encoded when sent to the database.
     //
     // A card_id of 0 will instead insert a new card.
     //
     // Returns the card_id if it did an insert.
    */
    
    function allCards($show_id) {
        
        global $database;
        
        $show_id = intval($show_id);
        
        $query = "select `id`, `json` from `bingo_card` where `show_id` = $show_id limit 1000";
        
        $res = $database->query($query);
        
        $results = array();
        
        while($row = mysql_fetch_row($res))
            $results[$row[0]] = array("json" => json_decode($row[1]));
        
        return $results;
    }
    
    function updateCard($show_id, $card_id, $json) {
        
        global $database;
        
        $show_id = intval($show_id);
        $card_id = intval($card_id);
        $json = $database->escape(json_encode($json));
        
        if($card_id)
            $query = "update `bingo_card` set `show_id`=$show_id, `json`=$json where `id`=$card_id limit 1";
        else
            $query = "insert into `bingo_card` (`show_id`, `json`) values ($show_id, $json)";
        
        return $database->insert($query);
    }
?>
