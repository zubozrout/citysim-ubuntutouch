import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: industrialZone

    property var baseDir: "assets/lands/industrial/"

    property var name: ""
    property var location: ""
    property var price: 0

    property var zone: "i"
    property var mapColor: gameBoard.industrialColor
    property var sound: baseDir + "zone.wav"
    property var boardImage: !populated ? baseDir + "industrial.png" : baseDir + buildings[currentBuilding].name

    property var placed: 0
    property var size: 1

    property var destroyable: true

    property var buildings: [ {"name" : "building_a.png"}, {"name" : "building_b.png"}, {"name" : "building_c.png"} ]
    property var currentBuilding: -1
    property var populated: false

    property var income: gameBoard.industrialTax

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
        id: industrialTimer
        interval: 15*dailyTimer.interval
        running: dailyTimer.running
        repeat: true
        onTriggered: {
            if(block.viable && gameBoard.remainingElectricity > 0 && gameBoard.remainingWater > 0) {
                var index = Math.floor(Math.random() * buildings.length);
                parent.currentBuilding = index;
                if(!parent.populated) {
                    parent.populated = true;
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
        gameBoard.industrialCount++;
    }

    Component.onDestruction: {
        gameBoard.industrialCount--;
        if(populated) {
            gameBoard.populatedIndustrialCount -= 1;
        }
    }

    onPopulatedChanged: {
        if(populated == false) {
            currentBuilding = -1;
            gameBoard.populatedIndustrialCount -= 1;
        }
        else {
            gameBoard.populatedIndustrialCount += 1;
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
