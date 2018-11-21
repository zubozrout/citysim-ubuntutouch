import QtQuick 2.4
import Ubuntu.Components 1.3
import CitySim 1.0

import "scripts/logic.js" as Logic
import "components"

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

    width: units.gu(100)
    height: units.gu(75)

    property var menu: true
    property var muteSound: false
    property var loadSavedGame: false

    onMuteSoundChanged: CitySim.muted = muteSound

    Component.onCompleted: {
        muteSound = CitySim.muted;
        if(Logic.gameHolder === null) {
			Logic.gameHolder = new Logic.Game();
		}
    }

    Menu {
		visible: menu ? true : false
	}
	
	GameItem {
		id: gameItem
        visible: menu ? false : true
    }
}
