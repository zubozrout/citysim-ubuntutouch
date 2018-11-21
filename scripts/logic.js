.pragma library
"use strict";

Qt.include("city-data.js");

function Game(data) {
	data = data || {};
	
	this.boardArray = data.boardArray || [];
	this.gameInstance = data.gameInstance || null;
	this.tool = null;
	this.props = data.props || this.getdefaultProps();
	this.gameData = new CityData(data.gameData || null);
	this.settings = {
		showViability: false,
		muteSound: false,
		zoomLevel: 0,
		zoomStep: 1000,
		minZoomLevel: -1000,
		maxZoomLevel: 2000,
		tool: null,
	};
	this.init();
	
	console.log("New game initialized");
}

Game.prototype.init = function(gameInstance) {
	this.cleanCallbacks();
}

Game.prototype.cleanCallbacks = function() {
	this.callBacks = [];
}

Game.prototype.registerGameInstance = function(gameInstance) {
	this.gameInstance = gameInstance || null;
}

Game.prototype.registerGameBoard = function(gameBoard) {
	this.gameBoard = gameBoard || null;
}

Game.prototype.registerGameGrid = function(gameGrid) {
	this.gameGrid = gameGrid || null;
}

Game.prototype.update = function(data) {
	this.gameData.zoneCount = this.gameData.industrialCount + this.gameData.commercialCount + this.gameData.residentialCount;
	this.gameData.populatedZoneCount = this.gameData.industrialCount + this.gameData.commercialCount + this.gameData.residentialCount;
}

Game.prototype.registerCallBack = function(name, callBack) {
	if(callBack) {
		var internalCallBack = this.getCallBack(name);
		if(internalCallBack) {
			internalCallBack.run.push(callBack);
		}
		else {
			this.callBacks.push({
				name: name,
				run: [ callBack ]
			});
		}
	}
}

Game.prototype.getCallBack = function(name) {
	for(var i = 0; i < this.callBacks.length; i++) {
		if(this.callBacks[i].name === name) {
			return this.callBacks[i];
		}
	}
	return null;
}

Game.prototype.callBack = function(name, preCallback, postCallback, ignoreInternal) {
	var internalCallBack = this.getCallBack(name);
	if(internalCallBack) {
		if(preCallback) {
			preCallback(this, internalCallBack);
		}
		if(!ignoreInternal) {
			for(var j = 0; j < internalCallBack.run.length; j++) {
				internalCallBack.run[j](this);
			}
		}
		if(postCallback) {
			postCallback(this, internalCallBack);
		}
		return true;
	}
	return false;
}

Game.prototype.getObjectOnPosition = function(x, y) {
	if(x >= 0 && x < this.boardArray.length) {
		if(y >= 0 && y < this.boardArray[x].length) {
			return this.boardArray[x][y];
		}
	}
	return false;
}

Game.prototype.getNeighbours = function(x, y) {
	var neighbours = {};
	neighbours.current = this.getObjectOnPosition(x, y); // current
	neighbours.top = this.getObjectOnPosition(x - 1, y); // Top
	neighbours.right = this.getObjectOnPosition(x, y + 1); // Right
	neighbours.bottom = this.getObjectOnPosition(x + 1, y); // Bottom
	neighbours.left = this.getObjectOnPosition(x, y - 1); // Left
	return neighbours;
}

Game.prototype.newDay = function(gameHolder) {
	var self = gameHolder || this;
	
	var tomorrow = new Date(self.gameData.basics.date);
    tomorrow.setDate(self.gameData.basics.date.getDate() + 1);
    self.gameData.basics.date = tomorrow;

    if(self.gameData.basics.date.getDay() === 1) {
        // New month
    }
}

Game.prototype.getdefaultProps = function() {
	return {
		width:  2048,
		height:  2048,
		columns: 32,
		rows: 32,
		industrialColor: "#a50",
		commercialColor: "#04a",
		residentialColor: "#4a0"
	};
}

