import QtQuick 2.4
import Ubuntu.Components 1.3
import QtMultimedia 5.0
import Ubuntu.Components.Popups 1.3
import CitySim 1.0

import "../scripts/logic.js" as Logic

Rectangle {
    anchors.fill: parent
    color: "transparent"

    Image {
        source: "../assets/images/menu.jpg"
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
                source: "../assets/icons/mute.png"
                opacity: 1

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
						if(Logic.gameHolder) {
							var stateMuted = Logic.gameHolder.settings.muteSound;
							Logic.gameHolder.settings.muteSound = !stateMuted;
							
							if(stateMuted) {
								parent.opacity = 1;
							}
							else {
								parent.opacity = 0.5;
							}
						}
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
            bottom: menuNewGame.top
            horizontalCenter: parent.horizontalCenter
        }
    }

    Button {
        id: menuNewGame
        text: "New Game"
        gradient: UbuntuColors.orangeGradient
        anchors {
            margins: units.gu(2)
            centerIn: parent
        }

        onClicked: {
			gameItem.createGame(function(gameHolder) {
				if(gameHolder.gameBoard) {
					gameHolder.reset();
					gameHolder.gameBoard.startGame();
					mainView.menu = false;
				}
			});
        }
    }

    Button {
        id: load
        visible: true
        text: "Load Game"
        gradient: UbuntuColors.orangeGradient
        anchors {
            margins: units.gu(2)
            top: menuNewGame.bottom
            horizontalCenter: parent.horizontalCenter
        }

        onClicked: {
			var savedGame = CitySim.load();
			if(savedGame) {
				gameItem.createGame(function(gameHolder) {
					if(gameHolder.gameBoard) {
						gameHolder.fromJson(savedGame);
						gameHolder.gameBoard.startGame();
						mainView.menu = false;
					}
				});
			}
        }
    }

    Text {
        id: menuText
        text: "Please note this game is only a preview."
        color: UbuntuColors.darkAubergine
        anchors {
            margins: units.gu(2)
            top: load.visible ? load.bottom : menuNewGame.bottom
            horizontalCenter: parent.horizontalCenter
        }
    }

    Button {
        id: menuSave
        text: "Save the game"
        visible: true
        gradient: UbuntuColors.greyGradient
        anchors {
            margins: units.gu(2)
            top: menuText.bottom
            horizontalCenter: parent.horizontalCenter
        }

        onClicked: {
            CitySim.save(Logic.gameHolder.toJson());

            // Save
            PopupUtils.open(Qt.resolvedUrl("Dialogue.qml"), parent, {
                title: "Saved",
                text: "You game has been saved!"
            })
        }
    }

    Button {
        id: menuShowViability
        text: Logic.gameHolder === null || mainView.gameHolder.showViability ? "Hide zone viability info" : "Show zone viability info"
        visible: Logic.gameHolder === null ? false : true
        gradient: UbuntuColors.greyGradient
        anchors {
            margins: units.gu(2)
            top: menuSave.bottom
            horizontalCenter: parent.horizontalCenter
        }

        onClicked: {
            Logic.gameHolder.props.showViability = !Logic.gameHolder.props.showViability;
        }
    }
}
