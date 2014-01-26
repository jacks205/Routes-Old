
/**
 * Setup Structure (app.views.pageName.viewName)
 */

var app = {};
app.views = {};

/**
 * Setup Structure (app.views.pageName.viewName)
 */
app.views.HOME.tableView = {};

// Create the app view
appView = new View({
	width:320, height:568
});

appView.style.background = "#232323";

// Place it center screen
appView.midX = window.innerWidth / 2;
appView.midY = window.innerHeight / 2 - 100;
appView.style.marginTop = "100px";

appView.scale = 0.1;
	appView.animate({
		properties: {scale:1},
		curve: "ease-in-out",
		time: 350
	});

// Bounce on a click
appView.on("click", function() {

});

headerView = new ImageView({
	width:320, height:65,
	image: "img/header.png"
});

appView.addSubView(headerView);

item1View = new View({
	width:320, height:167,
	x: 0, y: headerView.maxY
});

//item1View.style.border = "1px solid red";
appView.addSubView(item1View);

primary1View = new ImageView({
	width: 320, height: 86,
	image: "img/1primary.png"
});

item1View.addSubView(primary1View);

// Slide
item1View.open = false;


/**
 * Edit & Delete Buttons
 */

gearBG1View = new ImageView({
	width: 107, height: 83.5,
	image: "img/gearBG.png",
	x: item1View.maxX - 107,
	opacity: 1
});

item1View.addSubView(gearBG1View);

deleteBG1View = new ImageView({
	width: 107, height: 83.5,
	image: "img/deleteBG.png",
	x: item1View.maxX - 107, y: 83.5,
	opacity: 1
});

gearIconView = new ImageView({
	width: 23.5, height: 23.5,
	image: "img/gear.png",
	x: 41.75, y: 33, // Hacky, no idea why normal values and variables dont work here
	scale: 0
});

gearBG1View.addSubView(gearIconView);


item1View.addSubView(deleteBG1View);

gearBG1View.placeBehind(primary1View);
deleteBG1View.placeBehind(primary1View);

/**
 * Interactions
 */

item1View.on("click", function() {

	if(item1View.open === true) {
		console.log("Closing: " + gearIconView.scale);
		primary1View.animate({
			properties: {x:0},
			curve: "ease-in-out",
			time: 150
		});

		gearAnimation = gearIconView.animate({
			properties: {scale:0},
			curve: "ease-in-out",
			time: 150
		});


		item1View.open = false;
	} else {
		console.log("Opening: " + gearIconView.scale);
		primary1View.animate({
			properties: {x:-107},
			curve: "ease-in-out",
			time: 150
		});

		gearIconView.animate({
			properties: {scale:1},
			curve: "ease-in-out",
			time: 150
		});

		item1View.open = true;
	}

});