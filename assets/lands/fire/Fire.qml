import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: firestation

    property var name: ""
    property var location: ""
    property var price: 0

    property var zone: false
    property var mapColor: "#d00"
    property var sound: "assets/lands/fire/fire.wav"
    property var boardImage: "assets/lands/fire/fire.png"

    property var size: 1

    property var placed: 0

    property var destroyable: true
    property var income: -1 * gameBoard.fireMoney

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
}
