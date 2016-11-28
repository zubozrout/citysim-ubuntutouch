import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: school

    property var name: ""
    property var location: ""
    property var price: 0

    property var zone: false
    property var mapColor: "#da4"
    property var sound: "assets/lands/school/school.wav"
    property var boardImage: "assets/lands/school/school.png"

    property var size: 1

    property var placed: 0

    property var destroyable: true

    property var income: -1 * gameBoard.schoolMoney

    property var imageRotation: -45

    onPlacedChanged: {
        if(!container.muteSound) {
            player.stop();
            player.play();
        }
    }

    Audio {
        id: player
        source: school.sound
    }
}

