import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
    id: dialogue
    title: ""
    text: ""

    Button {
        text: "Close"
        onClicked: PopupUtils.close(dialogue)
    }
}
