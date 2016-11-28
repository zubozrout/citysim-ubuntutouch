import QtQuick 2.3
import Ubuntu.Components.Popups 0.1

import "logic.js" as Logic
import "block_logic.js" as BlockLogic

Rectangle {
    id: block

    color: parent.baseColor
    width: parent.blockWidth
    height: parent.blockHeight

    property var uniqueID: 0

    property var holding: null
    property var xPos: 0
    property var yPos: 0
    property var xOrigin: -1
    property var yOrigin: -1

    property var leftViable: false
    property var rightViable: false
    property var topViable: false
    property var bottomViable: false

    property var viable: leftViable || rightViable || topViable || bottomViable ? true : false

    onHoldingChanged: {
        if(holding == null) {
            holding = gameBoard.empty.createObject(block);
        }
        else if(typeof holding !== typeof undefined) {
            if(typeof holding.viability !== typeof undefined && holding.viability.constructor === Array) {
                holding.viability[uniqueID] = viable;
                holding.viabilityModifier++;
            }
        }
    }

    onViableChanged: {
        if(typeof holding !== typeof undefined && typeof holding.viability !== typeof undefined && holding.viability.constructor === Array) {
            holding.viability[uniqueID] = viable;
            holding.viabilityModifier++;
        }
    }

    Image {
        source: parent.holding.initial == true || parent.holding.size < 2 ? "assets/images/grass.png" : ""
        anchors.fill: parent
    }

    Rectangle {
        color: "transparent"
        rotation: block.holding.imageRotation
        width: parent.width
        height: parent.height

        Image {
            // Tile element
            source: block.holding.size > 1 ? ( block.xOrigin == xPos && block.yOrigin == yPos ? block.holding.boardImage : "" ) : block.holding.boardImage
            width: parent.rotation == 0 ? parent.width : Math.sqrt(parent.width*parent.width + parent.height*parent.height) * ( block.xOrigin == xPos && block.yOrigin == yPos || block.holding.initial ? (block.holding.size ? block.holding.size : 1) : 0 ) + ((block.holding.size ? block.holding.size : 0) + 1)*grid.spacing
            height: parent.rotation == 0 ? parent.height : sourceSize.height*(width/sourceSize.width)*2
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: (parent.rotation == 0 ? 0 : -(block.holding.size > 1 ? (block.holding.size - 1) * (width/2) : 0) - parent.height/4) + grid.spacing;
                leftMargin: grid.spacing
            }
        }
    }

    Rectangle {
        id: viableStat
        anchors {
            margins: parent.width/4
            fill: parent
        }
        color: parent.viable ? "#3d5" : "transparent"
        visible: container.showViability ? true : false
        opacity: 0.5
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            // Build or destroy block
            BlockLogic.BuildBlock(gameBoard, block);
        }
    }
}
