import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: road
    
    property var objData: {
		"name": "Road block",
		"location": null,
		"price": 10,
		"income": -1,
		"zone": false,
		"mapColor": "#333",
		"sound": "../assets/lands/road/construction.wav",
		"noise": "../assets/lands/grass/bird.wav",
		"boardImage": "../assets/lands/road/road_crossing.png",
		"replacable": false,
		"destroyable": true,
		"level": -1,
		"size": 1,
		"imageRotation": 0,
		"viabilitySource": true,
		"volume": 0.5
	}
	
    function getFieldDetails(gameHolder, x, y) {
		var field = {};
		var obj = gameHolder.getObjectOnPosition(x, y);
		if(obj) {
			field.exists = true;
			field.holding = obj.holding;
			if(field.holding && field.holding.objData && field.holding.objData.name === road.objData.name) {
				field.road = true;
			}
		}
		else {
			field.exists = false;
		}
		return field;
	}

    function update(gameHolder, field) {
		var holding = gameHolder.boardArray[field.x][field.y].holding;
		
		var top = getFieldDetails(gameHolder, field.x - 1, field.y);
		var right = getFieldDetails(gameHolder, field.x, field.y + 1);
		var bottom = getFieldDetails(gameHolder, field.x + 1, field.y);
		var left = getFieldDetails(gameHolder, field.x, field.y - 1);
		
		var onTop = top.exists && top.road || !top.exists;
		var onRight = right.exists && right.road || !right.exists;
		var onBottom = bottom.exists && bottom.road || !bottom.exists;
		var onLeft = left.exists && left.road || !left.exists;
		
		if(onTop && onRight && onBottom && onLeft || !onTop && !onRight && !onBottom && !onLeft) {
			holding.objData.boardImage = "../assets/lands/road/road_crossing.png";
		}
		else if(onTop && onRight && onBottom) {
			holding.objData.boardImage = "../assets/lands/road/road_crossing_right.png";
		}
		else if(onTop && onRight && onLeft) {
			holding.objData.boardImage = "../assets/lands/road/road_crossing_top.png";
		}
		else if(onTop && onBottom && onLeft) {
			holding.objData.boardImage = "../assets/lands/road/road_crossing_left.png";
		}
		else if(onRight && onBottom && onLeft) {
			holding.objData.boardImage = "../assets/lands/road/road_crossing_bottom.png";
		}
		else if(onTop && onRight) {
			holding.objData.boardImage = "../assets/lands/road/road_top_right.png";
		}
		else if(onTop && onBottom) {
			holding.objData.boardImage = "../assets/lands/road/road_vertical.png";
		}
		else if(onTop && onLeft) {
			holding.objData.boardImage = "../assets/lands/road/road_top_left.png";
		}
		else if(onRight && onBottom) {
			holding.objData.boardImage = "../assets/lands/road/road_bottom_right.png";
		}
		else if(onRight && onLeft) {
			holding.objData.boardImage = "../assets/lands/road/road_horizontal.png";
		}
		else if(onBottom && onLeft) {
			holding.objData.boardImage = "../assets/lands/road/road_bottom_left.png";
		}
		else if(onTop) {
			holding.objData.boardImage = "../assets/lands/road/end_bottom.png";
		}
		else if(onRight) {
			holding.objData.boardImage = "../assets/lands/road/end_left.png";
		}
		else if(onBottom) {
			holding.objData.boardImage = "../assets/lands/road/end_top.png";
		}
		else if(onLeft) {
			holding.objData.boardImage = "../assets/lands/road/end_right.png";
		}
		else {
			holding.objData.boardImage = "../assets/lands/road/road_crossing.png";
		}
				
		gameHolder.boardArray[field.x][field.y].holding = holding;
		road.objData.boardImage = holding.objData.boardImage || "";
		
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
