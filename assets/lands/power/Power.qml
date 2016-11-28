import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: powerPlant

    property var name: ""
    property var location: ""
    property var price: 0

    property var zone: false
    property var mapColor: "#dd0"
    property var sound: "assets/lands/power/power_plant.ogg"
    property var boardImage: "assets/lands/power/power.png"

    property var placed: 0
    property var size: 2
    property var electricity: viable ? maxElectricity : 0
    property var maxElectricity: 80
    property var prevElectricity: 0
    property var viable: false
    property var viability: []
    property var viabilityModifier: 0

    property var destroyable: true
    property var income: -1 * gameBoard.servicesMoney

    property var imageRotation: -45

    property var usableInfo: "This power plant can suply up to " + electricity + " zones with electricity"

    onPlacedChanged: {
        if(!container.muteSound) {
            player.stop();
            player.play();
        }
    }

    onViabilityModifierChanged: {
        if(viability.indexOf(true) > 0) {
            viable = true;
        }
        else {
            viable = false;
        }
    }

    Audio {
        id: player
        source: sound
    }

    Component.onCompleted: {
        if(prevElectricity != electricity) {
            prevElectricity = electricity;
            if(electricity > 0) {
                gameBoard.electricity += electricity;
            }
        }
    }

    Component.onDestruction: {
        if(electricity > 0) {
            gameBoard.electricity -= maxElectricity;
        }
    }

    onElectricityChanged: {
        if(prevElectricity != electricity) {
            prevElectricity = electricity;

            if(electricity > 0) {
                gameBoard.electricity += electricity;
            }
            else {
                gameBoard.electricity -= maxElectricity;
            }
        }
    }
}
