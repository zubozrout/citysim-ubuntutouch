import QtQuick 2.3
import Ubuntu.Components 1.1
import QtMultimedia 5.0
import Ubuntu.Components.Popups 0.1

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
                property var active: false
                opacity: active ? 1 : 0.4

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        parent.active = !parent.active
                    }
                }

                onActiveChanged: {
                    mainView.muteSound = active;
                }
            }
            Text {
                text: mainView.muteSound ? "Sound muted" : "Sound active"
                font.pointSize: units.gu(2)
            }
        }
    }

    Text {
        id: menuHeader
        text: "Welcome to City Sim"
        font.pointSize: units.gu(4)
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

    Text {
        id: menuText
        text: "Please note this game is only a preview."
        font.pointSize: units.gu(2)
        color: UbuntuColors.darkAubergine
        anchors {
            margins: units.gu(2)
            top: menuStart.bottom
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
            // Save
            PopupUtils.open(Qt.resolvedUrl("Dialogue.qml"), parent, {
                title: "Error",
                text: "This functionality is not yet supported"
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
