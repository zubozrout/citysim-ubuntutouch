import QtQuick 2.3
import Ubuntu.Components 1.1
import QtMultimedia 5.0
import Ubuntu.Components.Popups 0.1
import CitySim 1.0

Rectangle {
    anchors.fill: parent
    color: "transparent"

    Image {
        source: "assets/images/menu.jpg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        color: "transparent"
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        height: units.gu(3)

        Grid {
            id: toolsMenuGrid
            columns: children.length
            rows: 1
            spacing: 1

            verticalItemAlignment: Grid.AlignVCenter

            Image {
                source: "assets/icons/mute.png"
                opacity: mainView.muteSound ? 1 : 0.4

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mainView.muteSound = !mainView.muteSound
                    }
                }
            }

            Text {
                text: mainView.muteSound ? "Sound muted" : "Sound active"
            }
        }
    }

    Text {
        id: menuHeader
        text: "Welcome to City Sim"
        font.pointSize: units.gu(3)
        font.bold: true
        color: UbuntuColors.orange
        anchors {
            margins: units.gu(2)
            bottom: menuStart.top
            horizontalCenter: parent.horizontalCenter
        }
    }

    Button {
        id: menuStart
        text: gameHolder == null ? "Start Game" : "Continue the game"
        gradient: UbuntuColors.orangeGradient
        anchors {
            margins: units.gu(2)
            centerIn: parent
        }

        onClicked: {
            menu = false;
        }
    }

    Button {
        id: load
        visible: CitySim.canLoad && gameHolder == null
        text: "Load Game"
        gradient: UbuntuColors.orangeGradient
        anchors {
            margins: units.gu(2)
            top: menuStart.bottom
            horizontalCenter: parent.horizontalCenter
        }

        onClicked: {
            loadSavedGame = true;
            menu = false;
        }
    }

    Text {
        id: menuText
        text: "Please note this game is only a preview."
        color: UbuntuColors.darkAubergine
        anchors {
            margins: units.gu(2)
            top: load.visible ? load.bottom : menuStart.bottom
            horizontalCenter: parent.horizontalCenter
        }
    }

    Button {
        id: menuSave
        text: "Save the game"
        visible: mainView.gameHolder == null ? false : true
        gradient: UbuntuColors.greyGradient
        anchors {
            margins: units.gu(2)
            top: menuText.bottom
            horizontalCenter: parent.horizontalCenter
        }

        onClicked: {
            CitySim.save(mainView.gameHolder.gameBoard.toJson());

            // Save
            PopupUtils.open(Qt.resolvedUrl("Dialogue.qml"), parent, {
                title: "Saved",
                text: "You game has been saved!"
            })
        }
    }

    Button {
        id: menuShowViability
        text: mainView.gameHolder == null || mainView.gameHolder.showViability ? "Hide zone viability info" : "Show zone viability info"
        visible: mainView.gameHolder == null ? false : true
        gradient: UbuntuColors.greyGradient
        anchors {
            margins: units.gu(2)
            top: menuSave.bottom
            horizontalCenter: parent.horizontalCenter
        }

        onClicked: {
            mainView.gameHolder.showViability = !mainView.gameHolder.showViability;
        }
    }
}
