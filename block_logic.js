
function BuildBlock(gameBoard, block) {
    if(gameBoard.tool != null && gameBoard.tool.location != block.holding.location) {
        if(gameBoard.money >= gameBoard.tool.price) {
            if(block.holding.destroyable && gameBoard.tool.remove) {
                // Demolition

                if(typeof gameBoard.tool.placed !== typeof undefined) {
                    gameBoard.tool.placed += 1;
                }

                // Destroy previous item and replace with a new object
                if(block.holding.neighbours == true) {
                    CheckRoadBoard(gameBoard.boardArray, xPos, yPos, true);
                    MarkSurroundingsViable(gameBoard.boardArray, xPos, yPos, true);
                }

                // Reset block origin values
                block.xOrigin = -1;
                block.yOrigin = -1;

                var tmp = block.holding
                if(typeof gameBoard.tool.alternative === typeof undefined || gameBoard.tool.alternative == false) {
                    block.holding = gameBoard.empty.createObject(block);
                    block.holding.placed = true;
                }
                else {
                    var newObject = Qt.createComponent(encodeURIComponent(gameBoard.tool.alternative));
                    if(newObject.status == Component.Ready) {
                        block.holding = newObject.createObject(block);
                        block.holding.price = gameBoard.tool.price;
                        block.holding.name = gameBoard.tool.name;
                        block.holding.location = gameBoard.tool.src;
                    }
                }
                if(tmp != block.holding) {
                    tmp.destroy();
                }

                gameBoard.money -= gameBoard.tool.price;

                if(block.holding.placed != null) {
                    block.holding.placed++;
                }

                if(!container.muteSound) {
                    efectsPlayer.source = "assets/audio/destruction.wav";
                    efectsPlayer.stop();
                    efectsPlayer.play();
                }
            }
            else if((block.holding.initial || block.holding.zone) && !gameBoard.tool.remove) {
                // Construction

                // Destroy previous item and replace with a new object
                var tmp = block.holding
                var newObject = Qt.createComponent(encodeURIComponent(gameBoard.tool.location));
                if(newObject.status == Component.Ready) {
                    var object = newObject.createObject(block);
                    var placable = true;

                    if(object.size > 1) {
                        for(var i = 1; i < object.size; i++) {
                            if(xPos - i < 0 || yPos - i < 0) {
                                placable = false;
                            }
                            if(!(gameBoard.boardArray[xPos][yPos - i].holding.initial || gameBoard.boardArray[xPos][yPos - i].holding.zone)) {
                                placable = false;
                            }
                            if(!(gameBoard.boardArray[xPos -i][yPos].holding.initial || gameBoard.boardArray[xPos][yPos - i].holding.zone)) {
                                placable = false;
                            }
                            for(var j = 0; j < object.size; j++) {
                                if(!(gameBoard.boardArray[xPos - j][yPos - i].holding.initial || gameBoard.boardArray[xPos][yPos - i].holding.zone)) {
                                    placable = false;
                                }
                                if(!(gameBoard.boardArray[xPos - i][yPos - j].holding.initial || gameBoard.boardArray[xPos][yPos - i].holding.zone)) {
                                    placable = false;
                                }
                            }
                        }
                    }

                    if(placable) {
                        if(typeof object.size !== typeof undefined) {
                            gameBoard.boardArray[xPos - object.size + 1][yPos - object.size + 1].xOrigin = xPos - (object.size ? object.size - 1 : 0);
                            gameBoard.boardArray[xPos - object.size + 1][yPos - object.size + 1].yOrigin = yPos - (object.size ? object.size - 1 : 0);
                        }
                        else {
                            block.xOrigin = xPos;
                            block.yOrigin = yPos;
                        }

                        block.holding = object;
                        block.holding.price = gameBoard.tool.price;
                        block.holding.name = gameBoard.tool.name;
                        block.holding.location = gameBoard.tool.location;

                        if(object.size > 1) {
                            for(var i = 1; i < object.size; i++) {
                                gameBoard.boardArray[xPos][yPos - i].holding = block.holding;
                                gameBoard.boardArray[xPos -i][yPos].holding = block.holding;
                                for(var j = 0; j < object.size; j++) {
                                    gameBoard.boardArray[xPos - j][yPos - i].holding = block.holding;
                                    gameBoard.boardArray[xPos - i][yPos - j].holding = block.holding;
                                }
                            }
                        }

                        gameBoard.money -= gameBoard.tool.price;

                        if(block.holding.neighbours == true) {
                            CheckRoadBoard(gameBoard.boardArray, xPos, yPos, false);
                            MarkSurroundingsViable(gameBoard.boardArray, xPos, yPos, false);
                        }

                        if(block.holding.placed != null) {
                            block.holding.placed = true;
                        }
                    }
                    else {
                        newObject.destroy();
                        PopupUtils.open(Qt.resolvedUrl("Dialogue.qml"), block, {
                            title: "Can't place the building " + object.size + "x" + object.size,
                            text: "The area is already occupied"
                        })
                    }
                }
                tmp.destroy();
            }
        }
        else {
            if(block.holding.initial || block.holding.zone) {
                PopupUtils.open(Qt.resolvedUrl("Dialogue.qml"), block, {
                    title: "Not enough money",
                    text: gameBoard.tool.name + " costs " + (gameBoard.tool.price ? gameBoard.tool.price : "0") + "$" + " while you only have " + gameBoard.money + "$"
                })
            }
        }
    }
    else if(gameBoard.tool == null) {
        // dialogue

        PopupUtils.open(Qt.resolvedUrl("Dialogue.qml"), block, {
            title: block.holding.name + (typeof block.holding.income !== typeof undefined ? ",\n" + block.holding.income + "$/month" + (block.holding.zone == "r" ? "/citizen" : "") : ""),
            text: (typeof block.holding.usableInfo !== typeof undefined) ? block.holding.usableInfo : "Land value: " + (block.holding.price ? block.holding.price : "0") + "$"
        })
    }
}


