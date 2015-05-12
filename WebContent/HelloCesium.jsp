<!DOCTYPE html>
<html lang="en">
<head>
<!-- Use correct character set. -->
<meta charset="utf-8">
<!-- Tell IE to use the latest, best version (or Chrome Frame if pre-IE11). -->
<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
<!-- Make the application on mobile take up the full browser screen and disable user scaling. -->
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
<title>Hello Cesium!-CFB</title>
<script src="Cesium/Cesium.js"></script>
<style>
@import url(Cesium/Widgets/widgets.css);

html, body, #cesiumContainer {
	width: 100%;
	height: 100%;
	margin: 0;
	padding: 0;
	overflow: hidden;
}
</style>
</head>
<body>
	<div id="toolbar">
		<input type="button" value="Static Placemark"
			onclick="staticPlacemark();" /> <input type="button"
			value="Add Placemark" onclick="addPlacemark()" /> <input
			type="button" value="Add Label" onclick="addLabel();" /> <input
			type="button" value="Add Symbol" onclick="addSymbol();" /><input
			type="button" value="Draw" onclick="draw();" /><input type="button"
			value="Remove Entity" onclick="removeEntity();" /> <input
			type="button" value="Clear All" onclick="clearEntities();" /> Sun
		Light <input type="checkbox" name="sunLigth" id="sunLigth"
			onchange="showSunLight()" /> <input type="button" value="Africa"
			onclick="gotoAfrica();" /> <input type="button"
			value="CurrentLocation" onclick="currentLocation();" /> <input
			type="button" value="Load KML" onclick="loadKML();" />
	</div>
	<div id="cesiumContainer"></div>
	<div id="loadingOverlay">
		<h1>Loading...</h1>
	</div>
	<script>
		// Cesimu Vars
		var viewer;
		var cesiumPlaceMarkHandler;
		var cesiumTextHandler;
		var cesiumRemoveHandler;
		var cesiumDrawHandler;
		var surfacePosition;

		// Set BingMaps as imagery provider (Sets personal Key)
		var bing = new Cesium.BingMapsImageryProvider(
				{
					url : '//dev.virtualearth.net',
					// CFB Bing Map Key
					key : 'AuMfNIF-3M9B9hjc802uXkT2WkmWvcmRn4VnO2XPenkbHFRwQzX_6UgoWmct4kGt',
					mapStyle : Cesium.BingMapsStyle.AERIAL_WITH_LABELS
				});


		// ///////////////////////////////////
		// CESIUM Script
		viewer = new Cesium.Viewer("cesiumContainer", {
			animation : false,
			baseLayerPicker : false,
			fullscreenButton : true,
			homeButton : true,
			infoBox : true,
			sceneModePicker : true,
			selectionIndicator : false,
			timeline : false,
			navigationHelpButton : true,
			scene3DOnly : false,
			targetFrameRate : 24,
			imageryProvider : bing,
			geocoder : false
		});
		//Allows Script Execution on InfoBox (Youtube, etc...)
		viewer.infoBox.frame.sandbox = "allow-same-origin allow-top-navigation allow-pointer-lock allow-popups allow-forms allow-scripts";

		// ///////////////////////////////////

		//Load Terrain Providers

		//1. Cesium
		/*
		var cesiumTerrainProvider = new Cesium.CesiumTerrainProvider({
		    url: '//cesiumjs.org/stk-terrain/tilesets/world/tiles'
		});
		viewer.terrainProvider = cesiumTerrainProvider;
		 */

		//2. AGI
		var terrainProvider = new Cesium.CesiumTerrainProvider({
			url : '//assets.agi.com/stk-terrain/world',
			requestVertexNormals : true,
			requestWaterMask : true
		});
		viewer.terrainProvider = terrainProvider;

		// Start off looking at Australia.
		/*
		viewer.camera.viewRectangle(Cesium.Rectangle.fromDegrees(114.591,-45.837, 148.970, -5.730));
		 */

		//Add Static Label
		/*
		viewer.entities.add({
			position : Cesium.Cartesian3.fromDegrees(-75.1641667, 39.9522222),
			label : {
				text : 'Philadelphia'
			}
		});
		 */

		//Place Static Centered Placemark
		function staticPlacemark() {
			var centerOfScreen = new Cesium.Cartesian2(
					viewer.canvas.clientWidth / 2,
					viewer.canvas.clientHeight / 2);
			var surfacePosition = viewer.camera.pickEllipsoid(centerOfScreen);
			if (Cesium.defined(surfacePosition)) {
				viewer.entities
						.add({
							name : 'CFB',
							description : '<iframe width="312" height="265" frameborder="0" allowfullscreen="" src="//www.youtube.com/embed/9No-FiEInLA?wmode=transparent" type="text/html" class="youtube-player" title="YouTube video player" sandbox="allow-scripts"></iframe><h1>Description CFB</h1>',
							position : surfacePosition,
							label : {
								text : 'CFB',
								verticalOrigin : Cesium.VerticalOrigin.TOP
							},
							billboard : {
								image : 'images/cursors/place.png',
								verticalOrigin : Cesium.VerticalOrigin.BOTTOM,
							}
						});
			}
		}

		//AddPlacemark on mouse position
		var status = "";
		function addPlacemark() {
			if (status != "Active") {
				status = "Active";
				document.getElementsByTagName("body")[0].style.cursor = "url('http://www.stratalogica.com/NystromDigital/images/cursors/place.png'), auto";
				//Define Handler
				cesiumPlaceMarkHandler = new Cesium.ScreenSpaceEventHandler(
						viewer.canvas);
				cesiumPlaceMarkHandler
						.setInputAction(
								function(movement) {
									var mousePosition = Cesium.Cartesian3
											.clone(movement.position);
									var surfacePosition = viewer.camera
											.pickEllipsoid(mousePosition);
									if (Cesium.defined(surfacePosition)) {
										viewer.entities
												.add({
													name : 'CFB',
													description : '<iframe width="312" height="265" frameborder="0" allowfullscreen="" src="//www.youtube.com/embed/9No-FiEInLA?wmode=transparent" type="text/html" class="youtube-player" title="YouTube video player"></iframe>></iframe><h1>Description</h1>',
													position : surfacePosition,
													label : {
														text : 'CFB',
														verticalOrigin : Cesium.VerticalOrigin.TOP
													},
													billboard : {
														image : 'images/cursors/place.png',
														verticalOrigin : Cesium.VerticalOrigin.BOTTOM
													}
												});
										cesiumPlaceMarkHandler = cesiumPlaceMarkHandler
												&& cesiumPlaceMarkHandler
														.destroy();
										status = "";
										document.getElementsByTagName("body")[0].style.cursor = "auto";
									}
								}, Cesium.ScreenSpaceEventType.LEFT_CLICK);
			} else {
				status = "";
				document.getElementsByTagName("body")[0].style.cursor = "auto";
			}
		}

		//Add label on mouse position
		var statusLabel = "";
		function addLabel() {
			if (statusLabel != "Active") {
				statusLabel = "Active";
				document.getElementsByTagName("body")[0].style.cursor = "url('http://www.stratalogica.com/NystromDigital/images/cursors/text.png'), auto";
				//Define Handler
				cesiumTextHandler = new Cesium.ScreenSpaceEventHandler(
						viewer.canvas);
				cesiumTextHandler
						.setInputAction(
								function(movement) {
									var mousePosition = Cesium.Cartesian3
											.clone(movement.position);
									var surfacePosition = viewer.camera
											.pickEllipsoid(mousePosition);
									if (Cesium.defined(surfacePosition)) {

										var labelValue = 'LabelTest';
										var labelColor = '010101';
										var labelFont = ' Bold Italic Times New Roman 12px';
										viewer.entities.add({
											name : labelValue,
											position : surfacePosition,
											label : {
												text : labelValue,
												scale : 2.0,
												fillColor : Cesium.Color
														.fromCssColorString('#'
																+ labelColor),
												font : labelFont,
												style : Cesium.LabelStyle.FILL
											}
										});
										cesiumTextHandler = cesiumTextHandler
												&& cesiumTextHandler.destroy();
										statusLabel = "";
										document.getElementsByTagName("body")[0].style.cursor = "auto";
									}
								}, Cesium.ScreenSpaceEventType.LEFT_CLICK);
			} else {
				statusLabel = "";
				document.getElementsByTagName("body")[0].style.cursor = "auto";
			}
		}

		//Draw on mouse position
		var statusDraw = false;
		function draw() {
			statusDraw = !statusDraw;
			if (statusDraw) {
				document.getElementsByTagName("body")[0].style.cursor = "url('http://www.stratalogica.com/NystromDigital/images/cursors/draw.png'), auto";
				var color;
				var polyline;
				var drawing = false;
				var positions = [];
				//Define Handler
				cesiumDrawHandler = new Cesium.ScreenSpaceEventHandler(
						viewer.canvas);
				cesiumDrawHandler.setInputAction(function(click) {
					if (drawing) {
						color.alpha = 0.6;
						viewer.entities.add({
							polygon : {
								hierarchy : {
									positions : positions
								},
								material : color
							}
						});
						viewer.entities.remove(polyline);
						positions = [];
					} else {
						color = Cesium.Color.fromRandom({
							alpha : 1.0
						});
						polyline = viewer.entities.add({
							polyline : {
								positions : new Cesium.CallbackProperty(
										function() {
											return positions;
										}, false),
								material : color,
								width : 2.0
							}
						});
					}
					drawing = !drawing;
				}, Cesium.ScreenSpaceEventType.LEFT_CLICK);

				cesiumDrawHandler.setInputAction(function(movement) {
					var surfacePosition = viewer.camera
							.pickEllipsoid(movement.endPosition);
					if (drawing && Cesium.defined(surfacePosition)) {
						positions.push(surfacePosition);
					}
				}, Cesium.ScreenSpaceEventType.MOUSE_MOVE);
			} else {
				document.getElementsByTagName("body")[0].style.cursor = "auto";
				// Remove the handler
				cesiumDrawHandler = cesiumDrawHandler
						&& cesiumDrawHandler.destroy();
			}
		}

		//Elimina un Entity
		var removeStatus = "";
		function removeEntity() {
			if (removeStatus != "Active") {
				removeStatus = "Active";
				document.getElementsByTagName("body")[0].style.cursor = "url('http://www.stratalogica.com/NystromDigital/images/cursors/erase.png'), auto";
				cesiumRemoveHandler = new Cesium.ScreenSpaceEventHandler(
						viewer.canvas);
				cesiumRemoveHandler
						.setInputAction(
								function(click) {
									var pickedObject = viewer.scene
											.pick(click.position);
									if (Cesium.defined(pickedObject)) {
										viewer.entities
												.removeById(pickedObject.id.id);
										cesiumRemoveHandler = cesiumRemoveHandler
												&& cesiumRemoveHandler
														.destroy();
										removeStatus = "";
										document.getElementsByTagName("body")[0].style.cursor = "auto";
									}
								}, Cesium.ScreenSpaceEventType.LEFT_CLICK);
			} else {
				removeStatus = "";
				document.getElementsByTagName("body")[0].style.cursor = "auto";
			}
		}

		//Clear entities
		function clearEntities() {
			viewer.entities.removeAll();
		}

		//Enable Sun Light
		function showSunLight() {
			if (document.getElementById("sunLigth").checked) {
				viewer.scene.globe.enableLighting = true;
			} else {
				viewer.scene.globe.enableLighting = false;
			}
		}
		//Go To Africa
		function gotoAfrica() {
			viewer.camera.flyTo({
				destination : Cesium.Cartesian3.fromDegrees(16.404940,
						1.293838, 14200000),
				duration : 1.0
			});
		}

		//Go to Current Location
		function gotoCurrentLocation(position) {
			viewer.entities.add({
				position : Cesium.Cartesian3.fromDegrees(
						position.coords.longitude, position.coords.latitude),
				ellipse : {
					semiMajorAxis : 100.0,
					semiMinorAxis : 100.0,
					material : new Cesium.ColorMaterialProperty(
							new Cesium.Color(0.2, 0.2, 1.0, 0.5))
				},
				label : {
					text : 'You are here',
					verticalOrigin : Cesium.VerticalOrigin.BOTTOM,
					show : false
				}
			});

			function showLabel() {
				entity.label.show = true;
			}

			viewer.camera.flyTo({
				destination : Cesium.Cartesian3.fromDegrees(
						position.coords.longitude, position.coords.latitude,
						1005.0),
				complete : showLabel
			});
		}

		// Ask browser for location, and fly there.
		function currentLocation() {
			navigator.geolocation.getCurrentPosition(gotoCurrentLocation);
		}

		//Load KML file
		function loadKML() {
			viewer.homeButton.viewModel.command();
			viewer.dataSources
					.add(Cesium.KmlDataSource
							.load('http://cesiumjs.org/Cesium/Apps/SampleData/kml/facilities/facilities.kml'));
		}

		//Detect browser support for CORS
		function checkBrowser() {
			if ('withCredentials' in new XMLHttpRequest()) {
				/* supports cross-domain requests */
				alert("CORS supported (XHR)");
			} else if (typeof XDomainRequest !== "undefined") {
				//Use IE-specific "CORS" code with XDR
				alert("CORS supported (XDR)");
			} else {
				//Time to retreat with a fallback or polyfill
				alert("No CORS Support!");
			}
		}

		//Add Symbol on mouse position
		var statusSymbol = "";
		function addSymbol() {
			if (statusSymbol != "Active") {
				statusSymbol = "Active";
				document.getElementsByTagName("body")[0].style.cursor = "url('http://www.stratalogica.com/NystromDigital/images/cursors/shape.png'), auto";

				//Define Handler
				cesiumSymbolHandler = new Cesium.ScreenSpaceEventHandler(
						viewer.canvas);
				cesiumSymbolHandler
						.setInputAction(
								function(movement) {
									var mousePosition = Cesium.Cartesian3
											.clone(movement.position);
									var surfacePosition = viewer.camera
											.pickEllipsoid(mousePosition);

									var ellipsoid = viewer.scene.globe.ellipsoid;
									var cartesian = viewer.camera
											.pickEllipsoid(mousePosition,
													ellipsoid);
									if (cartesian) {
										var cartographic = ellipsoid
												.cartesianToCartographic(cartesian);
										var longitudeString = Cesium.Math
												.toDegrees(
														cartographic.longitude)
												.toFixed(2);
										var latitudeString = Cesium.Math
												.toDegrees(
														cartographic.latitude)
												.toFixed(2);

										viewer.entities
												.add({
													rectangle : {
														coordinates : Cesium.Rectangle
																.fromDegrees(
																		longitudeString * 1 - 2.5,
																		latitudeString * 1 - 2.5,
																		longitudeString * 1 + 2.5,
																		latitudeString * 1 + 2.5),
														material : 'images/symbols/buildings/DP_Icon_barn.png'
													}

												});
										cesiumSymbolHandler = cesiumSymbolHandler
												&& cesiumSymbolHandler
														.destroy();
										statusSymbol = "";
										document.getElementsByTagName("body")[0].style.cursor = "auto";
									}

								}, Cesium.ScreenSpaceEventType.LEFT_CLICK);

			} else {
				statusSymbol = "";
				document.getElementsByTagName("body")[0].style.cursor = "auto";
			}
		}
	</script>
</body>
</html>