import QtQuick 2.3
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.1
import QtMultimedia 5.0

import "logic.js" as Logic

Rectangle {
    id: bottomToolBar
    anchors {
        bottom: parent.bottom
        left: parent.left
        right: parent.right

        bottomMargin: -border.width
        leftMargin: -border.width
        rightMargin: -border.width
    }
    height: units.gu(6)
    border.width: 1
    border.color: "#3a97cd"
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#35c3f8" }
        GradientStop { position: 1.0; color: "#3a97cd" }
    }

    Rectangle {
        id: demandWrapper
        width: units.gu(10)
        anchors {
            margins: 8
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        color: "#fff"

        Grid {
            id: demand
            columns: 3
            rows: 1
            spacing: 2
            anchors {
                margins: 2
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            clip: true

            verticalItemAlignment: Grid.AlignBottom

            Rectangle {
                id: industry
                property var value: gameBoard.industrialDemand * (demandWrapper.height - demandWrapper.anchors.margins/2)/100

                color: gameBoard.industrialColor
                width: parent.width/3 - parent.spacing
                height: value < 5 ? 5 : value //Don't let the parent box look empty
            }

            Rectangle {
                id: commerce
                property var value: gameBoard.commercialDemand * (demandWrapper.height - demandWrapper.anchors.margins/2)/100

                color: gameBoard.commercialColor
                width: parent.width/3
                height: value < 5 ? 5 : value
            }

            Rectangle {
                id: residential
                property var value: gameBoard.residentialDemand * (demandWrapper.height - demandWrapper.anchors.margins/2)/100

                color: gameBoard.residentialColor
                width: parent.width/3 - parent.spacing
                height: value < 5 ? 5 : value
            }
        }
    }

    Rectangle {
        id: zoomOut
        anchors {
            margins: 8
            left: demandWrapper.right
            top: parent.top;
            bottom: parent.bottom
        }

        width: height
        color: "#fff"
        radius: height/3

        Image {
            anchors {
                margins: 2
                fill: parent
            }
            fillMode: Image.PreserveAspectFit
            source: "assets/icons/zoom_out.svg"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(gameBoard.width > container.width && gameBoard.height > container.height) {
                    gameBoard.zoom -= 600;
                    if(!container.muteSound) {
                        zoomoutSound.play();
                    }
                }
            }
        }

        SoundEffect {
            id: zoomoutSound
            source: "assets/audio/zoom.wav"
        }
    }

    Rectangle {
        id: zoomIn
        anchors {
            margins: 8
            left: zoomOut.right
            top: parent.top;
            bottom: parent.bottom
        }

        width: height
        color: "#fff"
        radius: height/3

        Image {
            anchors {
                margins: 2
                fill: parent
            }
            fillMode: Image.PreserveAspectFit
            source: "assets/icons/zoom_in.svg"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(gameBoard.width < 12*container.width && gameBoard.height < 12*container.height) {
                    gameBoard.zoom += 600;
                    if(!container.muteSound) {
                        zoominSound.play();
                    }
                }
            }
        }

        SoundEffect {
            id: zoominSound
            source: "assets/audio/zoom.wav"
        }
    }

    Rectangle {
        id: dateButtons
        color: "transparent"
        radius: height/3

        anchors {
            margins: 8
            left: zoomIn.right
            top: parent.top;
            bottom: parent.bottom
        }

        width: dateGo.width + datePause.width

        property var running: dailyTimer.running

        Image {
            id: dateGo
            anchors {
                top: parent.top;
                bottom: parent.bottom
                left: parent.left
            }
            width: height;
            fillMode: Image.PreserveAspectFit
            source: parent.running ? "assets/icons/play.svg" : "assets/icons/play_inactive.svg"
        }

        Image {
            id: datePause
            anchors {
                top: parent.top;
                bottom: parent.bottom
                right: parent.right
            }
            width: height;
            fillMode: Image.PreserveAspectFit
            source: parent.running ? "assets/icons/stop_inactive.svg" : "assets/icons/stop.svg"
        }


        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(dailyTimer.running) {
                    eventTimer.stop();
                    dailyTimer.stop();
                }
                else {
                    eventTimer.start();
                    dailyTimer.start();
                }
                if(!container.muteSound) {
                    dateButtonsSound.play();
                }
            }
        }

        SoundEffect {
            id: dateButtonsSound
            source: "assets/audio/click.wav"
        }
    }

    ColumnLayout {
        spacing: 1
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: menuButton.left
            rightMargin: 10
        }

        Text {
            id: dateTag
            text: ("0" + gameBoard.date.getDate()).slice(-2) + "/" + ("0" + gameBoard.date.getMonth()).slice(-2) + "/" + gameBoard.date.getFullYear()
            color: "#fff"
            font.pointSize: units.gu(1)

            Layout.fillWidth: true
        }

        Text {
            id: populationTag
            text: "Pop: " + gameBoard.population
            color: "#46d"
            font.pointSize: units.gu(1)

            Layout.fillWidth: true
        }

        Text {
            id: moneyTag
            text: "$" + gameBoard.money
            color: gameBoard.money < 0 ? "#d00" : "#333"
            font.pointSize: units.gu(1)

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    gameBoard.money += 1000;
                }
            }

            Layout.fillWidth: true
        }
    }

    Icon {
        id: menuButton
        width: height
        height: parent.height * 0.75
        name: "settings"
        color: "#fff"

        anchors {
            margins: 10
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                menu = true;
            }
        }
    }
}
