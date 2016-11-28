
function Game(board) {

}

function GameDaily(board) {
    var tomorrow = new Date(board.date);
    tomorrow.setDate(board.date.getDate() + 1);
    board.date = tomorrow;

    if(board.date.getDay() == 1) {
        GameMonthly(board);
    }
}

function GameMonthly(board) {
    for(var i = 0; i < board.boardArray.length; i++) {
        for(var j = 0; j < board.boardArray[i].length; j++) {
            if(board.boardArray[i][j].holding.income) {
                if(typeof board.boardArray[i][j].holding.populated !== typeof undefined && board.boardArray[i][j].holding.populated == false) {
                    continue;
                }

                var buildingIncome = board.boardArray[i][j].holding.income;
                if(typeof board.boardArray[i][j].holding.population !== typeof undefined) {
                    buildingIncome = board.boardArray[i][j].holding.population*buildingIncome;
                }

                board.money += buildingIncome;
            }
        }
    }
}

function CheckTopLeft(x, y, object) {
    if(object.zone != gameBoard.boardArray[x - 1][y].holding.zone || gameBoard.boardArray[x][y].holding.populated) {
        return true;
    }
    if(object.zone != gameBoard.boardArray[x - 1][y + 1].holding.zone || gameBoard.boardArray[x][y].holding.populated) {
        return true;
    }
    if(object.zone != gameBoard.boardArray[x][y + 1].holding.zone || gameBoard.boardArray[x][y].holding.populated) {
        return true;
    }
    return false;
}

