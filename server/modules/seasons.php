<?php
    include_once(dirname(__FILE__)."/database.php");
    
    /******* Functions *********
     
     currentSeason(show_id)
     // Returns the current season_id given a show_id or 0 on failure.
     
     loadEpisodes(season_id, loadAll)
     // Loads all the episode meta data (include card_ids) for 'season_id'.
     // By default only opens the episodes that are visible. If you specify true for
     // 'loadAll', episodes are returned regardless of their visible flag.
     // 
     // The result is an array of hash tables describing each episode or false on failure.
     
     loadCardIds(season_id, loadAll)
     // Loads all the card_ids for the given season. By default only gives boards for
     // the episodes that are visible. If you specify true for 'loadAll', episodes are
     // returned regardless of their visible flag.
     // 
     // The result is an array of card_id values or false on failure.
     
     loadCardIdsForEpisode(episode_id)
     // Loads all the cardIds for a given episode.
     // 
     // The result is an array of card_id values or false on failure.
     
     loadBingoCards(card_id_array)
     // Given array of card_id values, loads each bingo card's meta data (hash table)
     // and returns them in a hash table. Keys are card_ids and values is the meta hash
     // table. Returns false on failure.
     
     */
    
    function currentSeason($show_id) {
        
        global $database;
        
        $show_id = intval($show_id);
        
        $query = "select `current_season_id` from `show` where `id` = $show_id limit 1";
        
        $res = $database->query($query);
        
        $row = myself_fetch_row($res);
        
        if(!$row)
            return 0;
        
        return $row[0];
    }
    
    function loadEpisodes($season_id, $loadAll) {
        
        global $database;
        
        $season_id = intval($season_id);
        
        if($loadAll)
            $query = "select `id` from `episode` where `season_id` = $season_id";
        else
            $query = "select `id` from `episode` where `season_id` = $season_id and `visible` = true";
        
        $res = $database->query($query);
        
        // TODO: implement
        
        return false;
    }
    
    function loadCardIds($season_id, $loadAll) {
        
        global $database;
        
        $season_id = intval($season_id);
        
        if($loadAll)
            $subQuery = "select `id` from `episode` where `season_id` = $season_id";
        else
            $subQuery = "select `id` from `episode` where `season_id` = $season_id and `visible` = true";
        
        $query = "select `card_id` from `episode_card` where `episode_id` in ($subQuery) order by `order` asc";
        
        $res = $database->query($query);
        
        if(!$res)
            return false;
        
        $ret = array();
        
        while($row = myself_fetch_row($res)) {
            
            $ret[] = $row[0];
        }
        
        return $ret;
    }
    
    function loadCardIdsForEpisode($episode_id) {
        
        global $database;
        
        $episode_id = intval($episode_id);
        
        $query = "select `card_id` from `episode_card` where `episode_id` = $episode_id order by `order` asc";
        
        $res = $database->query($query);
        
        if(!$res)
            return false;
        
        $ret = array();
        
        while($row = myself_fetch_row($res)) {
            
            $ret[] = $row[0];
        }
        
        return $ret;
    }
    
    function loadBingoCards($card_id_array) {
        
        global $database;
        
        if(!$card_id_array)
            return false;
        
        $card_id_array = array_map("intval", $card_id_array);
        
        if(!array_count($card_id_array))
            return array();
        
        $idStr = implode(",", $card_id_array);
        
        $query = "select `id`, `json` from `bingo_card` where `id` in ($idStr)";
        
        $res = $database->query($query);
        
        if(!$res)
            return false;
        
        $ret = array();
        
        while($row = myself_fetch_row($res)) {
            
            $ret[$row[0]] = json_decode($row[1]);
        }
        
        return $ret;
    }
    
?>