import QtQuick 2.4
import Ubuntu.Components.Popups 1.3

import "../scripts/logic.js" as Logic

Flickable {
	id: boardFlickable
	
	contentWidth: Math.sqrt(dirt.width * dirt.width + dirt.height * dirt.height) + width / 10
	contentHeight: Math.sqrt(dirt.width * dirt.width + dirt.height * dirt.height) * dirt.deform + width / 10
	
	clip: true

	Rectangle {
		anchors.fill: parent
		color: "#33333333"
	}

	Rectangle {
		id: dirt
		anchors {
			centerIn: parent
		}
		rotation: 45
		property var deform: 0.5
		
		function updateZoom(gameHolder) {
			var currentWidth = width;
			var currentHeight = height;
			width = gameHolder.props.width + gameHolder.settings.zoomLevel;
			height = gameHolder.props.height + gameHolder.settings.zoomLevel;
			
			if(currentWidth > 0 && currentHeight > 0) {
				var currentX = boardFlickable.contentX;
				var currentY = boardFlickable.contentY;				
				boardFlickable.contentX = currentX * (width / currentWidth);
				boardFlickable.contentY = currentY * (height / currentHeight);
			}
			else {
				boardFlickable.contentX = (boardFlickable.contentWidth - boardFlickable.width) / 2;
				boardFlickable.contentY = (boardFlickable.contentHeight - boardFlickable.height) / 2;
			}
		}
		
		Component.onCompleted: {
			Logic.gameHolder.registerCallBack("zoom", updateZoom);
			Logic.gameHolder.callBack("zoom");
		}

		Image {
			anchors.fill: parent
			fillMode: Image.Tile
			horizontalAlignment: Image.AlignLeft
			verticalAlignment: Image.AlignTop
			source: "../assets/images/dirt.png"
		}

		transform: Scale {origin.y: dirt.height * dirt.deform; yScale: dirt.deform }
		
		GameBoard {
			id: gameBoard
		}
	}
}
