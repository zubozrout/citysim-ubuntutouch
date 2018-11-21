import QtQuick 2.4
import QtMultimedia 5.0

Item {
    id: fire
    
    property var objData: {
		"name": "Fire station",
		"location": null,
		"price": 100,
		"income": -20,
		"mapColor": "#d00",
		"sound": "../assets/lands/fire/fire.wav",
		"boardImage": "../assets/lands/fire/fire.png",
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
