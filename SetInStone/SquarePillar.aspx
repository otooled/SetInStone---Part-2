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
        var light, material, mesh;
        var clock = new THREE.Clock();
        var renderers = [];
       
        //Slider and gui variables
        var deminsions;
        var parameters;
        var gui_deminsions;
        var pillar;
        var pillarX, pillarY, pillarZ, slabY, pyramidY;
        
        //Pillar creation
        var pillarGeometry, pillarMaterial;
        
        //default size for new pier cap
        var PILLAR_WIDTH = 80; PILLAR_LENGTH = 100; PILLAR_HEIGHT = 125;

        //max dimensions for pier caps
        var MIN_PILLAR_WIDTH = 400; MIN_PILLAR_LENGTH = 400; MIN_PILLAR_HEIGHT = 500;
        var MAX_PILLAR_WIDTH = 1200; MAX_PILLAR_LENGTH = 1200; MAX_PILLAR_HEIGHT = 1700;
        
        //This will act as width & length as slab
        var Pillar_Width = 1, Pillar_Length = 1, Pillar_Height = 1;

        var color, assignUVs;

        //Slab creation
        //This will act as width & length as slab
        var Slab_Width = 1, Slab_Length = 1, Slab_Height = 1;
        var slabGeometry, slabMaterial;
        var slab;
        //default size for new pier cap
        var SLAB_WIDTH = 80; SLAB_LENGTH = 100; SLAB_HEIGHT = 15; PYRAMID_HEIGHT = 20;

        //max dimensions for pier caps
        var MIN_SLAB_WIDTH = 400; MIN_SLAB_LENGTH = 400; MIN_SLAB_HEIGHT = 100; MIN_PYRAMID_HEIGHT = 0;
        var MAX_SLAB_WIDTH = 1200; MAX_SLAB_LENGTH = 1200; MAX_SLAB_HEIGHT = 250; MAX_PYRAMID_HEIGHT = 300;
        
        //var lblSelectedText = document.getElementById("lblSelectedText");
        
        //Pyramid creation
        var pyramid, assignUVs;
        //Height of pyramid
        var Pyramid_Height = 1;
       
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

                //color = new THREE.Color(0xffffff);


                scene = new THREE.Scene();
                //slab_scene = new THREE.Scene();
                
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
                slabGeometry = new THREE.CubeGeometry(SLAB_WIDTH, SLAB_HEIGHT, SLAB_LENGTH); //(100, 15, 100);
                slabMaterial = new THREE.MeshPhongMaterial({ wireframe: true, side: THREE.DoubleSide, transparent: false, opacity: 100 });

                slab = new THREE.Mesh(slabGeometry, slabMaterial);
                slab.castShadow = true;
                slab.position.set(0, PILLAR_HEIGHT /2.3, 0); //(0, 12, 0);

                scene.add(slab);


                //Create pyramid shape
                var pyramidGeom = new THREE.CubeGeometry(10, 10, 10);
                var pyramidMaterial = new THREE.MeshLambertMaterial({ wireframe: true, side: THREE.DoubleSide, transparent: false, opacity: 100 });


                pyramidGeom.vertices = [  // array of Vector3 giving vertex coordinates
                    new THREE.Vector3(SLAB_WIDTH / 2, 0, SLAB_LENGTH / 2),    // vertex number 0
                    new THREE.Vector3(SLAB_WIDTH / 2, 0, SLAB_LENGTH / -2),   // vertex number 1
                    new THREE.Vector3(SLAB_WIDTH / -2, 0, SLAB_LENGTH / -2),  // vertex number 2
                    new THREE.Vector3(SLAB_WIDTH / -2, 0, SLAB_LENGTH / 2),   // vertex number 3
                    new THREE.Vector3(0, PYRAMID_HEIGHT, 0)     // vertex number 4
                ];

                //var meshFaceMaterial = new THREE.MeshFaceMaterial(pyramidMaterial);
                pyramidGeom.faces = [
                    new THREE.Face3(3, 0, 4), // faces are triangles
                    new THREE.Face3(0, 1, 4),
                    new THREE.Face3(1, 2, 4),
                    new THREE.Face3(2, 3, 4)

                ];

                pyramidGeom.dynamic = true;
                pyramidGeom.computeFaceNormals();
                pyramidGeom.computeVertexNormals();
                pyramidGeom.computeBoundingSphere();

                pyramid = new THREE.Mesh(pyramidGeom, pyramidMaterial);

                pyramid.position.set(0, PILLAR_HEIGHT/2, 0);
                pyramid.overdraw = true;
                pyramid.castShadow = true;
                pyramid.receiveShadow = true;

                scene.add(pyramid);
                scene.add(new THREE.FaceNormalsHelper(pyramid));
                

               

                gui_deminsions = new dat.GUI();

                parameters =
                    {
                        Slab_Height: (SLAB_HEIGHT * 10), Point_Height: (PYRAMID_HEIGHT * 10), Pillar_Length: (PILLAR_LENGTH * 10),
                        Pillar_Width: (PILLAR_WIDTH * 10), Pillar_Height: (PILLAR_HEIGHT * 10),
                        stone: "Wireframe",
                        //reset: function () { resetPier() }
                    };
                
                //Slider UI
                deminsions = gui_deminsions.addFolder('Dimensions (mm)');
                slabY = deminsions.add(parameters, 'Slab_Height').min(MIN_SLAB_HEIGHT).max(MAX_SLAB_HEIGHT).step(1).listen();
                pyramidY = deminsions.add(parameters, 'Point_Height').min(MIN_PYRAMID_HEIGHT).max(MAX_PYRAMID_HEIGHT).step(1).listen();
                pillarX = deminsions.add(parameters, 'Pillar_Length').min(MIN_PILLAR_LENGTH).max(MAX_PILLAR_LENGTH).step(1).listen();
                pillarZ = deminsions.add(parameters, 'Pillar_Width').min(MIN_PILLAR_WIDTH).max(MAX_PILLAR_WIDTH).step(1).listen();
                pillarY = deminsions.add(parameters, 'Pillar_Height').min(MIN_PILLAR_HEIGHT).max(MAX_PILLAR_HEIGHT).step(10).listen();
                deminsions.open();

                var slabProductMaterial = gui_deminsions.add(parameters, 'stone', ["Wireframe", "Granite", "Sandstone", "Limestone"]).name
                ('Cap Stone Type').listen();


                slabProductMaterial.onChange(function (value) {
                    updateSlab();
                    updatePyramid();

                });

                //change texture of slab when stone type is changed
                function updateSlab() {
                    var value = parameters.stone;
                    var newMaterial;
                    if (value == "Granite") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/granite2.jpg"), shading: THREE.FlatShading, overdraw: true });

                        document.getElementById('<%= lblDisplayStone.ClientID %>').textContent = "Granite";
                    }
                    else if (value == "Sandstone") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/sandstone2.jpg") });
                        document.getElementById('<%= lblDisplayStone.ClientID %>').textContent = "Sand Stone";
                    }
                    else if (value == "Limestone") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/limestone2.jpg") });
                        document.getElementById('<%= lblDisplayStone.ClientID %>').textContent = "Lime Stone";
                    }
                    else // (value == "Wireframe")
                        newMaterial = new THREE.MeshBasicMaterial({ wireframe: true });

            slab.material = newMaterial;
                    //pyramid.material = newMaterial;   

            animate();
        }

                //change texture of pyramid when stone type is changed
        function updatePyramid() {
            var value = parameters.stone;
            var newMaterial;
            if (value == "Granite") {
                newMaterial = new THREE.MeshPhongMaterial({ map: THREE.ImageUtils.loadTexture('Textures/granite2.jpg') });
            }
            else if (value == "Sandstone") {
                newMaterial = new THREE.MeshPhongMaterial({ map: THREE.ImageUtils.loadTexture('Textures/sandstone2.jpg') });
            }
            else if (value == "Limestone") {
                newMaterial = new THREE.MeshPhongMaterial({ map: THREE.ImageUtils.loadTexture('Textures/limestone2.jpg') });
            }
            else // (value == "Wireframe")
                newMaterial = new THREE.MeshBasicMaterial({ wireframe: true });

            pyramid.material = newMaterial;

            animate();

        }
                
               

                slabY.onChange(function(value) {
                    slab.scale.y = value / (SLAB_HEIGHT * 10);
                     //slab.position.y = (slab.scale.y * 25) / 2;
                   
                    //slab.position.y = (pillar.scale.y * 25) /2;
                    pillar.position.y = (slab.scale.y * (-1.5 * 6.10)) - 6.5;
                    pyramid.position.y = (slab.position.y + SLAB_HEIGHT / 2) + (slab.scale.y * 8) -8;
                     
                    //pillar.scale.y = value / (PILLAR_HEIGHT * 10);

                    //slab.position.y = (pillar.scale.y * (10 * 6.10)) - 5.8;
                    //pyramid.position.y = (pillar.scale.y * (10 * 6.10)) + 1.8;

                    //Put Y scale value in global variable
                    Slab_Height = slab.scale.y;
                });

               

                pyramidY.onChange(function(value) {
                    pyramid.scale.y = value / (PYRAMID_HEIGHT * 10);
                    //slab.position.y = (pyramid.scale.y * PYRAMID_HEIGHT) / 2;

                    //Put pryamid Y scale value in global variable
                    Pyramid_Height = pyramid.scale.y;
                    //slab.position.y = (slab.scale.y * 25) / 2;
                    //pyramid.position.y = (slab.scale.y * 25);
                });

                
               


                //Create the pillar
        pillarGeometry = new THREE.CubeGeometry(PILLAR_WIDTH, PILLAR_HEIGHT, PILLAR_LENGTH); //(100, 15, 100);
        pillarMaterial = new THREE.MeshPhongMaterial({ wireframe: true, side: THREE.DoubleSide, transparent: false, opacity: 100, });

        pillar = new THREE.Mesh(pillarGeometry, pillarMaterial);
        pillar.castShadow = true;
        pillar.position.set(0, -15, 0); //(0, 12, 0);

        scene.add(pillar);

     

        var productMaterial = gui_deminsions.add(parameters, 'stone', ["Wireframe", "Granite", "Sandstone", "Limestone"]).name
        ('Pillar Stone Type').listen();



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
                pillarX.onChange(function(value) {
                    pillar.scale.x = value / (PILLAR_WIDTH * 10);
                    pyramid.scale.x = pillar.scale.x;
                    slab.scale.x = pillar.scale.x;

                    //Put X scale value in global variable
                    Pillar_Length = pillar.scale.x;
                });

                pillarY.onChange(function(value) {
                    pillar.scale.y = value / (PILLAR_HEIGHT * 10);

                    slab.position.y = (pillar.scale.y * (10 * 6.10)) - 5.8;
                    pyramid.position.y = (slab.position.y + SLAB_HEIGHT / 2) + (slab.scale.y * 8) - 8;//(pillar.scale.y * (10 * 6.10)) + 1.8;
                    //pyramid.position.y = pillar.scale.y * (difference * 60);
                    
                    //position.x + width / 2, position.y + height / 2, position.z + depth / 2

                    //Put Y scale value in global variable
                    Pillar_Height = pillar.scale.y;
                });

        pillarZ.onChange(function (value) {
            pillar.scale.z = value / (PILLAR_LENGTH * 10);
            slab.scale.z = pillar.scale.z;
            pyramid.scale.z = pillar.scale.z;

            //Put Z scale value in global variable
            Pillar_Width = pillar.scale.z;
        });


                //Functions to send co-ordinates of pryamid and slab to code behind
        function DisplaySlabHeight() {
            var getSlabHeight = Slab_Height;
            document.getElementById('<%= SlabHeight.ClientID %>').value = getSlabHeight;
            }

            function DisplaySlabWidth() {
                var getSlabWidth = Slab_Width;
                document.getElementById('<%= SlabWidth.ClientID %>').value = getSlabWidth;
            }

            function DisplaySlabLength() {
                var getSlabLength = Slab_Length;
                document.getElementById('<%=SlabLength.ClientID %>').value = getSlabLength;
            }

            function DisplayPryHeight() {
                var getPryHeight = Pyramid_Height;
                document.getElementById('<%= PryHeight.ClientID %>').value = getPryHeight;
            }


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


    <form runat="server">
        <asp:Label runat="server" ID="lblDisplayPillarStone"></asp:Label>
         <asp:Label ID="lblDisplayStone" runat="server" ClientIDMode="Static" ></asp:Label>
        
         <asp:Button CssClass="Buttons" runat="server" ID="btnCalculate" OnClick="btnCalculate_Click" Text="Calculate Cost" 
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
