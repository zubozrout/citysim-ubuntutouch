import QtQuick 2.4
import Ubuntu.Components.Popups 1.3

import "../scripts/logic.js" as Logic

Rectangle {
    id: mapBlock
    
    color: parent.baseColor
    width: parent.blockWidth
    height: parent.blockHeight

    property var uniqueID: 0

    property var xPos: 0
    property var yPos: 0
    property var xOrigin: -1
    property var yOrigin: -1
    
    function update() {
		var abstractBlock = Logic.gameHolder.boardArray[xPos][yPos];
		var holding = abstractBlock.holding;
		
		var blockOccupied = false;	
		if(typeof holding === typeof {} && typeof holding.objData !== typeof undefined) {
			objectRectangle.rotation = holding.objData.imageRotation || 0;
			objectImage.source = holding.objData.boardImage ? holding.objData.boardImage : "";
			blockOccupied = true;
		}
		else {
			objectRectangle.rotation = 0;
			objectImage.source = "";
		}
		
		if(objectRectangle.rotation === 0) {
			objectImage.anchors.bottomMargin = gameGrid.spacing;
			objectImage.anchors.leftMargin = gameGrid.spacing;
			objectImage.width = objectRectangle.width;
			objectImage.height = objectRectangle.height;
		}
		else {
			var objSize = holding.objData.size || 1;
			var objWidthPos = Math.sqrt(objectRectangle.width * objectRectangle.width + objectRectangle.height * objectRectangle.height);
			var objWidth = objSize * gameGrid.spacing * objWidthPos;
			
			objectImage.width = objWidth;
			objectImage.height = objectImage.sourceSize.height * (objWidth / objectImage.sourceSize.width) * 2;
			//objectImage.anchors.bottomMargin = -(objectRectangle.height / 4) - objSize * gameGrid.spacing;
			objectImage.anchors.bottomMargin = -(objectRectangle.height / 5);
			objectImage.anchors.leftMargin = -(objectRectangle.height / 5);
		}
		
		/* Show viability */
		if(blockOccupied && holding.objData.viabilitySource) {
			objectRectangle.color = "#af0";
			objectImage.opacity = 0.25;
		}
		else {
			objectRectangle.color = "transparent";
			objectImage.opacity = 1;
		}
	}

    Image {
        source: "../assets/images/grass.png"
        anchors.fill: parent
    }

    Rectangle {
		id: objectRectangle
        color: "transparent"
        width: parent.width
        height: parent.height
        visible: objectImage.source ? true : false
        
        // Tile element
        Image {
			id: objectImage
            width: parent.width
            height: parent.height
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                leftMargin: gameGrid.spacing
            }
        }
    }

    Rectangle {
        id: viableStat
        anchors {
            margins: parent.width / 4
            fill: parent
        }
        color: parent.viable ? "#3d5" : "transparent"
        visible: gameBoardContainer.showViability ? true : false
        opacity: 0.5
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            // Build or destroy block
            //Logic.BuildBlock(gameBoard, block);
            
            console.log("click", xPos, yPos);
            
            Logic.gameHolder.callBack("block-" + xPos + "-" + yPos, function(gameHolder) {
				var abstractBlock = Logic.gameHolder.boardArray[xPos][yPos];
				var holding = abstractBlock.holding;
				
				if(gameHolder.props.tool) {					
					if(!gameHolder.props.tool.location) {
						if(gameHolder.props.tool.remove) {
							gameHolder.gameData.basics.money -= gameHolder.props.tool.price;
							gameHolder.deleteBlock(xPos, yPos);
						}
					}
					else {
						var tmp = holding;
						var newObject = Qt.createComponent(encodeURIComponent(gameHolder.props.tool.location));
						if(newObject.status === Component.Ready) {
							var object = newObject.createObject(mapBlock);
							holding = object;
							holding.objData = holding.objData || {};
							
							var allowed = true;
							if(xPos - holding.objData.size + 1 < 0 || yPos - holding.objData.size + 1 < 0) {
								allowed = false;
							}
							
							if(allowed) {
								holding.objData.price = holding.objData.price || gameHolder.props.tool.price;
								holding.objData.name = holding.objData.name || gameHolder.props.tool.name;
								holding.objData.location = holding.objData.location || gameHolder.props.tool.location;
								gameHolder.gameData.basics.money -= holding.objData.price || gameHolder.props.tool.price;
								holding.objData.placed = true;
								
								gameHolder.deleteBlock(xPos, yPos);
								gameHolder.boardArray[xPos][yPos].holding = holding;
								gameHolder.updateNeighbours(xPos, yPos);
							}
							else {
								object.destroy();
							}
						}
						else {
							console.log(newObject.errorString());
						}
						if(tmp && tmp.destroy) {
							tmp.destroy();
						}
					}
					abstractBlock.base.update();
				}
				else {
					PopupUtils.open(Qt.resolvedUrl("../components/Dialogue.qml"), mapBlock, {
						title: holding.objData.name + (holding.objData.income ? ",\n" + holding.objData.income + "$/month" + (holding.objData.zone === "r" ? "/citizen" : "") : ""),
						text: holding.objData.usableInfo ? holding.objData.usableInfo : "Land value: " + (holding.objData.price ? holding.objData.price : "0") + "$"
					});
				}
			});
			Logic.gameHolder.callBack("money-update");
        }
    }
}
