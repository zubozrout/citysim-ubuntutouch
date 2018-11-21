import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

import "../scripts/logic.js" as Logic

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
    height: units.gu(7)
    border.width: 1
    border.color: "#3a97cd"
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#35c3f8" }
        GradientStop { position: 1.0; color: "#3a97cd" }
    }
    
    Rectangle {
		id: timeIndicator
		anchors {
			top: parent.top
			right: parent.right
            left: parent.left
        }
        height: 2
        
        LinearGradient {
			id: lienarGradient
			anchors.fill: parent
			start: Qt.point(0, 0)
			end: Qt.point(width, 0) 
        
			property var leftColor: "#35c3f8"
			property var rightColor: "#3a97cd"
        
			gradient: Gradient {
				GradientStop { position: 0.0; color: lienarGradient.leftColor }
				GradientStop { position: 1.0; color: lienarGradient.rightColor }
			}
			
			ColorAnimation on leftColor {
				running: dailyTimer.running
				from: "#35c3f8"
				to: "#fff"
				duration: dailyTimer.interval
				loops: Animation.Infinite
			}
			
			ColorAnimation on rightColor {
				running: dailyTimer.running
				from: "#fff"
				to: "#35c3f8"
				duration: dailyTimer.interval
				loops: Animation.Infinite
			}
		}
	}
	
	Item {
		id: bottomToolBarItems
		anchors {
			top: timeIndicator.top
            right: parent.right
            bottom: parent.bottom
            left: parent.left
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
					property var value: Logic.gameHolder.gameData.zones.industrial.demand * (demandWrapper.height - demandWrapper.anchors.margins/2)/100

					color: Logic.gameHolder.props.industrialColor
					width: parent.width/3 - parent.spacing
					height: value < 5 ? 5 : value //Don't let the parent box look empty
				}

				Rectangle {
					id: commerce
					property var value: Logic.gameHolder.gameData.zones.commercial.demand * (demandWrapper.height - demandWrapper.anchors.margins/2)/100

					color: Logic.gameHolder.props.commercialColor
					width: parent.width/3
					height: value < 5 ? 5 : value
				}

				Rectangle {
					id: residential
					property var value: Logic.gameHolder.gameData.zones.residential.demand * (demandWrapper.height - demandWrapper.anchors.margins/2)/100

					color: Logic.gameHolder.props.residentialColor
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
				source: "../assets/icons/zoom_out.svg"
			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					Logic.gameHolder.callBack("zoom", function(gameHolder) {
						if(gameHolder.settings.zoomLevel > gameHolder.settings.minZoomLevel) {
							gameHolder.settings.zoomLevel -= gameHolder.settings.zoomStep;
						}
						else {
							gameHolder.settings.zoomLevel = gameHolder.settings.minZoomLevel;
						}
						if(!gameHolder.settings.muteSound) {
							zoomoutSound.play();
						}
					});
				}
			}

			SoundEffect {
				id: zoomoutSound
				source: "../assets/audio/zoom.wav"
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
				source: "../assets/icons/zoom_in.svg"
			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					Logic.gameHolder.callBack("zoom", function(gameHolder) {
						if(gameHolder.settings.zoomLevel < gameHolder.settings.maxZoomLevel) {
							gameHolder.settings.zoomLevel += gameHolder.settings.zoomStep;
						}
						else {
							gameHolder.settings.zoomLevel = gameHolder.settings.maxZoomLevel;
						}
						if(!gameHolder.settings.muteSound) {
							zoomoutSound.play();
						}
						if(!gameHolder.settings.muteSound) {
							zoominSound.play();
						}
					});
				}
			}

			SoundEffect {
				id: zoominSound
				source: "../assets/audio/zoom.wav"
			}
		}

		Rectangle {
			id: dateButtons
			anchors {
				margins: 8
				left: zoomIn.right
				top: parent.top;
				bottom: parent.bottom
			}
			width: dateGo.width + datePause.width
			radius: height / 3
			color: "transparent"

			property bool running: dailyTimer.running

			Image {
				id: dateGo
				anchors {
					top: parent.top;
					bottom: parent.bottom
					left: parent.left
				}
				width: height;
				fillMode: Image.PreserveAspectFit
				source: parent.running ? "../assets/icons/play.svg" : "../assets/icons/play_inactive.svg"
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
				source: parent.running ? "../assets/icons/stop_inactive.svg" : "../assets/icons/stop.svg"
			}


			MouseArea {
				anchors.fill: parent
				onClicked: {
					if(dailyTimer.running) {
						dailyTimer.stop();
					}
					else {
						dailyTimer.start();
					}
					if(!Logic.gameHolder.settings.muteSound) {
						dateButtonsSound.play();
					}
				}
			}

			SoundEffect {
				id: dateButtonsSound
				source: "../assets/audio/click.wav"
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
				text: "N/A"
				color: "#fff"
				font.pointSize: units.gu(1)

				Layout.fillWidth: true
				
				function updateDate(gameHolder) {
					var day = ("0" + gameHolder.gameData.basics.date.getDate()).slice(-2);
					var month = ("0" + gameHolder.gameData.basics.date.getMonth()).slice(-2);
					var year = gameHolder.gameData.basics.date.getFullYear();
					text = day + "/" + month + "/" + year;
				}
				
				Component.onCompleted: {
					Logic.gameHolder.registerCallBack("new-day", updateDate);
					updateDate(Logic.gameHolder);
				}
			}

			Text {
				id: populationTag
				text: "Pop: " + Logic.gameHolder.gameData.basics.population
				color: "#46d"
				font.pointSize: units.gu(1)

				Layout.fillWidth: true
			}

			Text {
				id: moneyTag
				text: "N/A"
				font.pointSize: units.gu(1)
				
				function updateMoney(gameHolder) {
					text = "$" + gameHolder.gameData.basics.money + " UBcoins";
					color = gameHolder.gameData.basics.money < 0 ? "#d00" : "#333";
				}
				
				Component.onCompleted: {
					Logic.gameHolder.registerCallBack("money-update", updateMoney);
					updateMoney(Logic.gameHolder);
				}

				MouseArea {
					anchors.fill: parent
					onClicked: {
						Logic.gameHolder.gameData.basics.date.money += 1000;
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
}
