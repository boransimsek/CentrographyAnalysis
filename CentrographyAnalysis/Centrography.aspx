<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Centrography.aspx.cs" Inherits="CentrographyAnalysis.Centrography" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label runat="server" ID="lblTest"></asp:Label>
    <button id="btnTest" onclick="return getMessage();">Test</button>

    <h2>Parameters</h2>
    <div class="well">

        <div class="container">
            <div class="col-md-4">
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
            <div class="col-md-4">
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
                <%--<select name="slider" id="workType" data-role="slider">
                    <option value="off">Offline</option>
                    <option value="on">Online</option>
                </select>--%>
            </div>
            <div class="col-md-2">
                <input type="text" class="form-control" id="txtStep" placeholder="Step Number"/>
            </div>
            <div class="col-md-1"></div>
            <div class="col-md-3">
                <button type="button" class="btn btn-success" id="btnCentralize" onclick="return centralize();">Centralize</button>
            </div>
            <div class="col-md-3">
                <button type="button" class="btn btn-success" id="btnSearch" onclick="return searchEarthquakes();">Search</button>
            </div>
        </div>
        <div class="container" style="margin-top: 15px;">
            <div class="col-md-3">
                <label for="mapType">Map Type:</label>
                <input type="checkbox" id="mapType" data-off-text="Normal" data-on-text="Heat" />
            </div>

        </div>
    </div>
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
    </style>

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


    <div class="row">


        <div class="col-lg-12">
            <div id="map" style="height: 700px;">
            </div>
        </div>

    </div>



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

        $(document).ready(function () {
            init();
        });

        function init() {
            bindDateDesign();
            $("#workType").bootstrapSwitch();
            loadMap();
            myLayer = L.mapbox.featureLayer();
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

        function getMessage() {
            var res = CentrographyAjax.GetResponseFromService();
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
                var res = CentrographyAjax.GetEarthquakes(dateStart, dateEnd, mag, minLat, maxLat, minLng, maxLng);
                var list = res.value;
                curList = list;
                bindEarthquakes(list);
            } else {
                var res = CentrographyAjax.GetEarthquakesOffline(dateStart, dateEnd, mag, minLat, maxLat, minLng, maxLng);
                //var res = CentrographyAjax.GetEarthquakesOffline();
                var list = res.value;
                curList = list;
                bindEarthquakes(list);
            }


        }

        function bindEarthquakes(list) {

            myLayer = L.mapbox.featureLayer();
            heat = L.heatLayer([], { maxZoom: 10 }).addTo(map);
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
                //heat.addLatLng(marker._latlng);
                
            });
            myLayer.setGeoJSON(curGeoJson);
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
            //var res = CentrographyAjax.CentralizeTest(curList, step);
            var res = CentrographyAjax.CentraliseRecursive(curList);
            var list = res.value;
            bindCentralizedEarthquakes(list);
            return false;
        }

        //function drawEllipse() {
        //    Options ellipseOptions = new Options();
        //    ellipseOptions.setProperty("color", "blue");
        //    Ellipse ellipse = new Ellipse(latlng, 500, 100, 0, ellipseOptions);
        //    ellipse.addTo(map);
        //}

        //L.Ellipse = L.Path.extend({
        //    initialize: function (latlng, radii, tilt, options) {
        //        L.Path.prototype.initialize.call(this, options);

        //        this._latlng = L.latLng(latlng);

        //        if (tilt) {
        //            this._tiltDeg = tilt;
        //        } else {
        //            this._tiltDeg = 0;
        //        }

        //        if (radii) {
        //            this._mRadiusX = radii[0];
        //            this._mRadiusY = radii[1];
        //        }
        //    },

        //    options: {
        //        fill: true,
        //        startAngle: 0,
        //        endAngle: 359.9
        //    },

        //    setLatLng: function (latlng) {
        //        this._latlng = L.latLng(latlng);
        //        return this.redraw();
        //    },

        //    setRadius: function (radii) {
        //        this._mRadiusX = radii[0];
        //        this._mRadiusY = radii[1];
        //        return this.redraw();
        //    },

        //    setTilt: function (tilt) {
        //        this._tiltDeg = tilt;
        //        return this.redraw();
        //    },

        //    projectLatlngs: function () {
        //        var lngRadius = this._getLngRadius(),
        //            latRadius = this._getLatRadius(),
        //            latlng = this._latlng,
        //            pointLeft = this._map.latLngToLayerPoint([latlng.lat, latlng.lng - lngRadius]),
        //            pointBelow = this._map.latLngToLayerPoint([latlng.lat - latRadius, latlng.lng]);

        //        this._point = this._map.latLngToLayerPoint(latlng);
        //        this._radiusX = Math.max(this._point.x - pointLeft.x, 1);
        //        this._radiusY = Math.max(pointBelow.y - this._point.y, 1);
        //        this._endPointParams = this._centerPointToEndPoint();
        //    },

        //    getBounds: function () {
        //        var lngRadius = this._getLngRadius(),
        //            latRadius = this._getLatRadius(),
        //            latlng = this._latlng;

        //        return new L.LatLngBounds(
        //                [latlng.lat - latRadius, latlng.lng - lngRadius],
        //                [latlng.lat + latRadius, latlng.lng + lngRadius]);
        //    },

        //    getLatLng: function () {
        //        return this._latlng;
        //    },

        //    getPathString: function () {
        //        var c = this._point,
        //            rx = this._radiusX,
        //            ry = this._radiusY,
        //            phi = this._tiltDeg,
        //            endPoint = this._endPointParams;

        //        if (this._checkIfEmpty()) {
        //            return '';
        //        }

        //        if (L.Browser.svg) {
        //            return 'M' + endPoint.x0 + ',' + endPoint.y0 +
        //                   'A' + rx + ',' + ry + ',' + phi + ',' +
        //                   endPoint.largeArc + ',' + endPoint.sweep + ',' +
        //                   endPoint.x1 + ',' + endPoint.y1 + ' z';
        //        } else {
        //            c._round();
        //            rx = Math.round(rx);
        //            ry = Math.round(ry);
        //            return 'AL ' + c.x + ',' + c.y + ' ' + rx + ',' + ry +
        //                   ' ' + phi + ',' + (65535 * 360);
        //        }
        //    },

        //    getRadius: function () {
        //        return new L.point(this._mRadiusX, this._mRadiusY);
        //    },

        //    // TODO Earth hardcoded, move into projection code!

        //    _centerPointToEndPoint: function () {
        //        // Convert between center point parameterization of an ellipse
        //        // too SVG's end-point and sweep parameters.  This is an
        //        // adaptation of the perl code found here:
        //        // http://commons.oreilly.com/wiki/index.php/SVG_Essentials/Paths
        //        var c = this._point,
        //            rx = this._radiusX,
        //            ry = this._radiusY,
        //            theta2 = (this.options.startAngle + this.options.endAngle) *
        //                     L.LatLng.DEG_TO_RAD,
        //            theta1 = this.options.startAngle * L.LatLng.DEG_TO_RAD,
        //            delta = this.options.endAngle,
        //            phi = this._tiltDeg * L.LatLng.DEG_TO_RAD;

        //        // Determine start and end-point coordinates
        //        var x0 = c.x + Math.cos(phi) * rx * Math.cos(theta1) +
        //            Math.sin(-phi) * ry * Math.sin(theta1);
        //        var y0 = c.y + Math.sin(phi) * rx * Math.cos(theta1) +
        //            Math.cos(phi) * ry * Math.sin(theta1);

        //        var x1 = c.x + Math.cos(phi) * rx * Math.cos(theta2) +
        //            Math.sin(-phi) * ry * Math.sin(theta2);
        //        var y1 = c.y + Math.sin(phi) * rx * Math.cos(theta2) +
        //            Math.cos(phi) * ry * Math.sin(theta2);

        //        var largeArc = (delta > 180) ? 1 : 0;
        //        var sweep = (delta > 0) ? 1 : 0;

        //        return {'x0': x0, 'y0': y0, 'tilt': phi, 'largeArc': largeArc,
        //            'sweep': sweep, 'x1': x1, 'y1': y1};
        //    },

        //    _getLatRadius: function () {
        //        return (this._mRadiusY / 40075017) * 360;
        //    },

        //    _getLngRadius: function () {
        //        return ((this._mRadiusX / 40075017) * 360) / Math.cos(L.LatLng.DEG_TO_RAD * this._latlng.lat);
        //    },

        //    _checkIfEmpty: function () {
        //        if (!this._map) {
        //            return false;
        //        }
        //        var vp = this._map._pathViewport,
        //            r = this._radiusX,
        //            p = this._point;

        //        return p.x - r > vp.max.x || p.y - r > vp.max.y ||
        //               p.x + r < vp.min.x || p.y + r < vp.min.y;
        //    }
        //});

        //L.ellipse = function (latlng, radii, tilt, options) {
        //    return new L.Ellipse(latlng, radii, tilt, options);
        //};
    </script>
</asp:Content>
