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
            <div class="col-lg-2" style="height: 800px; margin-top: 4%;">
                <div class="well" style="height: 100%">
 
                        <div class="panel panel-success">
                            <div class="panel-heading">Date Range</div>
                            <div class="panel-body">
                                <div class="col-md-12">
                                    <div class="form-group">
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
                                    <div class="form-group">
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
                            <div class="panel-heading">Location Range</div>
                            <div class="panel-body">                    
                                <div class="col-md-12">
                                    <input type="text" class="form-control" placeholder="Min. Latitude" id="txtMinLatitude" />
                                </div>
                                
                                <div class="col-md-12" style="margin-top: 5%">
                                    <input type="text" class="form-control" placeholder="Max. Latitude" id="txtMaxLatitude" />
                                </div>
                    
                                <div class="col-md-12" style="margin-top: 5%">
                                    <input type="text" class="form-control" placeholder="Min. Longitude" id="txtMinLongitude" />
                                </div>
                                
                                <div class="col-md-12" style="margin-top: 5%">
                                    <input type="text" class="form-control" placeholder="Max. Longitude" id="txtMaxLongitude" />
                                </div>
                            </div>
                        </div>
                    
                        <div class="col-md-12" style="margin-top: 10px">
                            <input type="text" class="form-control" placeholder="Min. Magnitude" id="txtMagnitude" />
                        </div>
                    
                        <div class="col-md-12" style="margin-top: 10px">

                            <label for="workType">Data Type:</label>
                            <input type="checkbox" id="workType" checked="checked" data-off-text="Sample" data-on-text="Real" />



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
                            <label for="mapType">Heat Map:</label>
                            <input type="checkbox" id="mapType" data-off-text="Off" data-on-text="On" />
                        </div>
                    
                    
                        <div class="col-md-12" style="margin-top: 15px">
                            <button type="button" class="btn btn-block btn-success" id="btnSearch" onclick="return searchEarthquakes();">Search</button>
                        </div>
                        <%--<div class="col-md-1" style="width: 6%; margin-top: 10px"></div>--%>
                        <div class="col-md-12" style="margin-top: 15px">
                            <button type="button" class="btn btn-block btn-success" id="btnCentralize" onclick="return centralize();">Centralise</button>
                        </div>
                    
                </div>

            </div>
            <div class="col-lg-10" style="height: 800px; margin-top: 4%; padding-left: 1%">
                <div id="map" style="height: 800px;">
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
            <label>6 - 7</label>
            <label>7 < </label>
            <small>Magnitude Scale</small>
        </nav>
    </div>
    
    <div class="row" id="chartRow">
        
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

        $(document).ready(function () {
            init();
        });

        function init() {
            bindDateDesign();
            $("#workType").bootstrapSwitch();
            $("#mapType").bootstrapSwitch();
            loadMap();
            myLayer = L.mapbox.featureLayer();
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
                type: 'bar',
                data: {
                    labels: labelList,
                    datasets: [
                        {
                            label: "# of Earthquakes",
                            data: dataList,
                            backgroundColor: 'rgba(255, 99, 132, 0.2)',
                            borderColor: 'rgba(255,99,132,1)',
                            borderWidth: 1
                        }
                    ]
                },
                options: {
                    scales: {
                        yAxes: [
                            {
                                ticks: {
                                    beginAtZero: true
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
                .setView([39, 35.50], 5);
            map.legendControl.addLegend(document.getElementById('legend').innerHTML);
            map.on('zoomend', function () {
                if (centerLayer != null) {
                    centralizeTest();
                }
            });
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
            map.removeLayer(myLayer);
            //if (centerGeoJson != null)
            //    centerGeoJson = null;
            if (centerLayer != null)
                map.removeLayer(centerLayer);
            if (heat != null)
                map.removeLayer(heat);

            var dateStart = $("#txtStartDate").val();
            var dateEnd = $("#txtEndDate").val();
            var mag = $("#txtMagnitude").val();
            var minLat = $("#txtMinLatitude").val();
            var maxLat = $("#txtMaxLatitude").val();
            var minLng = $("#txtMinLongitude").val();
            var maxLng = $("#txtMaxLongitude").val();
            if ($("#workType").bootstrapSwitch("state")) {
                var res = CentroAjax.GetEarthquakes(dateStart, dateEnd, mag, minLat, maxLat, minLng, maxLng);
                var list = res.value;
                curList = list;
                bindEarthquakes(list);
            } else {
                var res = CentroAjax.GetEarthquakesOffline(dateStart, dateEnd, mag, minLat, maxLat, minLng, maxLng);
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
            res.properties.description = "Mag: " + item.Magnitude + " - Depth: " + item.Depth + " - " + item.AlertType + " - " + item.EventDate;
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
            var step = $("#txtStep").val();
            //var res = CentroAjax.CentralizeTest(curList, step);
            var res = CentroAjax.CentraliseRecursive(curList);
            var list = res.value;
            bindCentralizedEarthquakes(list);
            bindHistograms(list);
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

                document.getElementById(parentId).className = "col-lg-3";
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

        function drawScatterChart(chartId, dataList) {
            var ctx = document.getElementById(chartId).getContext('2d');

            scatterChart = new Chart(ctx, {
                type: 'scatter',
                data: {
                    datasets: [{
                        label: 'Scatter Dataset',
                        data: dataList,
                        backgroundColor: 'rgba(255, 99, 132, 0.7)'
                    }]
                },
                options: {
                    scales: {
                        xAxes: [{
                            type: 'linear',
                            position: 'bottom'
                        }]
                    }
                }
            });
        }
    </script>

</asp:Content>
