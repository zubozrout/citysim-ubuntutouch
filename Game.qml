import QtQuick 2.3
import Ubuntu.Components 1.1
import QtMultimedia 5.0
import CitySim 1.0

import "logic.js" as Logic

Rectangle {
    id: container
    anchors.fill: parent
    color: "#87ceeb"
    visible: menu ? false : true

    property alias gameBoard: gameBoard
    property var showViability: false
    property var muteSound: mainView.muteSound

    onShowViabilityChanged: CitySim.showViability = showViability

    Timer {
        id: eventTimer
        interval: 500
        running: true
        repeat: true
        onTriggered: Logic.Game(gameBoard)
    }

    Timer {
        id: dailyTimer
        interval: 5000
        running: true
        repeat: true
        onTriggered: Logic.GameDaily(gameBoard)
    }

    Audio {
        id: musicPlayer
        source: "assets/audio/ambient.ogg"
        autoPlay: false
        loops: MediaPlayer.Infinite
        volume: 0.5
    }

    Audio {
        id: efectsPlayer
        autoPlay: false
        volume: 0.5
    }

    Component.onCompleted: {
        showViability = CitySim.showViability;

        if(!muteSound) {
            musicPlayer.play();
        }
    }

    onMuteSoundChanged: {
        if(muteSound) {
            musicPlayer.stop();
        }
        else {
            musicPlayer.play();
        }
    }

    Rectangle {
        id: rightToolBar
        anchors {
            bottom: bottomToolBar.top
            top: parent.top
            right: parent.right

            bottomMargin: -border.width
            topMargin: -border.width
            rightMargin: -border.width
        }
        width: units.gu(8)
        border.width: 1
        border.color: "#b6fbff"
        color: "#83a4d4"

        Tools {}
    }

    BottomToolbar {
        id: bottomToolBar
    }

    Flickable {
        id: boardFlickable
        anchors {
            top: parent.top
            right: rightToolBar.left
            left: parent.left
            bottom: bottomToolBar.top
        }
        contentHeight: Math.sqrt(dirt.width*dirt.width + dirt.height*dirt.height)*dirt.deform + width/10
        contentWidth: Math.sqrt(dirt.width*dirt.width + dirt.height*dirt.height) + width/10
        clip: true

        Rectangle {
            anchors.fill: parent
            color: "#33333333"
        }

        contentX: contentWidth/2
        contentY: contentHeight/2

        Rectangle {
            id: dirt
            width: 2048 + gameBoard.zoom
            height: 2048 + gameBoard.zoom
            anchors {
                centerIn: parent
            }

            rotation: 45

            property var deform: 0.5

            Image {
                anchors.fill: parent
                fillMode: Image.Tile
                horizontalAlignment: Image.AlignLeft
                verticalAlignment: Image.AlignTop
                source: "assets/images/dirt.png"
            }

            transform: Scale {origin.y: dirt.height*dirt.deform; yScale: dirt.deform }

            Rectangle {
                id: gameBoard
                anchors {
                    fill: parent
                    margins: 10
                    centerIn: parent
                }

                color: "#8a6"

                property var industrialColor: "#a50"
                property var commercialColor: "#04a"
                property var residentialColor: "#4a0"

                property var boardArray: []

                property var tool: null
                property int money: 30000
                property var population: 0
                property var date: new Date(1990, 1, 1);

                property var zoneCount: industrialCount + commercialCount + residentialCount
                property var industrialCount: 0
                property var commercialCount: 0
                property var residentialCount: 0

                property var populatedZoneCount: industrialCount + commercialCount + residentialCount
                property var populatedIndustrialCount: 0
                property var populatedCommercialCount: 0
                property var populatedResidentialCount: 0

                property var industrialDemand: populatedZoneCount == 0 ? 0 : (populatedCommercialCount + populatedResidentialCount) / (populatedZoneCount/100)
                property var commercialDemand: populatedZoneCount == 0 ? 0 : (populatedIndustrialCount + populatedResidentialCount) / (populatedZoneCount/100)
                property var residentialDemand: populatedZoneCount == 0 ? 0 : (populatedIndustrialCount + populatedCommercialCount) / (populatedZoneCount/100)

                property var industrialTax: 10
                property var commercialTax: 10
                property var residentialTax: 1

                property var fireMoney: 10
                property var policeMoney: 10
                property var schoolMoney: 10
                property var healthMoney: 10
                property var servicesMoney: 10
                property var transportMoney: 10

                property var income: 0

                property var zoom: boardFlickable.width

                property var empty: null

                property var electricity: 0
                property var water: 0

                property var remainingElectricity: electricity - populatedZoneCount
                property var remainingWater: water - populatedZoneCount

                onToolChanged: {
                    selectedTool.text = (tool == null ? "" : tool.name + " (" + tool.price + "$)");
                }

                MediaPlayer {
                    id: gridPlayer
                }

                Grid {
                    id: grid
                    columns: 32
                    rows: 32
                    spacing: 1

                    property var blockWidth: gameBoard.width/columns - spacing + spacing/columns
                    property var blockHeight: gameBoard.height/rows - spacing + spacing/rows
                    property var baseColor: "transparent"

                    Component.onCompleted: {
                        var blocks = new Array();
                        var components = new Array();

                        var fill = Qt.createComponent(encodeURIComponent("assets/lands/empty/Empty.qml"));
                        if(fill.status == Component.Ready) {
                            parent.empty = fill;
                            var id = 0;

                            for(var i = 0; i < columns; i++) {
                                blocks[i] = new Array();
                                components[i] = new Array();

                                for(var j = 0; j < rows; j++) {
                                    var block = Qt.createComponent("Block.qml");
                                    if(block.status == Component.Ready) {
                                        blocks[i].push(block.createObject(grid));
                                        blocks[i][j].xPos = i;
                                        blocks[i][j].yPos = j;
                                        components[i].push(fill.createObject(blocks[i][j]));
                                        blocks[i][j].holding = components[i][j];
                                        blocks[i][j].uniqueID = id;
                                    }
                                    id++;
                                }
                            }
                        }

                        gameBoard.boardArray = blocks;
                    }
                }

                function toJson() {
                    var board = [];

                    for (var i = 0; i < gameBoard.boardArray.length; i++) {
                        board[i] = [];

                        for (var j = 0; j < gameBoard.boardArray[i].length; j++) {
                            board[i][j] = {
                                location: gameBoard.boardArray[i][j].holding.location,
                                id: gameBoard.boardArray[i][j].uniqueID,
                                //TODO more here, each land should probably export their own json
                            };
                        }
                    }

                    return {
                        board: board,
                        money: money,
                        date: date.getTime()
                    }
                }
            }
        }
    }

    Rectangle {
        id: messageInfoText
        anchors {
            top: parent.top
            right: rightToolBar.left
            left: parent.left

            topMargin: -border.width
        }
        height: messageInfo.text == "" ? 0 : messageInfo.height + 10
        border.width: 1
        border.color: "#33001b"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ff0084" }
            GradientStop { position: 1.0; color: "#33001b" }
        }

        Text {
            id: messageInfo
            anchors {
                centerIn: parent
            }
            color: "#fff"

            text: {
                gameBoard.remainingElectricity <= 0 ? "Build more Power Plants. People need electricity!" :
                gameBoard.remainingWater <= 0 ? "Build more Water Pumps. There is no water in the taps!" : ""
            }
        }
    }

    Rectangle {
        id: selectedToolText
        anchors {
            top: messageInfoText.bottom
            right: rightToolBar.left

            topMargin: -border.width
            leftMargin: -border.width
            rightMargin: -border.width
        }
        width: selectedTool.text == "" ? 0 : selectedTool.width + 20
        height: selectedTool.height + 10
        border.width: 1
        border.color: "#3a97cd"
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#35c3f8" }
            GradientStop { position: 1.0; color: "#3a97cd" }
        }

        Text {
            id: selectedTool
            anchors {
                centerIn: parent
            }
            color: "#000"

            text: gameBoard.tool.name + " (" + gameBoard.tool.price + ")$";
        }
    }
}
