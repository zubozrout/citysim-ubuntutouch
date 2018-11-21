"use strict";

function CityData(data) {
	data = data || {};
	this.basics = this.getBasics(data.basics);
	this.status = data.status || this.getStatusDefaults();
	this.zones = data.zones || this.getZoneDefaults();
	this.services = data.services || this.getServicesDefaults();
}

CityData.prototype.getBasics = function(data) {
	data = data || {};
	return {
		money: data.money || 30000,
		population: data.population || 0,
		income: data.income || 0,
		date: data.date ? new Date(data.date) : new Date(1990, 1, 1)
	};
}

CityData.prototype.getStatusDefaults = function() {
	return {
		electricity: 0,
		water: 0
	};
}

CityData.prototype.getZoneDefaults = function() {
	return {
		count: 0,
		industrial: {
			total: 0,
			populated: 0,
			demand: 0
		},
		residential: {
			total: 0,
			populated: 0,
			demand: 0
		},
		commercial: {
			total: 0,
			populated: 0,
			demand: 0
		}
	};
}

CityData.prototype.getServicesDefaults = function() {
	return {
		fire: {
			
		},
		police: {
			
		},
		school: {
			
		},
		health: {
			
		},
		transport: {
			
		},
		water: {
			capacity: 50
		},
		electricity: {
			capacity: 50
		}
	};
}

CityData.prototype.toJson = function() {
	var object = {};
	object.basics = this.basics;
	object.status = this.status;
	object.zones = this.zones;
	object.services = this.services;
	return object;
}
