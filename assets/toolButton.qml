import QtQuick 2.4
import Ubuntu.Components 1.3
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

import "../scripts/logic.js" as Logic

Rectangle {
    id: toolButton
    width: parent.width
    height: width
    radius: width
    color: active ? "#fff" : btnColor

    border.width: 1
    border.color: active ? "#38d" : "#fff"

    property var location: ""
    property var btnColor: "#fff"
    property var price: 0
    property var image: null
    property var name: ""
    property bool remove: false
    property bool alternative: false
    property bool allSet: false
    property bool active: false
    
    onAllSetChanged: {
		if(allSet === true) {
			if(image) {
				toolIcon.source = image;
			}
			else {
				if(location) {
					toolIcon.source = location.substr(0, location.lastIndexOf("/")) + "/icon.svg";
				}
				else {
					toolIcon.source = "../assets/icons/tux.svg";
				}
				image = toolIcon.source;
			}
		}
	}
	
	function disable(gameHolder) {
		gameHolder.props.tool = null;
		toolButton.active = false;
	}
	
	function update(gameHolder, active) {
		active = active || false;
		if(active) {
			gameHolder.props.tool = null;
			toolButton.active = false;
		}
		else {
			gameHolder.props.tool = toolButton;
			toolButton.active = true;
		}
	}
	
	Item {
		anchors.fill: parent

		Image {
			id: toolIcon
			anchors.fill: parent
			fillMode: Image.PreserveAspectFit

			MouseArea {
				anchors.fill: parent
				onClicked: {
					var active = toolButton.active;     
					Logic.gameHolder.callBack("tool-change", null, function(gameHolder) {
						toolButton.update(gameHolder, active);
					});

					if(!gameBoardContainer.muteSound) {
						sound.play();
					}
				}
			}
		}
		
		ColorOverlay {
			id: toolIconOverlay
			anchors.fill: toolIcon
			source: toolIcon
			color: "#000000"
			cached: true
			visible: active
		}
	}

    SoundEffect {
        id: sound
        source: "../assets/audio/click.wav"
    }
}

