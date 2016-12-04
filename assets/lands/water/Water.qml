import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: waterPump

    property var name: ""
    property var location: ""
    property var price: 0

    property var mapColor: "#acf"
    property var sound: "assets/lands/water/water.wav"
    property var boardImage: "assets/lands/water/pump.png"
    property var zone: false

    property var placed: 0
    property var size: 1
    property var water: block.viable && gameBoard.remainingElectricity > 0 ? maxWater : 0
    property var maxWater: 30
    property var prevWater: 0

    property var destroyable: true
    property var income: -1 * gameBoard.servicesMoney

    property var imageRotation: -45

    property var usableInfo: "This water pump can suply up to " + water + " zones with water"

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

    Component.onCompleted: {
        if(prevWater != water) {
            prevWater = water;
            if(water > 0) {
                gameBoard.water += water;
            }
        }
    }

    Component.onDestruction: {
        if(water > 0) {
            gameBoard.water -= maxWater;
        }
    }

    onWaterChanged: {
        if(prevWater != water) {
            prevWater = water;

            if(water > 0) {
                gameBoard.water += water;
            }
            else {
                gameBoard.water -= maxWater;
            }
        }
    }

    function toJson() {
        return {
            location: location,
        };
    }

    function fromJson(json) {
        location = json.location;
    }
}
