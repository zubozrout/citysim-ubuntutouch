import QtQuick 2.3
import Ubuntu.Components 1.1
import QtMultimedia 5.0
import CitySim 1.0

import "logic.js" as Logic

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    id: mainView
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "city.zubozrout"

    /*
     parent property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(100)
    height: units.gu(75)

    property var menu: true
    property var gameHolder: null
    property var muteSound: false

    onMuteSoundChanged: CitySim.muted = muteSound

    Component.onCompleted: {
        muteSound = CitySim.muted;
    }

    Item {
        visible: menu ? false : true

        onVisibleChanged: {
            if(visible && mainView.gameHolder == null) {
                var game = Qt.createComponent("Game.qml");
                if(game.status == Component.Ready) {
                    mainView.gameHolder = game.createObject(parent);
                }
            }
        }
    }

    Menu { visible: menu ? true : false }
}

