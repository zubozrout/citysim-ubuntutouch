import QtQuick 2.3
import QtMultimedia 5.0

Item {
    id: road

    property var name: ""
    property var location: ""
    property var price: 0

    property var zone: false
    property var mapColor: "#333"
    property var sound: "assets/lands/road/construction.wav"
    property var noise: "assets/lands/grass/bird.wav"
    property var boardImage: "assets/lands/road/road_crossing.png"
    property var neighbours: true
    property var surrounds: new Object({top: false, right: false, bottom: false, left: false})
    property var surroundsModified: 0

    property var destroy: false

    property var placed: 0
    property var size: 1

    property var destroyable: true

    property var income: -0.05 * gameBoard.transportMoney

    property var imageRotation: 0

    onSurroundsModifiedChanged: {
        if(surrounds.top) {
            if(surrounds.right && !surrounds.left && !surrounds.bottom) {
                boardImage = "assets/lands/road/road_bottom_left.png";
            }
            else if(surrounds.left && !surrounds.right && !surrounds.bottom) {
                boardImage = "assets/lands/road/road_bottom_right.png";
            }
            else if(surrounds.bottom && !surrounds.left && !surrounds.right) {
                boardImage = "assets/lands/road/road_vertical.png";
            }
            else if(surrounds.bottom && surrounds.left && !surrounds.right) {
                boardImage = "assets/lands/road/road_crossing_left.png";
            }
            else if(surrounds.bottom && !surrounds.left && surrounds.right) {
                boardImage = "assets/lands/road/road_crossing_right.png";
            }
            else if(!surrounds.bottom && surrounds.left && surrounds.right) {
                boardImage = "assets/lands/road/road_crossing_top.png";
            }
            else if(surrounds.bottom && surrounds.left && surrounds.right) {
                boardImage = "assets/lands/road/road_crossing.png";
            }
            else {
               boardImage = "assets/lands/road/end_bottom.png";
            }
        }
        else if(surrounds.bottom) {
            if(surrounds.right && !surrounds.left && !surrounds.top) {
                boardImage = "assets/lands/road/road_top_left.png";
            }
            else if(surrounds.left && !surrounds.right && !surrounds.top) {
                boardImage = "assets/lands/road/road_top_right.png";
            }
            else if(surrounds.top && !surrounds.left && !surrounds.right) {
                boardImage = "assets/lands/road/road_vertical.png";
            }
            else if(surrounds.left && surrounds.right) {
                boardImage = "assets/lands/road/road_crossing_bottom.png";
            }
            else {
               boardImage = "assets/lands/road/end_top.png";
            }
        }
        else if(surrounds.left) {
            if(surrounds.right) {
                boardImage = "assets/lands/road/road_horizontal.png";
            }
            else {
               boardImage = "assets/lands/road/end_right.png";
            }
        }
        else if(surrounds.right) {
            boardImage = "assets/lands/road/end_left.png";
        }
        else {
          boardImage = "assets/lands/road/road_crossing.png";
        }
    }

    onPlacedChanged: {
        if(!container.muteSound) {
            player.stop();
            player.play();
        }
    }

    Audio {
        id: player
        source: sound
        volume: 0.5
    }

    function toJson() {
        return {
            location: location,
        };
    }

    function fromJson(json) {
        location = json.location;
    }
}
