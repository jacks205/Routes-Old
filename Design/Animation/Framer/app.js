
/**
 * Set up Structure
 */

var App = {};
App.Animations = {};

App.Animations.animationCurve = "spring(600,40,500)"

// Set up the screen
App.Screen = new View({
	width: 320, height: 568
});
App.Screen.midX = window.innerWidth / 2;
App.Screen.midY = window.innerHeight / 2 - 100;
App.Screen.style["margin-top"] = "100px";
App.Screen.style["background"] = "#232323";

// Set up the header
App.Header = new ImageView({
	width: 320, height: 65,
	image: "img/header.png"
});
App.Header.superView = App.Screen;

// Setup table view
App.Table = new View({
    width: 320, height: 568 - App.Header.height,
    x: 0, y: App.Header.maxY
});
App.Table.superView = App.Screen;

// Setup first item
App.TableItemOne = new View({
    width: 320, height: 169.5,
    x: 0, y: 0
});
App.TableItemOne.superView = App.Table;

App.TableItemOnePrimary  = new ImageView({
    width: 320, height: 83,
    image: "img/1primary.png"
});
App.TableItemOnePrimary.superView = App.TableItemOne;

App.TableItemOneSecondary  = new ImageView({
    width: 320, height: 83,
    image: "img/1secondary.png",
    x: 0, y: App.TableItemOnePrimary.maxY
});
App.TableItemOneSecondary.superView = App.TableItemOne;

App.EditButtonOne = new ImageView({
    width: 107, height: 83.5,
    image: "img/gearBG.png",
    x: App.TableItemOne.maxX - 107, y: App.Header.maxY,
    opacity: 1
});
App.EditButtonOne.superView = App.Screen;
App.EditButtonOne.placeBehind(App.TableItemOne);

App.DeleteButtonOne = new ImageView({
    width: 107, height: 83.5,
    image: "img/deleteBG.png",
    x: App.TableItemOne.maxX - 107, y: App.EditButtonOne.maxY,
    opacity: 1
});
App.DeleteButtonOne.superView = App.Screen;
App.DeleteButtonOne.placeBehind(App.TableItemOne);

App.EditIconOne = new ImageView({
    width: 23.5, height: 23.5,
    image: "img/gear.png",
    x: (App.EditButtonOne.width / 2) - (23.5/2), y: (App.EditButtonOne.height / 2) - (23.5/2),
    scale: 0.1
});
App.EditIconOne.superView = App.EditButtonOne;

App.DeleteIconOne = new ImageView({
    width: 18, height: 18,
    image: "img/delete.png",
    x: (App.DeleteButtonOne.width / 2) - (18/2), y: (App.DeleteButtonOne.height / 2) - (18/2),
    scale: 0.1
});
App.DeleteIconOne.superView = App.DeleteButtonOne;

// Set up table item animations
App.Animations.slideToEdit = function(tableItem, editIcon, deleteIcon) {


	slideToOpen = function() {

		tableItem.transitioning = true;

		animation1 = tableItem.animate({
			properties: {x:-107},
			curve: App.Animations.animationCurve
		});

		animation2 = editIcon.animate({
			properties: {scale:0.99},
			curve: App.Animations.animationCurve
		});

		animation3 = deleteIcon.animate({
			properties: {scale:0.99},
			curve: App.Animations.animationCurve
		});

		animation3.on("end", function() {
			tableItem.transitioning = false;
		});

	};

	slideToClose = function() {
		tableItem.transitioning = true;

		animation1 = tableItem.animate({
			properties: {x:0},
			curve: App.Animations.animationCurve
		});

		animation2 = editIcon.animate({
			properties: {scale:0.1},
			curve: App.Animations.animationCurve
		});

		animation3 = deleteIcon.animate({
			properties: {scale:0.1},
			curve: App.Animations.animationCurve
		});

		animation3.on("end", function() {
			tableItem.transitioning = false;
		});
	};

	toggler = utils.toggle(slideToOpen, slideToClose);

	tableItem.on("click", function() {

		if(tableItem.transitioning) return;

		toggler()(tableItem);
	});
};

App.Animations.slideToEdit(App.TableItemOne, App.EditIconOne, App.DeleteIconOne);
