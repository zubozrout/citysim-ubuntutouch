import QtQuick 2.4
import QtMultimedia 5.0

Item {
    id: school
    
    property var objData: {
		"name": "School",
		"location": null,
		"price": 100,
		"income": -20,
		"mapColor": "#dd0",
		"sound": "../assets/lands/school/school.wav",
		"boardImage": "../assets/lands/school/school.png",
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
