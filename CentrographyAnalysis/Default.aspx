<%@ Page Title="Centrography Analysis" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CentrographyAnalysis._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label runat="server" ID="lblTest"></asp:Label>
    <button id="btnTest" onclick="return getMessage();">Test</button>

    <style>
        .legend label,
        .legend span {
            display: block;
            float: left;
            height: 15px;
            width: 20%;
            text-align: center;
            font-size: 9px;
            color: #808080;
        }

        /*#menu {
            background: #fff;
            position: absolute;
            z-index: 1;
            top: 10px;
            right: 10px;
            border-radius: 3px;
            width: 120px;
            border: 1px solid rgba(0,0,0,0.4);
            font-family: 'Open Sans', sans-serif;
        }

        #menu a {
            font-size: 13px;
            color: #404040;
            display: block;
            margin: 0;
            padding: 0;
            padding: 10px;
            text-decoration: none;
            border-bottom: 1px solid rgba(0,0,0,0.25);
            text-align: center;
        }

        #menu a:last-child {
            border: none;
        }

        #menu a:hover {
            background-color: #f8f8f8;
            color: #404040;
        }

        #menu a.active {
            background-color: #3887be;
            color: #ffffff;
        }

        #menu a.active:hover {
            background: #3074a4;
        }*/
    </style>

    <%--<h2>Parameters</h2>--%>
    <%--    <div class="well" style="margin-top: 4%;">

        <div class="container">
            <div class="col-md-4">
                <div class="form-group">
                    
                    <div class="input-group date" id="dtpStartDate">
                        <input type="text" class="form-control" placeholder="Start Time" id="txtStartDate" />
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>

            </div>
            <div class="col-md-4">
                <div class="form-group">
                    
                    <div class="input-group date" id="dtpEndDate">
                        <input type="text" class="form-control" placeholder="End Time" id="txtEndDate" />
                        <span class="input-group-addon">
                            <span class="glyphicon glyphicon-calendar"></span>
                        </span>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <input type="text" class="form-control" placeholder="Min. Magnitude" id="txtMagnitude" />
            </div>
        </div>
        <div class="container">
            <div class="col-md-2">
                <input type="text" class="form-control" placeholder="Min. Latitude" id="txtMinLatitude" />
            </div>
            <div class="col-md-1"></div>
            <div class="col-md-2">
                <input type="text" class="form-control" placeholder="Max. Latitude" id="txtMaxLatitude" />
            </div>
            <div class="col-md-1"></div>
            <div class="col-md-2">
                <input type="text" class="form-control" placeholder="Min. Longitude" id="txtMinLongitude" />
            </div>
            <div class="col-md-1"></div>
            <div class="col-md-2">
                <input type="text" class="form-control" placeholder="Max. Longitude" id="txtMaxLongitude" />
            </div>
        </div>

        <div class="container" style="margin-top: 15px;">
            <div class="col-md-3">

                <label for="workType">Work Type:</label>
                <input type="checkbox" id="workType" checked="checked" data-off-text="Offline" data-on-text="Online" />
            </div>
            <div class="col-md-2">
                <input type="text" class="form-control" id="txtStep" placeholder="Step (Degrees)" />
            </div>
            <div class="col-md-1"></div>
            <div class="col-md-2">
                <button type="button" class="btn btn-block btn-success" id="btnSearch" onclick="return searchEarthquakes();">Search</button>
            </div>
            <div class="col-md-1"></div>
            <div class="col-md-2">
                <button type="button" class="btn btn-block btn-success" id="btnCentralize" onclick="return centralize();">Centralize</button>
            </div>

        </div>
        <div class="container" style="margin-top: 15px;">
            <div class="col-md-3">
                <label for="mapType">Map Type:</label>
                <input type="checkbox" id="mapType" data-off-text="Normal" data-on-text="Heat" />
            </div>

        </div>
    </div>--%>
    <div class="row">
        <div class="container">
            <div class="col-lg-2" style="height: 840px; margin-top: 4%;">
                <div class="well" style="height: 100%; padding: 15px 7px">

                    <div class="panel panel-success">
                        <div class="panel-heading" style="padding: 5px 15px">Date Range</div>
                        <div class="panel-body" style="padding: 7px">
                            <div class="col-md-12">
                                <div class="form-group" style="margin-bottom: 0;">
                                    <%--<label class="col-sm-2 control-label" for="dtpStartDate">Start Time</label>--%>
                                    <div class="input-group date" id="dtpStartDate">
                                        <input type="text" class="form-control" placeholder="Start Time" id="txtStartDate" />
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group" style="margin-top: 5%; margin-bottom: 0">
                                    <%--<label class="col-sm-2 control-label" for="dtpEndDate">End Time</label>--%>
                                    <div class="input-group date" id="dtpEndDate">
                                        <input type="text" class="form-control" placeholder="End Time" id="txtEndDate" />
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>



                    <div class="panel panel-success">
                        <div class="panel-heading" style="padding: 5px 15px">Location Range</div>
                        <div class="panel-body" style="padding: 7px">
                            <div class="col-md-6" style="padding-right: 5px">
                                <input type="text" class="form-control" placeholder="Min. Latitude" id="txtMinLatitude" />
                            </div>


                            <div class="col-md-6" style="padding-left: 2px">
                                <input type="text" class="form-control" placeholder="Max. Latitude" id="txtMaxLatitude" />
                            </div>

                            <div class="col-md-6" style="margin-top: 3%; padding-right: 5px">
                                <input type="text" class="form-control" placeholder="Min. Longitude" id="txtMinLongitude" />
                            </div>
                            
                            <div class="col-md-6" style="margin-top: 3%; padding-left: 2px">
                                <input type="text" class="form-control" placeholder="Max. Longitude" id="txtMaxLongitude" />
                            </div>
                        </div>
                    </div>

                    <div class="panel panel-success">
                        <div class="panel-heading" style="padding: 5px 15px">Depth & Magnitude Range</div>
                        <div class="panel-body" style="padding: 7px">
                            <div class="col-md-12">
                                <input type="text" class="form-control" placeholder="Min. Depth" id="txtMinDepth" />
                            </div>
                           
                            <div class="col-md-12" style="margin-top: 2%">
                                <input type="text" class="form-control" placeholder="Max. Depth" id="txtMaxDepth" />
                            </div>

                            <div class="col-md-12" style="margin-top: 5%">
                                <input type="text" class="form-control" placeholder="Min. Magnitude" id="txtMagnitude" />
                            </div>

                            <div class="col-md-12" style="margin-top: 2%">
                                <input type="text" class="form-control" placeholder="Max. Magnitude" id="txtMaxMagnitude" />
                            </div>
                        </div>
                    </div>



                    <div class="col-md-12" style="margin-top: 10px">

                        <label for="workType">Data Type:</label>
                        <input type="checkbox" id="workType" checked="checked" data-off-text="Sample" data-on-text="Real" data-size="small"/>



                        <%--<select name="slider" id="workType" data-role="slider">
                                <option value="off">Offline</option>
                                <option value="on">Online</option>
                            </select>--%>
                    </div>
                    <%--                        <div class="col-md-2">
                            <input type="text" class="form-control" id="txtStep" placeholder="Step (Degrees)" />
                        </div>
                        <div class="col-md-1"></div>--%>
                    <div class="col-md-12" style="margin-top: 10px">
                        <label for="isMahalanobis">Distance: </label>
                        <input type="checkbox" id="isMahalanobis" data-off-text="Euclidean" data-on-text="Mahalanobis" data-size="small" width="50%"/>
                    </div>

                    <div class="col-md-12" style="margin-top: 10px">
                        <label for="mapType">Heat Map:</label>
                        <input type="checkbox" id="mapType" data-off-text="Off" data-on-text="On" data-size="small" />
                    </div>
                    <div class="col-md-12" style="margin-top: 10px">
                        <label for="curveFit">Curve Fitting:</label>
                        <input type="checkbox" id="curveFit" data-off-text="Off" data-on-text="On" data-size="small" />
                    </div>

                    <div class="col-md-12" style="margin-top: 20%">
                        <button type="button" class="btn btn-block btn-success" id="btnSearch" onclick="return searchEarthquakes();">Search</button>
                    </div>
                    <%--<div class="col-md-1" style="width: 6%; margin-top: 10px"></div>--%>
                    <div class="col-md-12" style="margin-top: 15px">
                        <button type="button" class="btn btn-block btn-success" id="btnCentralize" onclick="return centralize();">Centralise</button>
                    </div>

                </div>

            </div>
            <div class="col-lg-10" style="height: 840px; margin-top: 4%; padding-left: 1%">
                <div id="map" style="height: 840px;">
                </div>
            </div>
        </div>
    </div>

    <!-- Set the display of this container to none so we can
     add it programmatically to `legendControl` -->
    <div id='legend' style='display: none;'>
        <strong>Centrography Analysis on Earthquakes</strong>
        <nav class='legend clearfix'>
            <span style='background: #19D359;'></span>
            <span style='background: #006999;'></span>
            <span style='background: #BAD00B;'></span>
            <span style='background: #D28611;'></span>
            <span style='background: #E10020;'></span>
            <label>< 3</label>
            <label>3 - 4.9</label>
            <label>5 - 5.9</label>
            <label>6 - 6.9</label>
            <label>7 =< </label>
            <small>Magnitude Scale</small>
        </nav>
    </div>

    <div class="row" id="chartRow" style="margin-top: 4%">
    </div>



    <%--    <div class="row">


        <div class="col-lg-12">
            <div id="map" style="height: 700px;">
            </div>
        </div>

    </div>--%>



    <script type="text/javascript">

        var map;
        var markers = [];
        var myLayer;
        var curGeoJson;
        var curList;
        var centerGeoJson;
        var centerLayer;
        var zoomPixel = [156412.0, 78206.0, 39103.0, 19551.0, 9776.0, 4888.0, 2444.0, 1222.0, 610.984, 305.492, 152.746, 76.373, 38.187, 19.093, 9.547, 4.773, 2.387, 1.193, 0.596, 0.298];
        var heat;
        var toggleableLayerIds = ['contours', 'museums'];
        var centralPoints = [];
        var polylines = [];
        var platePolyLines = [];

        $(document).ready(function () {
            init();
        });

        function init() {
            bindDateDesign();
            $("#workType").bootstrapSwitch();
            $("#mapType").bootstrapSwitch();
            $("#curveFit").bootstrapSwitch();
            $("#isMahalanobis").bootstrapSwitch();
            $("#curveFit").on('switchChange.bootstrapSwitch', function (event, state) {
                if (state) {
                    showPolyLines();
                } else {
                    hidePolyLines();
                }
            });
            loadMap();
            myLayer = L.mapbox.featureLayer();
            //plateLayer = L.mapbox.featureLayer();
            bindPlateLayer();
            //addLayerToggles();

            //initChart();
        }

        function initChart(chartId, dataList, labelList) {
            //var res = CentroAjax.GetEarthquakeHistogram();
            //var list = res.value;
            var ctx = document.getElementById(chartId).getContext('2d');
            //document.getElementById(chartId).className = "col-lg-3";
            //document.getElementById(chartId).style.height = "400px";


            myChart = new Chart(ctx,
            {
                type: 'line',
                data: {
                    labels: labelList,
                    datasets: [
                        {
                            label: "Distance Distribution",
                            data: dataList,
                            backgroundColor: 'rgba(255, 99, 132, 0.2)',
                            borderColor: 'rgba(255,99,132,1)',
                            borderWidth: 1,
                            fill: false
                        }
                    ]
                },
                options: {
                    scales: {
                        xAxes: [{
                            position: 'bottom',
                            display: true,
                            scaleLabel: {
                                display: true,
                                labelString: 'Distance (km)'
                            }
                        }],
                        yAxes: [
                            {
                                ticks: {
                                    beginAtZero: true
                                },
                                display: true,
                                scaleLabel: {
                                    labelString: '# of Earthquakes',
                                    display: true
                                }
                            }
                        ]
                    }
                }
            });
        }

        function loadMap() {
            //L.mapbox.accessToken = 'pk.eyJ1Ijoic2ltc2VrYm8iLCJhIjoiY2lpMDN2ODUyMDRuYXQzbTF4Z3FqNnR3diJ9.lNEjQ2Yb3mrtvOFFwz5B_Q';
            //// Create a map in the div #map
            //map = L.mapbox.map('map', 'mapbox.streets');

            L.mapbox.accessToken = 'pk.eyJ1Ijoic2ltc2VrYm8iLCJhIjoiY2lpMDN2ODUyMDRuYXQzbTF4Z3FqNnR3diJ9.lNEjQ2Yb3mrtvOFFwz5B_Q';
            map = L.mapbox.map('map', 'mapbox.light')
                .setView([0, 0], 2);
            map.legendControl.addLegend(document.getElementById('legend').innerHTML);
            map.on('zoomend', function () {
                if (centerLayer != null) {
                    centralizeTest();
                }
            });
            L.control.scale().addTo(map);
            //heat = L.heatLayer([], { maxZoom: 10 }).addTo(map);
            //map.on("click", function (ev) {
            //    //addMarkerOnClick(ev);
            //});
            //loadFullPlacesList();
        }

        function addLayerToggles() {
            for (var i = 0; i < toggleableLayerIds.length; i++) {
                var id = toggleableLayerIds[i];

                var link = document.createElement('a');
                link.href = '#';
                link.className = 'active';
                link.textContent = id;

                link.onclick = function (e) {
                    var clickedLayer = this.textContent;
                    e.preventDefault();
                    e.stopPropagation();

                    var visibility = map.getLayoutProperty(clickedLayer, 'visibility');

                    if (visibility === 'visible') {
                        map.setLayoutProperty(clickedLayer, 'visibility', 'none');
                        this.className = '';
                    } else {
                        this.className = 'active';
                        map.setLayoutProperty(clickedLayer, 'visibility', 'visible');
                    }
                };

                var layers = document.getElementById('menu');
                layers.appendChild(link);
            }
        }

        function getMessage() {
            var res = CentroAjax.GetResponseFromService();
            alert(res.value);
            return false;
        }

        function bindDateDesign() {
            $("#dtpStartDate").datetimepicker({
                viewMode: 'years',
                format: 'YYYY-MM-DD'
            });
            $("#dtpEndDate").datetimepicker({
                viewMode: 'years',
                format: 'YYYY-MM-DD',
                useCurrent: false
            });
            $("#dtpStartDate").on("dp.change", function (e) {
                $("#dtpEndDate").data("DateTimePicker").minDate(e.date);
            });
        }

        function searchEarthquakes() {
            clearPolylines();
            clearCentrography();
            clearCharts();
            setParametersToDefault();
            map.removeLayer(myLayer);
            //if (centerGeoJson != null)
            //    centerGeoJson = null;
            if (centerLayer != null)
                map.removeLayer(centerLayer);
            if (heat != null)
                map.removeLayer(heat);

            var dateStart = $("#txtStartDate").val();
            var dateEnd = $("#txtEndDate").val();
            var minMag = $("#txtMagnitude").val();
            var maxMag = $("#txtMaxMagnitude").val();

            var minLat = $("#txtMinLatitude").val();
            var maxLat = $("#txtMaxLatitude").val();
            var minLng = $("#txtMinLongitude").val();
            var maxLng = $("#txtMaxLongitude").val();
            var minDepth = $("#txtMinDepth").val();
            var maxDepth = $("#txtMaxDepth").val();
            
            if ($("#workType").bootstrapSwitch("state")) {
                var res = CentroAjax.GetEarthquakes(dateStart, dateEnd, minMag, maxMag, minLat, maxLat, minLng, maxLng, minDepth, maxDepth);
                var list = res.value;
                curList = list;
                bindEarthquakes(list);
            } else {
                var res = CentroAjax.GetEarthquakesOffline(dateStart, dateEnd, minMag, maxMag, minLat, maxLat, minLng, maxLng, minDepth, maxDepth);
                //var res = CentroAjax.GetEarthquakesOffline();
                var list = res.value;
                curList = list;
                bindEarthquakes(list);
            }


        }

        function bindEarthquakes(list) {

            myLayer = L.mapbox.featureLayer();
            heat = L.heatLayer([], { maxZoom: 8 }).addTo(map);
            var isHeat = $("#mapType").bootstrapSwitch('state');

            curGeoJson = {
                type: 'FeatureCollection',
                features: []
            };


            list.forEach(function (item) {
                var resJson = createEarthquakeFeature(item);
                curGeoJson.features.push(resJson);
            });
            myLayer.on('layeradd', function (e) {
                var marker = e.layer,
                    feature = marker.feature;

                marker.setIcon(L.icon(feature.properties.icon));

                if (isHeat) {
                    heat.addLatLng(marker._latlng);
                }


                //heat.addLatLng(marker._latlng);

            });
            myLayer.setGeoJSON(curGeoJson);
            if (!isHeat)
                map.addLayer(myLayer);
            //centralizeTest();
            map.fitBounds(myLayer.getBounds());
        }

        function bindCentralizedEarthquakes(list) {

            //centerLayer = L.mapbox.featureLayer();
            centerGeoJson = {
                type: 'FeatureCollection',
                features: []
            };

            list.forEach(function (item) {
                var resJson = createEarthquakeFeature(item);
                centerGeoJson.features.push(resJson);
            });

            //myLayer.setGeoJSON(curGeoJson);
            //map.addLayer(myLayer);
            centralizeTest();
            //map.fitBounds(myLayer.getBounds());
        }

        function createEarthquakeFeature(item) {
            var res = {};
            res.type = 'Feature';
            res.geometry = {};
            res.geometry.type = 'Point';
            res.geometry.coordinates = [];
            res.geometry.coordinates.push(item.Longitude);
            res.geometry.coordinates.push(item.Latitude);
            res.properties = {};
            res.properties.title = item.Title;
            res.properties.magnitude = item.Magnitude;
            res.properties.description = "<p>Mag: <b>" + item.Magnitude + "</b></p> <p>Depth: <b>" + item.Depth + " km</b></p> <p>Date: <b>" + formatDate(item.EventDate) + "</b></p>";
            res.properties.depth = item.Depth;
            //res.properties['marker-size'] = 'small';
            //res.properties['marker-color'] = '#BE9A6B';
            res.properties.icon = {};

            //res.properties.icon.iconUrl = './Content/Images/bluedot.png';
            res.properties.icon.iconUrl = getIconByMagnitude(item.Magnitude);
            res.properties.icon.className = 'dot';
            var iconSize = getIconSizeByMagnitude(item.Magnitude);
            //res.properties.icon.iconSize = [10,10];
            res.properties.icon.iconSize = [iconSize, iconSize];
            return res;
        }

        function getIconByMagnitude(magnitude) {
            if (magnitude >= 7) {
                return './Content/Images/pin_red.png';
            }
            else if (magnitude < 7 && magnitude >= 6) {
                return './Content/Images/pin_orange.png';
            }
            else if (magnitude < 6 && magnitude >= 5) {
                return './Content/Images/pin_yellow.png';
            }
            else if (magnitude < 5 && magnitude >= 3) {
                return './Content/Images/pin_blue.png';
            } else {
                return './Content/Images/pin_green.png';
            }
        }

        function getIconSizeByMagnitude(magnitude) {
            if (magnitude >= 7) {
                return 30;
            }
            else if (magnitude < 7 && magnitude >= 6) {
                return 25;
            }
            else if (magnitude < 6 && magnitude >= 5) {
                return 20;
            }
            else if (magnitude < 5 && magnitude >= 3) {
                return 15;
            } else {
                return 10;
            }
        }

        function centralizeTest() {
            var test = 4;
            if (centerLayer != null)
                map.removeLayer(centerLayer);
            centerLayer = L.geoJson(centerGeoJson, {
                pointToLayer: function (feature, latlng) {
                    //var circle = L.circleMarker(latlng, {
                    //    // Here we use the `count` property in GeoJSON verbatim: if it's
                    //    // to small or two large, we can use basic math in Javascript to
                    //    // adjust it so that it fits the map better.
                    //    depth: feature.properties.depth,
                    //    magnitude: feature.properties.magnitude,
                    //    //radius: (feature.properties.magnitude * 130000.0) / zoomPixel[map.getZoom()]
                    //    radius: (feature.properties.magnitude * 1000) / zoomPixel[map.getZoom()]
                    //});
                    var circle = L.circle([latlng.lat, latlng.lng], feature.properties.magnitude * 1000);
                    //var icon_live = L.icon({ iconUrl: './Content/marker.png', iconSize: [35, 35] });
                    //feature.properties.icon = icon_live;
                    circle.on("click", function () {
                        alert(this.feature.properties.depth + " " + this.feature.properties.magnitude);
                    });
                    return circle;
                }
            }).addTo(map);
        }

        function centralize() {
            clearPolylines();
            clearCharts();
            setParametersToDefault();

            var step = $("#txtStep").val();
            //var res = CentroAjax.CentralizeTest(curList, step);

            var isMahalanobis = $("#isMahalanobis").bootstrapSwitch('state');
            //isMahalanobis
            var res = CentroAjax.CentraliseRecursive(curList, isMahalanobis);
            var list = res.value;
            bindCentralizedEarthquakes(list);
            bindHistograms(list);
            bindScatterChart(list);
            drawFitCurve(curList, 1);
            drawFitCurve(curList, 2);
            return false;
        }

        function bindHistograms(list) {
            var count = 1;
            list.forEach(function (item) {
                var parentId = 'parent' + count;
                var chartId = 'chart' + count;


                jQuery('<div/>', {
                    id: parentId,
                }).appendTo('#chartRow');

                document.getElementById(parentId).className = "col-lg-5";
                //document.getElementById(parentId).style.height = "400px";

                jQuery('<canvas/>', {
                    id: chartId,
                }).appendTo('#' + parentId);


                //var chart = document.getElementById('chartId').getContext('2d');
                var res = CentroAjax.GetHistogram(item, curList);
                var histData = res.value;
                initChart(chartId, histData.HistogramData, histData.Labels);
                count++;
            });
        }

        function bindScatterChart(list) {
            var count = 1;

            list.forEach(function (item) {
                var parentId = 'parentSc' + count;
                var chartId = 'chartSc' + count;


                jQuery('<div/>', {
                    id: parentId,
                }).appendTo('#chartRow');

                document.getElementById(parentId).className = "col-lg-9";
                //document.getElementById(parentId).style.height = "400px";

                jQuery('<canvas/>', {
                    id: chartId,
                }).appendTo('#' + parentId);


                //var chart = document.getElementById('chartId').getContext('2d');
                //var res = CentroAjax.GetScatterData(item, curList);
                var res = CentroAjax.GetBubbleData(item, curList);
                var histData = res.value;
                drawScatterChart(chartId, histData);
                count++;
            });
        }



        function drawScatterChart(chartId, dataList) {
            var ctx = document.getElementById(chartId).getContext('2d');

            scatterChart = new Chart(ctx, {
                type: 'bubble',
                data: {
                    datasets: [{
                        label: 'Earthquake Scatter Chart',
                        data: dataList,
                        backgroundColor: 'rgba(255, 99, 132, 0.3)'
                    }]
                },
                options: {
                    scales: {
                        xAxes: [{
                            type: 'linear',
                            position: 'bottom',
                            display: true,
                            scaleLabel: {
                                display: true,
                                labelString: 'Latitude'
                            }
                        }],
                        yAxes: [
                        {
                            display: true,
                            scaleLabel: {
                                labelString: 'Longitude',
                                display: true
                            }
                        }]
                    }
                }
            });
        }

        //scales: {
        //        xAxes: [{
        //            display: true,
        //            scaleLabel: {
        //                display: true,
        //                labelString: 'Month'
        //            }
        //        }],
        //        yAxes: [{
        //            display: true,
        //            scaleLabel: {
        //                display: true,
        //                labelString: 'Value'
        //            }
        //        }]
        //}

        function drawFitCurve(list, order) {
            var res = CentroAjax.GetCurveData(list, order);
            var curveList = res.value;
            var curveLatLng = [];

            curveList.forEach(function (item) {
                var latLng = new L.LatLng(item.Latitude, item.Longitude);
                curveLatLng.push(latLng);
            });

            //var pointA = new L.LatLng(20.635308, 70.22496);
            //var pointB = new L.LatLng(30.984461, 80.70641);
            //var pointList = [pointA, pointB];

            var polyline = new L.Polyline(curveLatLng, {
                color: 'blue',
                weight: 3,
                opacity: 0.5,
                smoothFactor: 1
            });

            polylines.push(polyline);
            //var polyline = L.polyline(curveList, { color: 'blue' }).addTo(map);


            //var routeLayer = L.mapbox.featureLayer();
            //routeJSON = {
            //    type: 'FeatureCollection',
            //    features: []
            //};


            //routeLayer.setGeoJSON(routeJSON);
            //map.addLayer({
            //    "id": "route",
            //    "type": "line",
            //    "source": {
            //        "type": "geojson",
            //        "data": {
            //            "type": "Feature",
            //            "properties": {},
            //            "geometry": {
            //                "type": "LineString",
            //                "coordinates": [
            //                    [-122.48369693756104, 37.83381888486939],
            //                    [-122.48348236083984, 37.83317489144141],
            //                    [-122.48339653015138, 37.83270036637107],
            //                    [-122.48356819152832, 37.832056363179625],
            //                    [-122.48404026031496, 37.83114119107971],
            //                    [-122.48404026031496, 37.83049717427869],
            //                    [-122.48348236083984, 37.829920943955045],
            //                    [-122.48356819152832, 37.82954808664175],
            //                    [-122.48507022857666, 37.82944639795659],
            //                    [-122.48610019683838, 37.82880236636284],
            //                    [-122.48695850372314, 37.82931081282506],
            //                    [-122.48700141906738, 37.83080223556934],
            //                    [-122.48751640319824, 37.83168351665737],
            //                    [-122.48803138732912, 37.832158048267786],
            //                    [-122.48888969421387, 37.83297152392784],
            //                    [-122.48987674713133, 37.83263257682617],
            //                    [-122.49043464660643, 37.832937629287755],
            //                    [-122.49125003814696, 37.832429207817725],
            //                    [-122.49163627624512, 37.832564787218985],
            //                    [-122.49223709106445, 37.83337825839438],
            //                    [-122.49378204345702, 37.83368330777276]
            //                ]
            //            }
            //        }
            //    },
            //    "layout": {
            //        "line-join": "round",
            //        "line-cap": "round"
            //    },
            //    "paint": {
            //        "line-color": "#888",
            //        "line-width": 8
            //    }
            //});
        }

        function showPolyLines() {
            polylines.forEach(function (polyline) {
                polyline.addTo(map);
            });
        }

        function hidePolyLines() {
            polylines.forEach(function (item) {
                map.removeLayer(item);
            });
        }


        function clearPolylines() {
            polylines.forEach(function (item) {
                map.removeLayer(item);
            });

            polylines = [];
        }

        function clearCharts() {
            var myNode = document.getElementById("chartRow");
            while (myNode.firstChild) {
                myNode.removeChild(myNode.firstChild);
            }
        }

        function clearCentrography() {
            if (centerLayer != null)
                map.removeLayer(centerLayer);
            centerLayer = null;
        }

        function setParametersToDefault() {
            $('#curveFit').bootstrapSwitch('state', false, true);
        }

        function bindPlateLayer() {
            var result = CentroAjax.BindPlateBoundaries();
            var list = result.value;

            list.forEach(function (item) {
                drawPlatePolyLines(item);
            });

            showPlates();

        }

        function drawPlatePolyLines(lineList) {
            var plateLatLng = [];
            var list = lineList.BoundaryList;
            list.forEach(function (item) {
                var latLng = new L.LatLng(item.Longitude, item.Latitude);
                plateLatLng.push(latLng);
            });

            //var pointA = new L.LatLng(20.635308, 70.22496);
            //var pointB = new L.LatLng(30.984461, 80.70641);
            //var pointList = [pointA, pointB];

            var polyline = new L.Polyline(plateLatLng, {
                color: 'red',
                weight: 1,
                opacity: 0.5,
                smoothFactor: 1
            });

            platePolyLines.push(polyline);
            //var polyline = L.polyline(curveList, { color: 'blue' }).addTo(map);
        }

        function showPlates() {
            platePolyLines.forEach(function (polyline) {
                polyline.addTo(map);
            });
        }

        function hidePlates() {
            platePolyLines.forEach(function (item) {
                map.removeLayer(item);
            });
        }


        function clearPlates() {
            platePolyLines.forEach(function (item) {
                map.removeLayer(item);
            });

            platePolyLines = [];
        }

        function formatDate(date) {


            return date.format("dd.MM.yyyy HH:mm");
            //var day = date.getDate();
            //var monthIndex = date.getMonth();
            //var year = date.getFullYear();

            //return padLeftWithZero(day) + '.' + padLeftWithZero((monthIndex + 1)) + '.' + year + " " + padLeftWithZero(date.getHours()) + ":" + padLeftWithZero(date.getMinutes());
        }

        function padLeftWithZero(text) {
            var pad = "00";
            var result = pad.substring(0, pad.length - text.length) + text;
            return result;
        }
    </script>

</asp:Content>
