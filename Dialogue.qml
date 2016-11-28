import QtQuick 2.3
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 0.1

Dialog {
    id: dialogue
    title: ""
    text: ""

    Button {
        text: "Close"
        onClicked: PopupUtils.close(dialogue)
    }
}
