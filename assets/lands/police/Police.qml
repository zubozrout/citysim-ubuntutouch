import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: police

    property var name: ""
    property var location: ""
    property var price: 0

    property var zone: false
    property var mapColor: "#00d"
    property var sound: "assets/lands/police/police.wav"
    property var boardImage: "assets/lands/police/police.png"

    property var size: 2

    property var placed: 0

    property var destroyable: true
    property var income: -1 * gameBoard.policeMoney

    property var imageRotation: -45

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

    function toJson() {
        return {
            location: location,
        };
    }

    function fromJson(json) {
        location = json.location;
    }
}
