<%@ Page Title="Centrography Analysis" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DesignTestPage.aspx.cs" Inherits="CentrographyAnalysis.DesignTestPage" %>

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
                            <button type="button" class="btn btn-block btn-success" id="btnCentralize" onclick="return centralize();">Centralize</button>
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
    
    
    <div class="row">
        <div class="col-lg-5">
            <canvas id="myChart" style="height: 400px"></canvas>
        </div>
    </div>

    <%--<nav id="menu"></nav>--%>

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

        $(document).ready(function () {
            init();
        });

        function init() {
            bindDateDesign();
            $("#workType").bootstrapSwitch();
            $("#mapType").bootstrapSwitch();
            loadMap();
            myLayer = L.mapbox.featureLayer();

            initChart();
            //addLayerToggles();
        }

        function initChart() {
            var ctx = document.getElementById("myChart").getContext('2d');

            scatterChart = new Chart(ctx, {
                type: 'scatter',
                data: {
                    datasets: [{
                        label: 'Scatter Dataset',
                        data: [{
                            x: -10,
                            y: 0
                        }, {
                            x: 0,
                            y: 10
                        }, {
                            x: 10,
                            y: 5
                        }, {
                            x: 25.7,
                            y: -10
                        }, {
                            x: -23.2,
                            y: 15
                        }, {
                            x: -4,
                            y: -64
                        }],
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
            //myChart = new Chart(ctx,
            //{
            //    type: 'line',
            //    data: {
            //        labels: ["Red", "Blue", "Yellow", "Purple", "Orange"],
            //        datasets: [
            //            {
            //                label: "# of Votes",
            //                data: [12, 19, 3, 5, 2, 3],
            //                backgroundColor: [
            //                    'rgba(255, 99, 132, 0.2)'

            //                ],
            //                borderColor: [
            //                    'rgba(255,99,132,1)'
            //                ],
            //                borderWidth: 1
            //            }
            //        ]
            //    },
            //    options: {
            //        scales: {
            //            yAxes: [
            //                {
            //                    ticks: {
            //                        beginAtZero: true
            //                    }
            //                }
            //            ]
            //        }
            //    }
            //});
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

        function bindDateDesign() {
            $("#dtpStartDate").datetimepicker({
                viewMode: 'years',
                format: 'DD.MM.YYYY',
                showTodayButton: true
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
    </script>
</asp:Content>

