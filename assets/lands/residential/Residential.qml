import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: residentialZone

    property var baseDir: "assets/lands/residential/"

    property var name: ""
    property var location: ""
    property var price: 0

    property var zone: "r"
    property var mapColor: gameBoard.residentialColor
    property var sound: baseDir + "zone.wav"
    property var boardImage: !populated ? baseDir + "residential.png" : baseDir + buildings[currentBuilding].name

    property var placed: 0
    property var size: 1

    property var destroyable: true

    property var buildings: [ {"name" : "building_a.png", "pop" : 80}, {"name" : "building_b.png", "pop" : 240}, {"name" : "building_c.png", "pop" : 110}, {"name" : "building_d.png", "pop" : 200} ]
    property var currentBuilding: -1
    property var population: currentBuilding == -1 ? 0 : Number(buildings[currentBuilding].pop)
    property var populated: false

    property var income: gameBoard.residentialTax

    property var imageRotation: populated ? -45 : 0

    onPlacedChanged: {
        if(!container.muteSound) {
            player.stop();
            player.play();
        }
    }

    Audio {
        id: player
        source: sound
    }

    Timer {
        id: residentialTimer
        interval: 15*dailyTimer.interval
        running: dailyTimer.running
        repeat: true
        onTriggered: {
            if(block.viable && gameBoard.remainingElectricity > 0 && gameBoard.remainingWater > 0) {
                var index = Math.floor(Math.random() * buildings.length);
                if(parent.currentBuilding != index) {
                    gameBoard.population -= parent.population;
                    parent.currentBuilding = index;
                    gameBoard.population += parent.population;
                    if(!parent.populated) {
                        parent.populated = true;
                    }
                }
                interval = (Math.floor(Math.random() * (60 - 15 + 1)) + 15)*dailyTimer.interval;
            }
            else {
                if(parent.populated) {
                    parent.populated = false;
                }
            }
        }
    }

    Component.onCompleted: {
        gameBoard.residentialCount++;
    }

    Component.onDestruction: {
        gameBoard.residentialCount--;
        if(populated) {
            gameBoard.populatedResidentialCount -= 1;
        }
    }

    onPopulatedChanged: {
        if(populated == false) {
            gameBoard.population -= parent.population;
            currentBuilding = -1;
            gameBoard.populatedResidentialCount -= 1;
        }
        else {
            gameBoard.populatedResidentialCount += 1;
        }
    }

    function toJson() {
        return {
            currentBuilding: currentBuilding,
            populated: populated,
            location: location,
        };
    }

    function fromJson(json) {
        currentBuilding = json.currentBuilding;
        populated = json.populated;
        location = json.location;
    }
}
