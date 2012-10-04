<?php
    include_once(dirname(__FILE__)."/database.php");
    
    /******* Functions *********
     
     allCards(show_id)
     // Returns all the data for all cards
     // The format is an array of hash tables. Each hash table has two keys:
     // "id" => the bingo_card_id
     // "json" => the bingo card json decoded into a php object
     // 
     // On error or no matches, returns an empty array.
    */
    
    function allCards($show_id) {
        
        global $database;
        
        $show_id = intval($show_id);
        
        $query = "select `id`, `json` from `bingo_card` where `show_id` = $show_id limit 1000";
        
        $res = $database->query($query);
        
        $results = array();
        
        while($row = mysql_fetch_row($res))
            $results[] = array("id" => $row[0], "json" => json_decode($row[1]));
        
        return $results;
    }
?>