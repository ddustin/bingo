<?php
    include(dirname(__FILE__)."/modules/cards.php");
    
    $card_id = intval($_REQUEST['card_id']);
    
    $json = array();
    
    foreach($_REQUEST as $key => $value) {
        
        if(strpos($key, "json_") === 0) {
            
            $jsonKey = substr($key, strlen("json_"));
            
            if(strpos($jsonKey, "squares_") === 0) {
                
                $i = substr($jsonKey, strlen("squares_"));
                
                $ary = $json["squares"];
                
                if(!$ary)
                    $ary = array();
                
                $ary[$i] = $value;
            }
            else
                $json[$jsonKey] = $value;
        }
    }
    
    echo json_decode(array("id" => $json));
?>