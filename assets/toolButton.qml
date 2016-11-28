import QtQuick 2.3
import Ubuntu.Components 1.1
import QtMultimedia 5.0

import "logic.js" as Logic

Rectangle {
    id: toolButton
    width: parent.width
    height: width/(3/2)
    radius: height/3

    gradient: Gradient {
        GradientStop { position: 0.0; color: (gameBoard.tool != null && gameBoard.tool.location == location) ? "#fff" : btnColor /*"#dfdfef"*/ }
        GradientStop { position: 1.0; color: "#fff" }
    }

    border.width: 1
    border.color: (gameBoard.tool != null && gameBoard.tool.location == location) ? "#38d" : "#fff"

    property var location: ""
    property var btnColor: "#fff"
    property var price: 0
    property var image: ""
    property var name: ""
    property var remove: false
    property var alternative: false

    Image {
        anchors.fill: parent
        source: parent.image
        fillMode: Image.PreserveAspectFit

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(gameBoard.tool == toolButton) {
                    gameBoard.tool = null;
                }
                else {
                    gameBoard.tool = toolButton;
                }

                if(!container.muteSound) {
                    sound.play();
                }
            }
        }
    }

    SoundEffect {
        id: sound
        source: "assets/audio/click.wav"
    }
}

