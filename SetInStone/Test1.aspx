<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Test1.aspx.cs" Inherits="SetInStone.Scripts.Test1" %>
<%@ Import Namespace="System.Web.Optimization" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%--<link href="HomeSS.css" rel="stylesheet" />--%>
    <meta content='IE=EmulateIE7' http-equiv='X-UA-Compatible' />
    <meta content='width=1100' name='viewport' />
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
    <link rel="stylesheet" href="/resources/demos/style.css" />
    <link rel="stylesheet" href="http://localhost:55153/code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css" />

    <%: Styles.Render("~/Content/bootstrap.css", "~/Content/ProductPage.css") %><%: Scripts.Render("~/bundles/jQuery") %>

     <script>

         var renderer, scene, camera, controls, stats;
         var light, geometry, material, mesh, np;
         var clock = new THREE.Clock();
         var renderers = [];

         //Height of pyramid
         var Pyramid_Height = 1;

         //This will act as width & length as slab
         var Slab_Width = 1, Slab_Length = 1, Slab_Height = 1;

         //Global variables
         var slab;

         var slab1;
         var slab2;

         var parameters;
         var gui;
         var deminsions;
         var slabX, slabY, slabZ;
         var pyramidY;
         var light, slabGeometry, slabMaterial, color, pyramid, assignUVs;

         //default size for new pier cap
         var SLAB_WIDTH = 80; SLAB_LENGTH = 400; SLAB_HEIGHT = 5; PYRAMID_HEIGHT = 20;

         //max dimensions for pier caps
         var MIN_SLAB_WIDTH = 400; MIN_SLAB_LENGTH = 400; MIN_SLAB_HEIGHT = 150; MIN_PYRAMID_HEIGHT = 0;
         var MAX_SLAB_WIDTH = 1200; MAX_SLAB_LENGTH = 1200; MAX_SLAB_HEIGHT = 350; MAX_PYRAMID_HEIGHT = 300;

         //var lblSelectedText = document.getElementById("lblSelectedText");
    </script>

    <title>Set In Stone</title>