Game.prototype.reset = function() {
	this.boardArray = [];
	this.props = this.getdefaultProps();
	this.gameData = new CityData();
	return this;
}

Game.prototype.updateNeighbours = function(xPos, yPos) {
	var neighbours = this.getNeighbours(xPos, yPos);
	for(var prop in neighbours) {
		if(neighbours[prop] && neighbours[prop].holding.update) {
			neighbours[prop].holding.update(gameHolder, {
				x: neighbours[prop].base.xPos,
				y: neighbours[prop].base.yPos
			});
			this.boardArray[neighbours[prop].base.xPos][neighbours[prop].base.yPos].base.update();
		}
	}
}

Game.prototype.deleteBlock = function(xPos, yPos) {
	var block = this.boardArray[xPos][yPos];
	var size = block.holding && block.holding.objData && block.holding.objData.size ? block.holding.objData.size : 1;
	var width = size;
	var height = size;
	for(var x = xPos; x > xPos - width; x--) {
		for(var y = yPos; y > yPos - height; y--) {
			if(block.holding.destroy) {
				block.holding.destroy();
			}
			block.holding = block.uniqueID;
			gameHolder.updateNeighbours(x, y);
		}
	}
}

Game.prototype.fromJson = function(data) {
	data = data || {};
	this.boardArray = data.boardArray || [];
	this.props = data.props || {};
	this.gameData = new CityData(data.gameData || null);
	return this;
}

Game.prototype.toJson = function() {
	var object = {};
	object.boardArray = [];
	
	for(var x = 0; x < this.boardArray.length; x++) {
		object.boardArray[x] = [];
		for(var y = 0; y < this.boardArray[x].length; y++) {
			object.boardArray[x][y] = {};
			var cell = this.boardArray[x][y];
			
			var keysToSave = [
				"uniqueID",
				"holding"
			];
			
			for(var key in cell) {
				if(key === "uniqueID") {
					object.boardArray[x][y][key] = cell[key];
				}
				if(key === "holding") {
					if(cell[key]["objData"]) {
						object.boardArray[x][y][key] = {};
						object.boardArray[x][y][key]["objData"] = cell[key]["objData"];
					}
				}
			}
		}
	}
	
	
	object.props = this.props;
	object.gameData = this.gameData.toJson();
	return object;
}

Game.prototype.timeStepUpdateForLand = function(field, callback) {
	var canLive = false;
	var neighbours = this.getNeighbours(field.x, field.y);
	var objData = neighbours.current.holding.objData;
	for(var prop in neighbours) {
		if(prop !== "current") {
			if(neighbours[prop] && neighbours[prop].holding.objData && neighbours[prop].holding.objData.viabilitySource) {
				canLive = true;
				if(objData.level < 1) {
					objData.level = 1;
				}
				else {
					if(neighbours.current.holding.getBuildings) {
						var buildings = neighbours.current.holding.getBuildings(objData.level);
						if(buildings) {
							if(objData.daysToSurvive < 0) {
								var index = Math.floor(Math.random() * buildings.length);
								objData.boardImage = neighbours.current.holding.baseDir + buildings[index].name;
								objData.daysToSurvive = buildings[index].daysToSurvive || 0;
								objData.populated = true;
								
								if(objData.level < 3) {
									objData.level++;
								}
								
								objData.imageRotation = -45;
							}
							else {
								objData.daysToSurvive--;
							}
						}
						break;
					}
				}
			}
		}
	}
	
	if(!canLive) {
		objData.level = 0;
		objData.populated = false;
		if(neighbours.current.holding.update) {
			neighbours.current.holding.update(this, field);
		}
	}
	
	if(callback) {
		callback(gameHolder, field.x, field.y);
	}
}

var gameHolder = null;








function GameMonthly(board) {
    for(var i = 0; i < board.boardArray.length; i++) {
        for(var j = 0; j < board.boardArray[i].length; j++) {
            if(board.boardArray[i][j].holding.income) {
                if(!board.boardArray[i][j].holding.populated) {
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