function CheckRoadBoard(board, line, column, remove) {
    if(!remove) {
        if(column + 1 < board[line].length && board[line][column + 1].holding.name == board[line][column].holding.name) {
            // On right
            board[line][column].holding.surrounds.right = true;
            board[line][column + 1].holding.surrounds.left = true;
            board[line][column + 1].holding.surroundsModified++;
        }
        else {
            board[line][column].holding.surrounds.right = false;
        }

        if(line + 1 < board.length && board[line + 1][column].holding.name == board[line][column].holding.name) {
            // On bottom
            board[line][column].holding.surrounds.bottom = true;
            board[line + 1][column].holding.surrounds.top = true;
            board[line + 1][column].holding.surroundsModified++;
        }
        else {
            board[line][column].holding.surrounds.bottom = false;
        }

        if(column - 1 >= 0 && board[line][column - 1].holding.name == board[line][column].holding.name) {
            // On left
            board[line][column].holding.surrounds.left = true;
            board[line][column - 1].holding.surrounds.right = true;
            board[line][column - 1].holding.surroundsModified++;
        }
        else {
            board[line][column].holding.surrounds.left = false;
        }

        if(line - 1 >= 0 && board[line - 1][column].holding.name == board[line][column].holding.name) {
            // On top
            board[line][column].holding.surrounds.top = true;
            board[line - 1][column].holding.surrounds.bottom = true;
            board[line - 1][column].holding.surroundsModified++;
        }
        else {
            board[line][column].holding.surrounds.top = false;
        }

        board[line][column].holding.surroundsModified++;
    }

    else {
        if(column + 1 < board[line].length && board[line][column + 1].holding.name == board[line][column].holding.name) {
            // On right
            board[line][column + 1].holding.surrounds.left = false;
            board[line][column + 1].holding.surroundsModified++;
        }
        else {
            board[line][column].holding.surrounds.right = true;
        }

        if(line + 1 < board.length && board[line + 1][column].holding.name == board[line][column].holding.name) {
            // On bottom
            board[line + 1][column].holding.surrounds.top = false;
            board[line + 1][column].holding.surroundsModified++;
        }
        else {
            board[line][column].holding.surrounds.bottom = true;
        }

        if(column - 1 >= 0 && board[line][column - 1].holding.name == board[line][column].holding.name) {
            // On left
            board[line][column - 1].holding.surrounds.right = false;
            board[line][column - 1].holding.surroundsModified++;
        }
        else {
            board[line][column].holding.surrounds.left = true;
        }

        if(line - 1 >= 0 && board[line - 1][column].holding.name == board[line][column].holding.name) {
            // On top
            board[line - 1][column].holding.surrounds.bottom = false;
            board[line - 1][column].holding.surroundsModified++;
        }
        else {
            board[line][column].holding.surrounds.top = true;
        }
    }
}

function MarkSurroundingsViable(board, line, column, remove) {
    if(!remove) {
        if(column + 1 < board[line].length) {
            // On right
            board[line][column + 1].leftViable = true;
        }

        if(line + 1 < board.length) {
            // On bottom
            board[line + 1][column].topViable = true;
        }

        if(column - 1 >= 0) {
            // On left
            board[line][column - 1].rightViable = true;
        }

        if(line - 1 >= 0) {
            // On top
            board[line - 1][column].bottomViable = true;
        }
    }

    else {
        if(column + 1 < board[line].length) {
            // On right
            board[line][column + 1].leftViable = false;
        }

        if(line + 1 < board.length) {
            // On bottom
            board[line + 1][column].topViable = false;
        }

        if(column - 1 >= 0) {
            // On left
            board[line][column - 1].rightViable = false;
        }

        if(line - 1 >= 0) {
            // On top
            board[line - 1][column].bottomViable = false;
        }
    }
}
