<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SquarePillar.aspx.cs" Inherits="SetInStone.SquarePillar" UnobtrusiveValidationMode="None" %>

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


        //This will act as width & length as slab
        var Pillar_Width = 1;
        var Pillar_Length = 1;
        var Pillar_Height = 1;

        //Global variables
        var pillar;

        var parameters;
        var gui;
        var deminsions;

        var pillarX;
        var pillarY;
        var pillarZ;

        var light, pillarGeometry, pillarMaterial, color, assignUVs;

        //default size for new pier cap
        var PILLAR_WIDTH = 80; PILLAR_LENGTH = 100; PILLAR_HEIGHT = 150;

        //max dimensions for pier caps
        var MIN_PILLAR_WIDTH = 400; MIN_PILLAR_LENGTH = 400; MIN_PILLAR_HEIGHT = 500;
        var MAX_PILLAR_WIDTH = 1200; MAX_PILLAR_LENGTH = 1200; MAX_PILLAR_HEIGHT = 2000;

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


                //Load textures
                //var stoneTex = new THREE.ImageUtils.loadTexture("Textures/gridcomb.gif");
                //stoneTex.wrapS = THREE.RepeatWrapping;
                //stoneTex.anisotropy = 16;
                //stoneTex.minFilter = THREE.LinearFilter;
                //stoneTex.magFilter = THREE.LinearFilter;

                //stoneTex.repeat.x = 1;
                //stoneTex.repeat.y = 1;

                scene = new THREE.Scene();

                camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 1, 1000);
                camera.position.set(100, 100, 350);

                controls = new THREE.TrackballControls(camera, renderer.domElement);

                light = new THREE.AmbientLight(0xffffff);
                scene.add(light);

                light = new THREE.SpotLight(0xffffff);
                light.position.set(-100, 100, -100);
                light.castShadow = true;
                scene.add(light);



                //Create the slab
                pillarGeometry = new THREE.CubeGeometry(PILLAR_WIDTH, PILLAR_HEIGHT, PILLAR_LENGTH); //(100, 15, 100);
                pillarMaterial = new THREE.MeshPhongMaterial({ wireframe: true, side: THREE.DoubleSide, transparent: false, opacity: 100, });

                pillar = new THREE.Mesh(pillarGeometry, pillarMaterial);
                pillar.castShadow = true;
                pillar.position.set(0, PILLAR_HEIGHT / 16, 0); //(0, 12, 0);

                scene.add(pillar);

                gui = new dat.GUI();
                
                parameters =
                    {
                        Length: (PILLAR_LENGTH * 10), Width: (PILLAR_WIDTH * 10), Pillar_Height: (PILLAR_HEIGHT * 10),    //these will be read from the DB for previous quotes!
                        stone: "Wireframe"
                        //reset: function () { resetPier() }
                    };

                //Slider UI
                deminsions = gui.addFolder('Pillar Dimensions (cm)');
                pillarX = deminsions.add(parameters, 'Width').min(MIN_PILLAR_LENGTH).max(MAX_PILLAR_LENGTH).step(1).listen();
                pillarZ = deminsions.add(parameters, 'Length').min(MIN_PILLAR_WIDTH).max(MAX_PILLAR_WIDTH).step(1).listen();
                pillarY = deminsions.add(parameters, 'Pillar_Height').min(MIN_PILLAR_HEIGHT).max(MAX_PILLAR_HEIGHT).step(10).listen();
                //pyramidY = deminsions.add(parameters, 'Point_Height').min(MIN_PYRAMID_HEIGHT).max(MAX_PYRAMID_HEIGHT).step(1).listen();
                deminsions.open();

                var productMaterial = gui.add(parameters, 'stone', ["Wireframe", "Granite", "Sandstone", "Limestone"]).name
                ('Stone Type').listen();



                productMaterial.onChange(function (value) {
                    updatePillar();
                    

                });

                //change texture of slab when stone type is changed
                function updatePillar() {
                    var value = parameters.stone;
                    var newMaterial;
                    if (value == "Granite") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/Granite Flashing.jpg"), shading: THREE.FlatShading, overdraw: true });

                        document.getElementById('<%= lblDisplayPillarStone.ClientID %>').textContent = "Granite";
                    }
                    else if (value == "Sandstone") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/Sandstone flashing.jpg") });
                        document.getElementById('<%= lblDisplayPillarStone.ClientID %>').textContent = "Sand Stone";
                    }
                    else if (value == "Limestone") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/Limestone flashing.jpg") });
                        document.getElementById('<%= lblDisplayPillarStone.ClientID %>').textContent = "Lime Stone";
                    }
                    else // (value == "Wireframe")
                        newMaterial = new THREE.MeshBasicMaterial({ wireframe: true });

            pillar.material = newMaterial;
                    

            animate();
        }

               

                //functions to alter shape with sliders
                pillarX.onChange(function (value) {
                    pillar.scale.x = value / (PILLAR_WIDTH * 10);
                    //pyramid.scale.x = slab.scale.x;
                    //pyramid.scale.z = slab.scale.x;

                    //Put X scale value in global variable
                    Pillar_Length = pillar.scale.x;
                });

                pillarY.onChange(function (value) {
                    pillar.scale.y = value / (PILLAR_HEIGHT * 10);
                    //pillar.position.y = (pillar.scale.y * 25) / 2;
                    //pyramid.position.y = (slab.scale.y * 25);

                    //Put Y scale value in global variable
                    Pillar_Height = pillar.scale.y;
                });

                pillarZ.onChange(function (value) {
                    pillar.scale.z = value / (PILLAR_LENGTH * 10);
                    //pyramid.scale.x = slab.scale.z;
                    //pyramid.scale.z = slab.scale.z;

                    //Put Z scale value in global variable
                    Pillar_Width = pillar.scale.z;
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

            //Functions to send co-ordinates of pryamid and slab to code behind

            //Stone texture
            // function stoneTexture() {
            //      var getStoneTexture = stoneTex;
            //    
            // }

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


    <form>
        <asp:Label runat="server" ID="lblDisplayPillarStone"></asp:Label>
         <asp:Label ID="lblDisplayStone" runat="server" ClientIDMode="Static" ></asp:Label>
    </form>
</body>
</html>
