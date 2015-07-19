<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FirePlace.aspx.cs" Inherits="SetInStone.FirePlace" UnobtrusiveValidationMode="None" %>

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
        
        var renderer, scene, camera, controls, stats, slab_scene;
        var light, geometry, material, mesh, np;
        var clock = new THREE.Clock();
        var renderers = [];
        
        //This will act as width & length as slab
        var Top_Slap_Height = 1, Side_Slab_Width = 1, Side_Slab_Height = 1;

        //Global variables
        var topSlab;
        var sideSlab;
        var rightSlab;

        var fireplace_parameters;
        var firePlace_gui;
        var fireplace_deminsions;
        var topSlabY;
        var sideSlabY;
        var sideSlabZ;
        var fireplace_depth;

        var light, topSlabGeometry, sideSlabGeometry, right_sideSlabGeometry, slabMaterial, color;
        
        //default size for top slab cap
        var TOP_SLAB_WIDTH = 40; TOP_SLAB_LENGTH = 500; TOP_SLAB_HEIGHT = 120;
        
        //default size for side slab
        var SIDE_SLAB_WIDTH = 40; SIDE_SLAB_LENGTH = 120; SIDE_SLAB_HEIGHT = 150;
        FIREPLACE_DEPTH = 40;
        
        //default size for side slab
        var RIGHT_SIDE_SLAB_WIDTH = 40; RIGHT_SIDE_SLAB_LENGTH = 120; RIGHT_SIDE_SLAB_HEIGHT = 150;
       
        
        //max dimensions for top slab caps
        var MIN_TOP_SLAB_HEIGHT = 110; 
        var MAX_TOP_SLAB_HEIGHT = 160;
        
        //max dimensions for side slab - left side
        var MIN_SIDE_SLAB_HEIGHT = 100;
        var MAX_SIDE_SLAB_HEIGHT = 400;
        
        var MIN_SIDE_SLAB_WIDTH = 30;
        var MAX_SIDE_SLAB_WIDTH = 45;
        
        
        
        //Depth demensions for fireplace
        var MIN_FIREPLACE_DEPTH = 40;
        var MAX_FIREPLACE_DEPTH = 150;
        
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

                camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 1, 1000);
               // camera.position.set(10, 100, 200);
                camera.position.x = 800;
                camera.position.y = 100;
                camera.position.z = 10;
                camera.lookAt(scene.position);
                
               // camera.target.position.y = 150;


                controls = new THREE.TrackballControls(camera, renderer.domElement);

                light = new THREE.AmbientLight(0xffffff);
                scene.add(light);

                light = new THREE.SpotLight(0xffffff);
                light.position.set(-100, 100, -100);
                light.castShadow = true;
                scene.add(light);

                //Create the slab

                topSlabGeometry = new THREE.CubeGeometry(TOP_SLAB_WIDTH, TOP_SLAB_HEIGHT, TOP_SLAB_LENGTH);
                slabMaterial = new THREE.MeshPhongMaterial({ wireframe: true, side: THREE.DoubleSide, transparent: false, opacity: 100 });
                topSlab = new THREE.Mesh(topSlabGeometry, slabMaterial);
                topSlab.position.set(0, 45, 0);
                
                // Create left slab of fireplace
                sideSlabGeometry = new THREE.CubeGeometry(SIDE_SLAB_WIDTH, SIDE_SLAB_HEIGHT, SIDE_SLAB_LENGTH);
                sideSlab = new THREE.Mesh(sideSlabGeometry, slabMaterial);
                sideSlab.position.set(0, -90, 180);
                
                //Create right side slab
                right_sideSlabGeometry = new THREE.CubeGeometry(SIDE_SLAB_WIDTH, SIDE_SLAB_HEIGHT, SIDE_SLAB_LENGTH);
                rightSlab = new THREE.Mesh(right_sideSlabGeometry, slabMaterial);
                rightSlab.position.set(0, -90,-180);

                scene.add(topSlab, sideSlab, rightSlab);
                
                

                //var geometry = new THREE.SphereGeometry(50, 16, 32, Math.PI /2, 600 , 0, Math.PI);
                //var material = new THREE.MeshBasicMaterial({ color: 0xddddff });
                //mesh = new THREE.Mesh(geometry, material);
                //mesh.material.side = THREE.DoubleSide;
                //scene.add(mesh);

                firePlace_gui = new dat.GUI();

                fireplace_parameters =
                    {
                        Top_Slab_Height: (TOP_SLAB_HEIGHT), Side_Slab_Height:(SIDE_SLAB_HEIGHT),Side_Slab_Width:(SIDE_SLAB_WIDTH),
                        stone: "Wireframe",
                        //reset: function () { resetPier() }
                    };

                //Slider UI
                fireplace_deminsions = firePlace_gui.addFolder('Fireplace Dimensions (mm)');
                //slabX = topSlab_deminsions.add(parameters, 'Width').min(MIN_SLAB_LENGTH).max(MAX_SLAB_LENGTH).step(1).listen();
                //slabZ = topSlab_deminsions.add(parameters, 'Length').min(MIN_SLAB_WIDTH).max(MAX_SLAB_WIDTH).step(1).listen();
                topSlabY = fireplace_deminsions.add(fireplace_parameters, 'Top_Slab_Height').min(MIN_TOP_SLAB_HEIGHT).max(MAX_TOP_SLAB_HEIGHT).step(1).listen();
                
                sideSlabY = fireplace_deminsions.add(fireplace_parameters, 'Side_Slab_Height').min(MIN_SIDE_SLAB_HEIGHT).max(MAX_SIDE_SLAB_HEIGHT).step(1).listen();
                sideSlabZ = fireplace_deminsions.add(fireplace_parameters, 'Side_Slab_Width').min(MIN_SIDE_SLAB_WIDTH).max(MAX_SIDE_SLAB_WIDTH).step(1).listen();
                //fireplace_depth = fireplace_deminsions.add(fireplace_parameters, 'Side_Slab_Width').min(MIN_SIDE_SLAB_WIDTH).max(MAX_SIDE_SLAB_WIDTH).step(1).listen();
                fireplace_deminsions.open();

                var fireplaceSlabMaterial = firePlace_gui.add(fireplace_parameters, 'stone', ["Wireframe", "Granite", "Sandstone", "Limestone"]).name
                ('Stone Type').listen();

                fireplaceSlabMaterial.onChange(function(value) {
                    updateFireplace();
                });
                
                //change texture of slab when stone type is changed
                //This also puts displays the stone type selected
                function
                    updateFireplace() {
                    var value = fireplace_parameters.stone;
                    var newMaterial;
                    if (value == "Granite") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/granite2.jpg"), shading: THREE.FlatShading, overdraw: true });


                    } else if (value == "Sandstone") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/sandstone2.jpg") });

                    } else if (value == "Limestone") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/limestone2.jpg") });

                    } else // (value == "Wireframe")
                        newMaterial = new THREE.MeshBasicMaterial({ wireframe: true });

                    topSlab.material = newMaterial;
                    sideSlab.material = newMaterial;
                    rightSlab.material = newMaterial;

                    animate();
                }

                topSlabY.onChange(function(value) {
                    topSlab.scale.y = value / (TOP_SLAB_HEIGHT );
                    //topSlab.position.y = (topSlab.scale.y * 25) / 2;
                    sideSlab.position.y = (topSlab.scale.y * (-7.5 * 12.10)) ;

                    //Put Y scale value in global variable
                    //Slab_Height = slab.scale.y;
                });
                
                sideSlabY.onChange(function(value) {
                    sideSlab.scale.y = value / (SIDE_SLAB_HEIGHT);
                    rightSlab.scale.y = value / (SIDE_SLAB_HEIGHT);


                    topSlab.position.y = (sideSlab.position.y + TOP_SLAB_HEIGHT /2) + (sideSlab.scale.y *75) ;
                    //(slab.position.y + SLAB_HEIGHT / 2) + (slab.scale.y * 8) - 8;

                   
                    //rightSlab.position.y = (sideSlab.scale.y * SIDE_SLAB_HEIGHT)*50;
                   // slab.position.y = (slab.scale.y * 25) / 2;

                    //Put Y scale value in global variable
                    //Slab_Height = slab.scale.y;
                });
                
                sideSlabZ.onChange(function (value) {
                    sideSlab.scale.z = value / (SIDE_SLAB_WIDTH);
                    rightSlab.scale.z = value / (SIDE_SLAB_WIDTH);
                    //topSlab.scale.x = value / (SIDE_SLAB_LENGTH);


                    //Put Y scale value in global variable
                    //Slab_Height = slab.scale.y;
                });

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
    
    <div>
    
    </div>
   
</body>
</html>
