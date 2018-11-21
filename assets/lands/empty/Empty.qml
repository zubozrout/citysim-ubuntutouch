import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: grass
    
    property var baseDir: "../assets/lands/empty/"
    property var trees: ["shrub2-02.png", "pine-none08.png", "pine-none01.png", "bigtree03.png", "shrub2-01.png", "pine-none07.png", "palm06.png", "bigtree02.png", "tropical05.png", "shrub1-05.png", "pine-none06.png", "palm05.png", "bigtree01.png", "tropical04.png", "shrub1-04.png", "pine-none05.png", "palm04.png", "hemp03.png", "shrub2-05.png", "shrub1-03.png", "pine-none04.png", "palm03.png", "hemp02.png", "shrub2-04.png", "shrub1-02.png", "pine-none03.png", "palm02.png", "hemp01.png", "shrub2-03.png", "shrub1-01.png", "pine-none02.png", "palm01.png", "bush01.png"]
    
    property var objData: {
		"name": null,
		"location": baseDir + "Empty.qml",
		"price": 10,
		"zone": false,
		"mapColor": "#333",
		"sound": "../assets/lands/road/construction.wav",
		"noise": baseDir + "bird.wav",
		"initial": true,
		"boardImage": null,
		"replacable": false,
		"destroyable": false,
		"level": -1,
		"size": 1,
		"imageRotation": -45,
		"viabilitySource": false,
		"volume": 0.5
	}
	
    function start() {
		if(Math.random() >= 0.5) {
            objData.boardImage = baseDir + "trees/" + trees[Math.floor(Math.random() * trees.length)];
            objData.destroyable = true;
            objData.name = "Forest";
        }
        else {
            objData.boardImage = null;
            objData.destroyable = false;
            objData.name = "Empty land";
        }
 	}
}
