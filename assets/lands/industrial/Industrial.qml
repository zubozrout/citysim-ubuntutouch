import QtQuick 2.4
import QtMultimedia 5.0

Item {
    id: commercialZone
    
    property var baseDir: "../assets/lands/industrial/"
    property var objData: {
		"name": "Industrial zone",
		"location": null,
		"price": 100,
		"income": 5,
		"zone": "c",
		"mapColor": "#04a",
		"sound": baseDir + "zone.wav",
		"boardImage": "",
		"destroyable": true,
		"level": 0,
		"daysToSurvive": Math.random() * (200 - 10) + 10,
		"populated": false,
		"size": 1,
		"imageRotation": 0,
		"viabilitySource": false,
		"volume": 0.5,
		"supportsTimeStepUpdate": true
	}
    
    function getBuildings(level) {
		var levelOne = [
			{"name" : "building_a.png", "daysToSurvive": 365}
		];
		var levelTwo = [
			{"name" : "building_b.png", "daysToSurvive": 365 * 5}
		];
		var levelThree = [
			{"name" : "building_c.png", "daysToSurvive": 365 * 40}
		];
		switch(level) {
			case 1:
				return levelOne;
			case 2:
				return levelTwo;
			case 3:
				return levelThree;
		}
		return null;
	}
    
    function update(gameHolder, field) {
		if(objData.level === 0) {
			objData.boardImage = baseDir + "industrial.png";
			objData.imageRotation = 0;
		}
		
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
