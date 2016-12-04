import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: park

    property var name: ""
    property var location: ""
    property var price: 0

    property var zone: false
    property var mapColor: "#8d0"
    property var sound: "assets/lands/park/park.wav"
    property var boardImage: "assets/lands/park/park.png"

    property var placed: 0
    property var size: 1

    property var destroyable: true
    property var income: -1 * gameBoard.servicesMoney

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
