import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: grass

    property var baseDir: "assets/lands/empty/"

    property var name: destroyable ? "Forest" : "Empty land"
    property var zone: false
    property var noise: baseDir + "bird.wav"
    property var boardImage: ""
    property var location: baseDir + "Empty.qml"

    property var initial: true
    property var placed: false

    property var destroyable: false

    property var imageRotation: -45

    property var trees: ["shrub2-02.png", "pine-none08.png", "pine-none01.png", "bigtree03.png", "shrub2-01.png", "pine-none07.png", "palm06.png", "bigtree02.png", "tropical05.png", "shrub1-05.png", "pine-none06.png", "palm05.png", "bigtree01.png", "tropical04.png", "shrub1-04.png", "pine-none05.png", "palm04.png", "hemp03.png", "shrub2-05.png", "shrub1-03.png", "pine-none04.png", "palm03.png", "hemp02.png", "shrub2-04.png", "shrub1-02.png", "pine-none03.png", "palm02.png", "hemp01.png", "shrub2-03.png", "shrub1-01.png", "pine-none02.png", "palm01.png", "bush01.png"]

    Component.onCompleted: {
        if(Math.random() >= 0.5) {
            boardImage = baseDir + "trees/" + trees[Math.floor(Math.random() * trees.length)];
            destroyable = true;
        }
        else {
            boardImage = "";
            destroyable = false;
        }
    }

    onPlacedChanged: {
        if(placed == true) {
            boardImage = "";
            destroyable = false;
        }
    }

    function toJson() {
        return {
            boardImage: boardImage,
            location: location,
        };
    }

    function fromJson(json) {
        boardImage = json.boardImage;
        location = json.location;
    }
}