</head>
<body>

    <br />
    <br />
    <div id="divTitle">
        <label>Set In Stone</label>
    </div>
            <div id='MainGraphic'>


                <script type='text/javascript'>
                    // var controls, stats;
                    init();


                    function init() {
                        var mainGraphic = document.getElementById('MainGraphic');


                        renderer = new THREE.WebGLRenderer({ antialias: true });
                        renderer.setSize(740, 320);
                        renderer.shadowMapEnabled = true;
                        renderer.shadowMapSoft = true;
                        renderer.domElement.style.border = '5px solid white';

                        mainGraphic.appendChild(renderer.domElement);

                        color = new THREE.Color(0xffffff);


                        scene = new THREE.Scene();

                        camera = new THREE.PerspectiveCamera(140, window.innerWidth / window.innerHeight, 1, 1000);
                        camera.position.set(1, 100, 1);

                        controls = new THREE.TrackballControls(camera, renderer.domElement);

                        light = new THREE.AmbientLight(0xffffff);
                        scene.add(light);

                        light = new THREE.SpotLight(0xffffff);
                        light.position.set(-100, 100, -100);
                        light.castShadow = true;
                        scene.add(light);

                        //Create the slab
                        
                        var combined = new THREE.Geometry();
                        
                        slabGeometry = new THREE.CubeGeometry(SLAB_WIDTH, SLAB_HEIGHT, SLAB_LENGTH); //(100, 15, 100);
                        //var slab2geom = new THREE.CubeGeometry(80, 70, 100);
                        slabMaterial = new THREE.MeshPhongMaterial({ wireframe: true, side: THREE.DoubleSide, transparent: false, opacity: 100 });

                        slab1 = new THREE.Mesh(slabGeometry, slabMaterial);
                        //slab2 = new THREE.Mesh(slab2geom, slabMaterial);

                        slab1.position.set(0, SLAB_HEIGHT , 0);
                        //slab2.position.set(0, SLAB_HEIGHT-48 , 0);


                        //THREE.GeometryUtils.merge(combined, slab1);
                        //THREE.GeometryUtils.merge(combined, slab2);
                        
                        //var mesh = new THREE.Mesh(combined);
                        scene.add(slab1);
                        
                        var geometry = new THREE.SphereGeometry(50, 16, 32, Math.PI /2, 600 , 0, Math.PI);
                        var material = new THREE.MeshBasicMaterial({ color: 0xddddff });
                        mesh = new THREE.Mesh(geometry, material);
                        mesh.material.side = THREE.DoubleSide;
                        scene.add(mesh);

                        gui = new dat.GUI();

                        parameters =
                            {
                                Length: (SLAB_LENGTH * 10), Width: (SLAB_WIDTH * 10), Slab_Height: (SLAB_HEIGHT * 10),    //these will be read from the DB for previous quotes!
                                stone: "Wireframe",
                                //reset: function () { resetPier() }
                            };

                        //Slider UI
                        deminsions = gui.addFolder('Pier Cap Dimensions (mm)');
                        slabX = deminsions.add(parameters, 'Width').min(MIN_SLAB_LENGTH).max(MAX_SLAB_LENGTH).step(1).listen();
                        slabZ = deminsions.add(parameters, 'Length').min(MIN_SLAB_WIDTH).max(MAX_SLAB_WIDTH).step(1).listen();
                        slabY = deminsions.add(parameters, 'Slab_Height').min(MIN_SLAB_HEIGHT).max(MAX_SLAB_HEIGHT).step(1).listen();
                        //pyramidY = deminsions.add(parameters, 'Point_Height').min(MIN_PYRAMID_HEIGHT).max(MAX_PYRAMID_HEIGHT).step(1).listen();
                        deminsions.open();

                      

                       


                        //var sphere = new THREE.Mesh(new THREE.SphereGeometry(100, 16, 12), new THREE.MeshLambertMaterial({ color: 0x2D303D, wireframe: true, shading: THREE.FlatShading }));
                        //var cylinder = new THREE.Mesh(new THREE.CylinderGeometry(100, 100, 200, 16, 4, false), new THREE.MeshLambertMaterial({ color: 0x2D303D, wireframe: true, shading: THREE.FlatShading }));
                        //cylinder.position.y = -100;
                        //scene.add(sphere);
                        //scene.add(cylinder);
                    }
                    
                    slabY.onChange(function (value) {
                        slab1.scale.y = value / (SLAB_HEIGHT * 10);
                        //slab1.position.y = (slab1.scale.y * 25) / 2;
                        //slab1.position.y = ((slab2.position.y ) ) - ((slab1.position.y));

                        
                        //pyramid.position.y = (slab.scale.y * 25);

                        //Put Y scale value in global variable
                        Slab_Height = slab.scale.y;
                    });
                    
                    slabX.onChange(function (value) {
                        mesh.scale.x = value / (SLAB_WIDTH * 10);
                        mesh.position.x = (mesh.scale.x * 25) / 2;
                        //slab1.position.y = ((slab2.position.y ) ) - ((slab1.position.y));


                        //pyramid.position.y = (slab.scale.y * 25);

                        //Put Y scale value in global variable
                        Slab_Height = slab.scale.y;
                    });
                    function callback() { return; }
                    renderers.push({ renderer: renderer, scene: scene, camera: camera, controls: controls, callback: callback });

                </script>

    </div>


    <script>
        //init();
        animate();

        function animate() {
            requestAnimationFrame(animate);
            render();
        }

        function render() {
            var tim = clock.getElapsedTime() * 0.15;
            for (var i = 0, l = renderers.length; i < l; i++) {
                var r = renderers[i];

                r.renderer.render(r.scene, r.camera);
                if (r.stats) { r.stats.update(); }
                if (r.callback) {
                    r.callback();
                } else {
                    r.camera.position.x = 20 * Math.cos(tim);
                    r.camera.position.y = 20 * Math.cos(tim);
                    r.camera.position.z = 20 * Math.sin(tim);
                }
                r.controls.update();
            }
        }

    </script>


    <form id="Form1" runat="server">
        <asp:Label runat="server" ID="lblDisplayPillarStone"></asp:Label>
         <asp:Label ID="lblDisplayStone" runat="server" ClientIDMode="Static" ></asp:Label>
        
         <asp:Button CssClass="Buttons" runat="server" ID="btnCalculate"  Text="Calculate Cost" 
                        OnClientClick="DisplayPryHeight(); DisplaySlabHeight();
        DisplaySlabWidth();  DisplaySlabLength();"  />
        
        
                    <%--Hidden fields for slab and pryamid measurements--%>
                    <asp:HiddenField ID="SlabLength" runat="server" />
                    <asp:HiddenField ID="SlabWidth" runat="server" />
                    <asp:HiddenField ID="PryHeight" runat="server" />
                    <asp:HiddenField ID="SlabHeight" runat="server" />
    </form>
</body>
</html>
