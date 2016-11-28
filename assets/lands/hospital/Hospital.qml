import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: hospital

    property var name: ""
    property var location: ""
    property var price: 0

    property var zone: false
    property var mapColor: "#d00"
    property var sound: "assets/lands/hospital/hospital.wav"
    property var boardImage: "assets/lands/hospital/hospital.png"

    property var size: 1

    property var placed: 0

    property var destroyable: true
    property var income: -1 * gameBoard.healthMoney

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
