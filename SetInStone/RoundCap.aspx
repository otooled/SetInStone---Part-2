<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RoundCap.aspx.cs" Inherits="SetInStone.RoundCap" UnobtrusiveValidationMode="None" %>

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

         var Slab_Width = 1;
         var Slab_Length = 1;
         var Slab_Height = 1;

         var sphere;

         

         var parameters;
         var gui;
         var folder1;
         
         var sphereX;
         var sphereY;
         var sphereZ;
         
         var MIN_SLAB_WIDTH = 400; MIN_SLAB_LENGTH = 400; MIN_SLAB_HEIGHT = 150; MIN_PYRAMID_HEIGHT = 0;
         var MAX_SLAB_WIDTH = 1200; MAX_SLAB_LENGTH = 1200; MAX_SLAB_HEIGHT = 350; MAX_PYRAMID_HEIGHT = 300;
         
         var SLAB_WIDTH = 80; SLAB_LENGTH = 100; SLAB_HEIGHT = 25; PYRAMID_HEIGHT = 20;
         
         </script>

    <title>Set In Stone</title>
</head>
<body>
    <div id='MainGraphic'>


        <script type='text/javascript'>
            // var controls, stats;
            init();

            function init() {
                mainGraphic = document.getElementById('MainGraphic');
                // d = document.body;
                // console.log('hi ', d);

                renderer = new THREE.WebGLRenderer({ antialias: true });
                renderer.setSize(740, 320);
                renderer.shadowMapEnabled = true;
                renderer.shadowMapSoft = true;
                renderer.domElement.style.border = '5px solid white';

                mainGraphic.appendChild(renderer.domElement);

                color = new THREE.Color(0xffffff);

                scene = new THREE.Scene();

                camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 1, 1000);
                camera.position.set(100, 100, 200);

                controls = new THREE.TrackballControls(camera, renderer.domElement);

                light = new THREE.AmbientLight(0xffffff);
                scene.add(light);

                light = new THREE.SpotLight(0xffffff);
                light.position.set(-100, 100, -100);
                light.castShadow = true;
                scene.add(light);

                var sphereGeo = new THREE.SphereGeometry(50, 60, 60, Math.PI, Math.PI, 3 * Math.PI / 2);
                var sphereMaterial = new THREE.MeshBasicMaterial({ color: 0xddddff });
                sphere = new THREE.Mesh(sphereGeo, sphereMaterial);
                sphere.material.side = THREE.DoubleSide;
                scene.add(sphere);

                gui = new dat.GUI();
                
                parameters =
                    {
                        Length: (SLAB_LENGTH * 10), Width: (SLAB_WIDTH * 10), Slab_Height: (SLAB_HEIGHT * 10)
                       // reset: function () { resetPier() }
                    };

                //Slider UI
                folder1 = gui.addFolder('Pier Cap Dimensions (mm)');
                sphereX = folder1.add(parameters, 'Width').min(MIN_SLAB_LENGTH).max(MAX_SLAB_LENGTH).step(1).listen();
                sphereZ = folder1.add(parameters, 'Length').min(MIN_SLAB_WIDTH).max(MAX_SLAB_WIDTH).step(1).listen();
                sphereY = folder1.add(parameters, 'Slab_Height').min(MIN_SLAB_HEIGHT).max(MAX_SLAB_HEIGHT).step(1).listen();
                //pyramidY = folder1.add(parameters, 'Point_Height').min(MIN_PYRAMID_HEIGHT).max(MAX_PYRAMID_HEIGHT).step(1).listen();
                folder1.open();

                var slabConfigData = function () {
                    //slabDiv = document.getElementById('slabControls');
                    this.sphereX = 1.0;
                    this.sphereY = 1.0;
                    this.sphereZ = 1.0;
                    this.wireframe = false;
                    this.opacity = 'full';

                    this.doScale = function () {
                        callback = function () {
                            var tim = clock.getElapsedTime() * 0.7;
                            sphere.scale.x = 1 + Math.sin(tim);
                            sphere.scale.y = 1 + Math.cos(1.5798 + tim);
                            sphere.scale.z = 1 + Math.cos(1.5798 + tim) * Math.cos(tim);
                        }
                        //slabDiv.appendChild(renderer.domElement);
                    };

                };

                //funtion to manipulated pryimed shape
                //var pyrimidConfigData = function () {

                //    //this.scaleX = 1.0;
                //    this.scaleY = 1.0;
                //    //this.scaleZ = 1.0;

                //    this.wireframe = false;
                //    this.opacity = 'full';

                //    this.doScale = function () {
                //        callback = function () {
                //            var tim = clock.getElapsedTime() * 0.7;
                //            //pyrimid.scale.x = 1 + Math.sin(tim);
                //            pyramid.scale.y = 1 + Math.cos(1.5798 + tim);
                //            //pyrimid.scale.z = 1 + Math.cos(1.5798 + tim) * Math.cos(tim);
                //        }

                //    };
                //};
                //functions to alter shape with sliders
                sphereX.onChange(function(value) {
                    sphere.scale.x = value / (SLAB_WIDTH * 10);
                    //pyramid.scale.x = slab.scale.x;
                    //pyramid.scale.z = slab.scale.x;

                    //Put X scale value in global variable
                    //Slab_Length = slab.scale.x;
                });

                sphereY.onChange(function(value) {
                    sphere.scale.y = value / (SLAB_HEIGHT * 10);
                    //sphere.position.y = (sphere.scale.y * 25) / 2;
                    //pyramid.position.y = (slab.scale.y * 25);

                    //Put Y scale value in global variable
                    //Slab_Height = slab.scale.y;
                });

                sphereZ.onChange(function(value) {
                    sphere.scale.z = value / (SLAB_LENGTH * 10);
                    //pyramid.scale.x = slab.scale.z;
                    //pyramid.scale.z = slab.scale.z;

                    ////Put Z scale value in global variable
                    //Slab_Width = slab.scale.z;
                });

                //pyramidY.onChange(function (value) {
                //    pyramid.scale.y = value / (PYRAMID_HEIGHT * 10);
                //    //slab.position.y = (pyramid.scale.y * PYRAMID_HEIGHT) / 2;

                //    //Put pryamid Y scale value in global variable
                //    Pyramid_Height = pyramid.scale.y;
                //    //slab.position.y = (slab.scale.y * 25) / 2;
                //    //pyramid.position.y = (slab.scale.y * 25);
                //});


                function callback() { return; }

                renderers.push({ renderer: renderer, scene: scene, camera: camera, controls: controls, callback: callback });
            }
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
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
