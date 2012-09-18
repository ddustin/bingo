<?php
    include_once(dirname(__FILE__)."/modules/seasons.php");
    
    $show_id = $_REQUEST["show_id"];
    
    $season_id = currentSeason($show_id);
    
    $season = loadSeason($season_id);
    $episodes = loadEpisodes($season_id);
    $bingoCards = loadBingoCards(loadCardIds($season_id));
    
    $result = array();
    
    $result["season"] = $season;
    $result["episdoes"] = $episodes;
    $result["bingoCards"] = $bingoCards;
?>
