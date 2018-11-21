import QtQuick 2.4
import Ubuntu.Components.Popups 1.3
import QtMultimedia 5.0
import CitySim 1.0

import "../scripts/logic.js" as Logic

Rectangle {
	id: gameBoard
	anchors {
		fill: parent
		margins: 10
		centerIn: parent
	}

	color: "#8a6"
	
	Component.onCompleted: {
		Logic.gameHolder.registerGameBoard(gameBoard);
	}
	
	function startGame() {
		var gameHolder = Logic.gameHolder;
		var newGame = false;
		if(gameHolder.boardArray.length === 0) {
			for(var x = 0; x < gameHolder.props.rows; x++) {
				gameHolder.boardArray[x] = [];
				for(var y = 0; y < gameHolder.props.columns; y++) {
					gameHolder.boardArray[x][y] = {};
				}
			}
			newGame = true;
		}
					
		var id = 0;
		var blockCallBackNames = [];
				
		for(var x = 0; x < gameHolder.boardArray.length; x++) {
			for(var y = 0; y < gameHolder.boardArray[x].length; y++) {				
				var fillEmptyComponent = Qt.createComponent(encodeURIComponent("../assets/lands/empty/Empty.qml"));
				if(fillEmptyComponent.status === Component.Ready) {
					var blockComponent = Qt.createComponent("Block.qml");
					if(blockComponent.status === Component.Ready) {
						var blockBase = blockComponent.createObject(gameGrid);
						blockBase.xPos = x;
						blockBase.yPos = y;
						
						var fill = null;
						
						if(!newGame) {
							var itemData = gameHolder.boardArray[x][y];							
							if(itemData.holding.objData.location) {
								var fillSavedComponent = Qt.createComponent(encodeURIComponent(itemData.holding.objData.location));
								if(fillSavedComponent.status === Component.Ready) {
									fill = fillSavedComponent.createObject(blockBase);
									fill.objData = itemData.holding.objData;
								}
								else {
									console.log(fillSavedComponent.errorString());
								}
							}
						}
						else {
							fill = fillEmptyComponent.createObject(blockBase);
						}
						
						var block = {
							base: blockBase,
							holding: fill,
							uniqueID: id
						};
						gameHolder.boardArray[x][y] = block;
						
						if(fill && fill.start) {
							fill.start();
						}
												
						var callBackName = "block-" + x + "-" + y;
						gameHolder.registerCallBack(callBackName, blockBase.update);
						gameHolder.callBack(callBackName);
						blockCallBackNames.push(callBackName);
					}
					else {
						console.log(blockComponent.errorString());
					}
				}
				else {
					console.log(fillEmptyComponent.errorString());
				}
				id++;
			}
		}
		
		gameHolder.registerCallBack("zoom", function() {
			for(var i = 0; i < blockCallBackNames.length; i++) {
				gameHolder.callBack(blockCallBackNames[i]);
			}
		});
	}
	
	/*onToolChanged: {
		selectedTool.text = (tool == null ? "" : tool.name + " (" + tool.price + "$)");
	}*/

	MediaPlayer {
		id: gridPlayer
	}

	Grid {
		id: gameGrid
		columns: Logic.gameHolder.props.columns
		rows: Logic.gameHolder.props.rows
		spacing: 1

		property var blockWidth: gameBoard.width/columns - spacing + spacing/columns
		property var blockHeight: gameBoard.height/rows - spacing + spacing/rows
		property var baseColor: "transparent"

		Component.onCompleted: {
			Logic.gameHolder.registerGameGrid(gameGrid);
		}
	}
}
