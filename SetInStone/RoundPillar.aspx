﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RoundPillar.aspx.cs" Inherits="SetInStone.WallCap" UnobtrusiveValidationMode="None" %>

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

        //Scene rendering variables
        var renderer, scene, camera, controls, color, stats;
        var light, geometry, material, mesh, np;
        var clock = new THREE.Clock();
        var renderers = [];
        var displayStone;

        //This will act as diameter & height of pillar cylinder
        var Pillar_Diameter = 400, Pillar_Height = 550;

        //This will act as diameter & height as cap
        var Cap_Diameter = 430, Cap_Height = 100;

        //pillar creation
        var pillarGeometry, pillarMaterial;
        var pillar;
        
        //Cap creation
        var capGeometry, capMaterial;
        var cap;

        //Slider and gui variables
        var parameters;
        var gui;
        var deminsions;
        var pillarX, pillarY;
        var capY;

        //default size for new pillar
        var PILLAR_DIAMETER = 40; PILLAR_HEIGHT = 90;PILLAR_CURVE = 20;  

        //max dimensions for pillar
        var MIN_PILLAR_DIAMETER = 300; MAX_PILLAR_DIAMETER = 600; MIN_PILLAR_HEIGHT = 600; MAX_PILLAR_HEIGHT = 1300;
        
        //default size for cap
        var CAP_DIAMETER = 45; CAP_HEIGHT = 7;CAP_CURVE = 30;
        
        //max dimensions for caps
        var MIN_CAP_HEIGHT = 30; MAX_CAP_HEIGHT = 150;

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

                    init();

                    function init() {
                        var mainGraphic = document.getElementById('MainGraphic');

                        //renderer for scene

                        renderer = new THREE.WebGLRenderer({ antialias: true });
                        renderer.setSize(740, 320);
                        renderer.shadowMapEnabled = true;
                        renderer.shadowMapSoft = true;
                        renderer.domElement.style.border = '5px solid white';

                        mainGraphic.appendChild(renderer.domElement);

                        //create the scene
                        scene = new THREE.Scene();

                        //Camera position
                        camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 1, 1000);
                        camera.position.set(100, 100, 200);

                        //Rotation of objects in scene
                        controls = new THREE.TrackballControls(camera, renderer.domElement);

                        //Light the scene
                        light = new THREE.AmbientLight(0xffffff);
                        scene.add(light);

                        //Create the pillar geometry and material
                        pillarGeometry = new THREE.CylinderGeometry(PILLAR_DIAMETER, PILLAR_DIAMETER, PILLAR_HEIGHT, PILLAR_CURVE);
                        pillarMaterial = new THREE.MeshPhongMaterial({ wireframe: true, side: THREE.DoubleSide, transparent: false, opacity: 100 });

                        pillar = new THREE.Mesh(pillarGeometry, pillarMaterial);
                        pillar.castShadow = true;
                        pillar.position.set(0, -15, 0);

                       
                        //Create cap geometry and material
                        capGeometry = new THREE.CylinderGeometry(CAP_DIAMETER, CAP_DIAMETER, CAP_HEIGHT, CAP_CURVE);
                        capMaterial = new THREE.MeshPhongMaterial({ wireframe: true, side: THREE.DoubleSide, transparent: false, opacity: 100 });
                        cap = new THREE.Mesh(capGeometry, capMaterial);
                        cap.castShadow = true;
                        cap.position.set(0, 34, 0);

                        scene.add(pillar, cap);

                        //Begin slider 
                        gui = new dat.GUI();

                        //Parameters that for pillar demensions
                        parameters =
                            {
                                Diameter: (PILLAR_DIAMETER * 10),
                                Pillar_Height: (PILLAR_HEIGHT * 10),
                                Cap_Height: (CAP_HEIGHT * 10),
                                stone: "Wireframe",
                                capStone: "Wireframe"
                                //reset: function () { resetPier() }
                            };

                        //Slider UI
                        deminsions = gui.addFolder('Pier Cap Dimensions (mm)');

                        //Pillar controls
                        pillarX = deminsions.add(parameters, 'Diameter').min(MIN_PILLAR_DIAMETER).max(MAX_PILLAR_DIAMETER).step(1).listen();
                        pillarY = deminsions.add(parameters, 'Pillar_Height').min(MIN_PILLAR_HEIGHT).max(MAX_PILLAR_HEIGHT).step(1).listen();

                        //Cap controls
                        capY = deminsions.add(parameters, 'Cap_Height').min(MIN_CAP_HEIGHT).max(MAX_CAP_HEIGHT).step(1).listen();
                        deminsions.open();

                        //Stone types pillar selection
                        var pillarMaterial = gui.add(parameters, 'stone', ["Wireframe", "Granite", "Sandstone", "Limestone"]).name('Pillar Stone Type').listen();

                        //Stone types pillar selection
                        var capMaterial = gui.add(parameters, 'capStone', ["Wireframe", "Granite", "Sandstone", "Limestone"]).name('Cap Stone Type').listen();
                        
                        //Call function to update cap pillar textures
                        pillarMaterial.onChange(function (value) {
                            updatePillar();
                        });
                        
                        //Call function to update cap textures
                        capMaterial.onChange(function (value) {
                            updateCap();
                        });
                      
                        //Change texture of cap when stone type is changed
                        //This also puts displays the stone type selected
                        function updatePillar() {
                            var value = parameters.stone;
                            var newMaterial;
                            if (value == "Granite") {
                                newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/Granite Flashing.jpg"), shading: THREE.FlatShading, overdraw: true });

                                //Display selection
                                document.getElementById('<%= lblPillarStoneCaption.ClientID %>').style.display = 'inline';
                                document.getElementById('<%= lblPillarStone.ClientID %>').innerText = "Granite";
                                //DisplayStoneSelection();

                            } else if (value == "Sandstone") {
                                newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/sandstone2.jpg") });

                                //Display selection
                                document.getElementById('<%= lblPillarStoneCaption.ClientID %>').style.display = 'inline';
                                document.getElementById('<%= lblPillarStone.ClientID %>').textContent = "Sandstone";
                            } else if (value == "Limestone") {
                                newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/limestone2.jpg") });

                                //Display selection
                                document.getElementById('<%= lblPillarStoneCaption.ClientID %>').style.display = 'inline';
                                document.getElementById('<%= lblPillarStone.ClientID %>').textContent = "Limestone";
                            } else // (value == "Wireframe")
                                newMaterial = new THREE.MeshBasicMaterial({ wireframe: true });

                            //Apply new textures
                            pillar.material = newMaterial;
                            animate();
                        }


                        //Functions to alter shape with sliders
                        //Diameter of pillar and cap changes here
                        pillarX.onChange(function (value) {
                            
                            //Move diameter of pillar
                            pillar.scale.x = value / (PILLAR_DIAMETER * 10);
                            pillar.scale.z = value / (PILLAR_DIAMETER * 10);
                            
                            //Move diameter of cap
                            cap.scale.x = value / (PILLAR_DIAMETER * 10);
                            cap.scale.z = value / (PILLAR_DIAMETER * 10);

                            //Put X of pillar and cap scale value in variables for hidden fields
                            Pillar_Diameter = pillar.scale.x;
                            
                            //Cap diameter has 10 added to compensate overhang
                            Cap_Diameter = pillar.scale.x + 10;
                            
                        });

                        //Manipulate height of pillar
                       //This function also controls the position of the cap as the pillar moves.
                        pillarY.onChange(function(value) {
                            pillar.scale.y = value / (PILLAR_HEIGHT * 10);
                            cap.position.y = (pillar.scale.y * (9 * 5.10)) - 11.8;

                            //Put Y scale value in global variable
                            Pillar_Height = pillar.scale.y;

                        }); 

                        //Manipulate height of pyramid point
                        capY.onChange(function(value) {
                            cap.scale.y = value / (CAP_HEIGHT * 10);
                            pillar.position.y = (cap.scale.y * (-2.65 * 1.30)) - 11.5;
                            
                            //Put cap Y scale value in global variable for hidden field
                            Cap_Height = cap.scale.y;
                        });
                        
                        function updateCap() {

                            var value = parameters.capStone;
                            var newMaterial;

                            if (value == "Granite") {
                                newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/granite2.jpg"), shading: THREE.FlatShading, overdraw: true });

                                //Display selection
                                document.getElementById('<%= lblCapStoneTypeCaption.ClientID %>').style.display = 'inline';
                                displayStone = document.getElementById('<%= lblPillarStone.ClientID %>').innerText = "Granite";


                            } else if (value == "Sandstone") {
                                newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/sandstone2.jpg") });

                                //Display selection
                                document.getElementById('<%= lblCapStoneTypeCaption.ClientID %>').style.display = 'inline';
                                displayStone = document.getElementById('<%= lblPillarStone.ClientID %>').innerText = "Granite";


                            } else if (value == "Limestone") {
                                newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/limestone2.jpg") });

                                //Display selection
                                document.getElementById('<%= lblCapStoneTypeCaption.ClientID %>').style.display = 'inline';
                                displayStone = document.getElementById('<%= lblPillarStone.ClientID %>').innerText = "Granite";


                            } else
                                newMaterial = new THREE.MeshBasicMaterial({ wireframe: true });

                            //Apply new textures to cap
                            cap.material = newMaterial;
                            animate();
                        }


                        function callback() { return; }

                renderers.push({ renderer: renderer, scene: scene, camera: camera, controls: controls, callback: callback });

            }

            //Functions to send co-ordinates of pryamid and slab to code behind
            function DisplayPillarHeight() {
                var getPillarHeight = Pillar_Height;
                document.getElementById('<%= PillarHeight.ClientID %>').value = getPillarHeight;
                    }

                    function DisplayPillarDiameter() {
                        var getPillarDiameter = Pillar_Diameter;
                        document.getElementById('<%= PillarDiameter.ClientID %>').value = getPillarDiameter;
                    }

                    function DisplayCapDiameter() {
                        var getCapDiameter = Cap_Diameter;
                        document.getElementById('<%=CapDiameter.ClientID %>').value = getCapDiameter;
                    }

                    function DisplayCapHeight() {
                        var getCapHeight = Cap_Height;
                        document.getElementById('<%= CapHeight.ClientID %>').value = getCapHeight;
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

    <form id="fmControls" runat="server">


        <%--Start of Ajax commands--%>
        <asp:ScriptManager ID="MainScriptManager" runat="server" />


        <%--This div gets updated using Ajax--%>
        <div id="costControls">
            <asp:UpdatePanel runat="server" ID="UpdatePanel" UpdateMode="Conditional">
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnCalculate" />
                </Triggers>
                <ContentTemplate>

                    <asp:TextBox runat="server" ID="txtQuantity" CssClass="TextBoxes" placeholder="Quantity"></asp:TextBox>
                    <asp:Button CssClass="Buttons" runat="server" ID="btnCalculate" Text="Calculate Cost" 
                        OnClientClick="DisplayPillarHeight(); DisplayPillarDiameter(); DisplayCapDiameter();  DisplayCapHeight();" />

                    <br />
                     <asp:Label ID="lblCapStoneTypeCaption" runat="server" Text="Cap Stone Type" Style="display: none"></asp:Label>
                        <asp:Label ID="lblCapStoneType" runat="server"  ClientIDMode="Static"></asp:Label>
                    <br/>
                        <asp:Label ID="lblPillarStoneCaption" runat="server" Text="Pillar Stone Type" Style="display: none"></asp:Label>

                        <asp:Label ID="lblPillarStone" runat="server"  ClientIDMode="Static" ></asp:Label>

                      <br />
                    <asp:Label runat="server" ID="lblTotalCost" Visible="True"></asp:Label>
                    <br />

                    <br />

                    <asp:Button runat="server" CssClass="Buttons" ID="btnSaveConfirm" Text="Save Quote / Place Order"
                         />
                    <asp:Button runat="server" ID="btnCancel" Text="Cancel" CssClass="Buttons" CausesValidation="False" />
                    
                    <%--Hidden fields for slab and pillar measurements--%>
                    <asp:HiddenField ID="PillarDiameter" runat="server" />
                    <asp:HiddenField ID="PillarHeight" runat="server" />
                    <asp:HiddenField ID="CapDiameter" runat="server" />
                    <asp:HiddenField ID="CapHeight" runat="server" />
                    
<%--                    <asp:HiddenField runat="server" ID="DisplayStoneType"/>--%>

                    <asp:Label runat="server" ID="lblCalculateAnswer" Text="test" CssClass="Labels"></asp:Label>
                    <asp:Label ID="Label1" runat="server"></asp:Label>

                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

    </form>
    </body>
</html>