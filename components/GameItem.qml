import QtQuick 2.4
import Ubuntu.Components 1.3

import "../scripts/logic.js" as Logic

Item {
	id: gameItem
	visible: menu ? false : true
	
	property var gameObject: null;
	
	function createGame(callback) {
		var gameHolder = Logic.gameHolder;
		
		if(gameObject) {
			gameHolder.cleanCallbacks();
			gameObject.destroy();
			gameObject = null;
		}
		
		var game = Qt.createComponent(encodeURIComponent("Game.qml"), gameItem);
		if(game.status === Component.Ready) {
			gameObject = game.createObject(mainView);
			gameHolder.registerGameInstance(gameObject);
						
			if(callback) {
				callback(gameHolder);
			}
		}
		else {
			console.log(game.errorString());
		}
	}
}
