import QtQuick 2.4
import Ubuntu.Components 1.3
import QtMultimedia 5.0

import "../scripts/logic.js" as Logic

Rectangle {
    id: gameBoardContainer
    anchors.fill: parent
    color: "#87ceeb"
    visible: menu ? false : true
    /*
    Timer {
        id: eventTimer
        interval: 500
        running: true
        repeat: true
        onTriggered: Logic.Game(gameBoard)
    }

    
    */
    
    Timer {
        id: dailyTimer
        interval: 1000
        running: parent.visible
        repeat: true
        triggeredOnStart: false
        onTriggered: {
			var gameHolder = Logic.gameHolder;
			var moneyAddition = 0;
			for(var x = 0; x < gameHolder.boardArray.length; x++) {
				for(var y = 0; y < gameHolder.boardArray[x].length; y++) {
					var holding = gameHolder.boardArray[x][y].holding;
					if(holding.objData) {
						if(holding.objData.supportsTimeStepUpdate) {
							gameHolder.timeStepUpdateForLand({
								x: x,
								y: y
							}, function(gameHolder, x, y) {
								gameHolder.boardArray[x][y].base.update();
							});
						}
						
						var populated = holding.objData.populated || null;
						var level = Number(holding.objData.level);
						var blockActive = level < 0 || level > 0 && populated;		
						if(blockActive) {
							var income = typeof holding.objData.income !== typeof undefined ? holding.objData.income : 0;
							moneyAddition += Number(income);
						}
						if(level > 0) {
							console.log(holding.objData.name, blockActive, populated, level, holding.objData.income);
						}
					}
				}
			}
			
			console.log("moneyAddition", moneyAddition);
			console.log("oldMoney", gameHolder.gameData.basics.money);
			gameHolder.gameData.basics.money += moneyAddition;
			
			Logic.gameHolder.callBack("new-day");
			Logic.gameHolder.callBack("money-update");
		}
		
		Component.onCompleted: {
			Logic.gameHolder.registerCallBack("new-day", Logic.gameHolder.newDay);
		}
    }
    
    Audio {
        id: musicPlayer
        source: "../assets/audio/ambient.ogg"
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
		/*
        showViability = CitySim.showViability;

        if(!muteSound) {
            musicPlayer.play();
        }
        */
    }
	
	/*
    onMuteSoundChanged: {
        if(muteSound) {
            musicPlayer.stop();
        }
        else {
            musicPlayer.play();
        }
    }
    */
	
    BottomToolbar {
        id: bottomToolBar
    }
    
    FlickableBoard {
		id: boardFlickable
		anchors {
			top: parent.top
			right: parent.right
			left: parent.left
			bottom: bottomToolBar.top
		}
	}
	
	Tools {
		id: rightToolBar
		anchors {
            bottom: bottomToolBar.top
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
        height: messageInfo.height + 10
        visible: messageInfo.text === "" ? false : true
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
            
            /*
            text: {
                gameBoard.remainingElectricity <= 0 ? "Build more Power Plants. People need electricity!" : "";
                gameBoard.remainingWater <= 0 ? "Build more Water Pumps. There is no water in the taps!" : "";
            }
            */
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

            text: "" //gameBoard.tool.name + " (" + gameBoard.tool.price + ")$";
        }
    }
}
