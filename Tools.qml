import QtQuick 2.3
import Ubuntu.Components 1.1

import "logic.js" as Logic

Flickable {
    anchors {
        fill: parent
        margins: 4
    }
    contentHeight: tools.height
    contentWidth: parent.width - 2*anchors.margins
    clip: true

    Grid {
        id: tools
        columns: 1
        rows: realButtons.children.length
        spacing: 5

        width: parent.width

        property var loadedItems: 0

        Item {
            id: realButtons

            Item {
                id: roadButton
                property var src: "assets/lands/road/Road.qml"
                property var name: "Road";
                property var price: 125
                property var image: "assets/lands/road/icon.svg"
                property var btnColor: "#88a"
            }

            Item {
                id: residentialButton
                property var baseDir: "assets/lands/residential/"
                property var src: baseDir + "Residential.qml"
                property var name: "Residental zone";
                property var price: 80;
                property var image: baseDir + "icon.svg"
                property var btnColor: gameBoard.residentialColor
            }

            Item {
                id: commercialButton
                property var baseDir: "assets/lands/commercial/"
                property var src: baseDir + "Commercial.qml"
                property var name: "Commercial zone";
                property var price: 80
                property var image: baseDir + "icon.svg"
                property var btnColor: gameBoard.commercialColor
            }

            Item {
                id: industrialButton
                property var baseDir: "assets/lands/industrial/"
                property var src: baseDir + "Industrial.qml"
                property var name: "Industrial zone";
                property var price: 80
                property var image: baseDir + "icon.svg"
                property var btnColor: gameBoard.industrialColor
            }

            Item {
                id: policeButton
                property var src: "assets/lands/police/Police.qml"
                property var name: "Police station";
                property var price: 3800
                property var image: "assets/lands/police/icon.svg"
                property var btnColor: "#00d"
            }

            Item {
                id: fireButton
                property var src: "assets/lands/fire/Fire.qml"
                property var name: "Fire station";
                property var price: 3800
                property var image: "assets/lands/fire/icon.svg"
                property var btnColor: "#d00"
            }

            Item {
                id: hospitalButton
                property var src: "assets/lands/hospital/Hospital.qml"
                property var name: "Hospital";
                property var price: 5000
                property var image: "assets/lands/hospital/icon.svg"
                property var btnColor: "#d00"
            }

            Item {
                id: schoolButton
                property var src: "assets/lands/school/School.qml"
                property var name: "School";
                property var price: 4900
                property var image: "assets/lands/school/icon.svg"
                property var btnColor: "#da4"
            }

            Item {
                id: parkButton
                property var src: "assets/lands/park/Park.qml"
                property var name: "Park";
                property var price: 800
                property var image: "assets/lands/park/icon.svg"
                property var btnColor: "#8d0"
            }

            Item {
                id: powerButton
                property var src: "assets/lands/power/Power.qml"
                property var name: "Power plant";
                property var price: 5000
                property var image: "assets/lands/power/icon.svg"
                property var btnColor: "#dd0"
            }

            Item {
                id: waterButton
                property var src: "assets/lands/water/Water.qml"
                property var name: "Water pump";
                property var price: 2500;
                property var image: "assets/lands/water/icon.svg"
                property var btnColor: "#acf"
            }

            Item {
                id: buldozerButton
                property var src: "assets/lands/buldozer/Buldozer.qml"
                property var name: "Buldozer";
                property var price: 200
                property var image: "assets/icons/buldozer.svg"
                property var btnColor: "#a23"
                property var alternative: false
                property var remove: true
            }
        }

        Item {
            Component.onCompleted: {
                var buttons = new Array();
                for(var i = 0; i < realButtons.children.length; i++) {
                    var button = Qt.createComponent(encodeURIComponent("assets/toolButton.qml"));
                    if(button.status == Component.Ready) {
                        buttons[i] = button.createObject(tools);

                        buttons[i].location = realButtons.children[i].src;
                        buttons[i].btnColor = realButtons.children[i].btnColor;
                        buttons[i].price = realButtons.children[i].price;
                        buttons[i].image = realButtons.children[i].image;
                        buttons[i].name = realButtons.children[i].name;
                        buttons[i].remove = realButtons.children[i].remove;
                        buttons[i].alternative = realButtons.children[i].alternative;
                    }
                }
            }
        }
    }
}
