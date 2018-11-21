import QtQuick 2.4
import QtMultimedia 5.0

Item {
    id: park
    
    property var objData: {
		"name": "Park",
		"location": null,
		"price": 100,
		"income": -5,
		"mapColor": "#8b0",
		"sound": "../assets/lands/park/park.wav",
		"boardImage": "../assets/lands/park/park.png",
		"destroyable": true,
		"level": -1,
		"size": 1,
		"imageRotation": -45,
		"volume": 0.5
	}    
    
    function update(gameHolder, field) {		
		if(!gameHolder.settings.muteSound) {
            player.stop();
            
            player.source = objData.sound;
            player.volume = objData.volume;
            player.play();
        }
	}
	
	Audio {
        id: player
    }
}
