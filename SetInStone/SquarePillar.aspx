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
        //Scene rendering variables
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

        //default size for pillar
        var PILLAR_WIDTH = 80; PILLAR_LENGTH = 100; PILLAR_HEIGHT = 125;

        //max dimensions for pillar
        var MIN_PILLAR_WIDTH = 400; MIN_PILLAR_LENGTH = 400; MIN_PILLAR_HEIGHT = 500;
        var MAX_PILLAR_WIDTH = 1200; MAX_PILLAR_LENGTH = 1200; MAX_PILLAR_HEIGHT = 1700;

        //This will act as width & length of pillar
        //var Pillar_Width = 1, Pillar_Length = 1, Pillar_Height = 1;

        //Slab creation
        //This will act as width & length as slab
        // var Slab_Width = 800, Slab_Length = 1000, Slab_Height = 250;
        var slabGeometry, slabMaterial;
        var slab;
        //default size for new pier cap
        var SLAB_WIDTH = 90; SLAB_LENGTH = 110; SLAB_HEIGHT = 15; PYRAMID_HEIGHT = 20;

        //max dimensions for pier caps
        var MIN_SLAB_WIDTH = 400; MIN_SLAB_LENGTH = 400; MIN_SLAB_HEIGHT = 100; MIN_PYRAMID_HEIGHT = 0;
        var MAX_SLAB_WIDTH = 1200; MAX_SLAB_LENGTH = 1200; MAX_SLAB_HEIGHT = 250; MAX_PYRAMID_HEIGHT = 300;

        //var lblSelectedText = document.getElementById("lblSelectedText");

        //Pyramid creation
        var pyramid;
        //Height of pyramid
        var Pyramid_Height = 1;
        var Pillar_Stone_Type = 0;
        var Cap_Stone_Type = 0;

    </script>

    <title>Set In Stone</title>

</head>
<body>

    <br />
    <br />
    <div id="divTitle">
        <label>Set In Stone - Square Pillar</label>
    </div>
    <div id='MainGraphic'>


        <script type='text/javascript'>
            // var controls, stats;
            init();


            function init() {
                var mainGraphic = document.getElementById('MainGraphic');

                //renderer for scene
                renderer = new THREE.WebGLRenderer({ antialias: true });
                renderer.setSize(740, 320);
                renderer.shadowMapEnabled = true;
                renderer.shadowMapSoft = true;
                renderer.domElement.style.border = '2px solid white';

                mainGraphic.appendChild(renderer.domElement);

                //create the scene
                scene = new THREE.Scene();

                //Camera position
                camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 1, 1000);
                camera.position.set(100, 100, 350);

                //Rotation of objects in scene
                controls = new THREE.TrackballControls(camera, renderer.domElement);

                //Light the scene
                light = new THREE.AmbientLight(0xffffff);
                scene.add(light);

                //Create the slab geometry and material
                slabGeometry = new THREE.CubeGeometry(SLAB_WIDTH, SLAB_HEIGHT, SLAB_LENGTH);
                slabMaterial = new THREE.MeshPhongMaterial({ wireframe: true, side: THREE.DoubleSide, transparent: false, opacity: 100 });

                slab = new THREE.Mesh(slabGeometry, slabMaterial);
                slab.castShadow = true;
                slab.position.set(0, PILLAR_HEIGHT / 2.3, 0);

                scene.add(slab);


                //Create pyramid shape
                var pyramidGeom = new THREE.CubeGeometry(10, 10, 10);
                var pyramidMaterial = new THREE.MeshLambertMaterial({ wireframe: true, side: THREE.DoubleSide, transparent: false, opacity: 100 });

                //vertex coordinates for pryamid
                pyramidGeom.vertices = [
                    new THREE.Vector3(SLAB_WIDTH / 2, 0, SLAB_LENGTH / 2),
                    new THREE.Vector3(SLAB_WIDTH / 2, 0, SLAB_LENGTH / -2),
                    new THREE.Vector3(SLAB_WIDTH / -2, 0, SLAB_LENGTH / -2),
                    new THREE.Vector3(SLAB_WIDTH / -2, 0, SLAB_LENGTH / 2),
                    new THREE.Vector3(0, PYRAMID_HEIGHT, 0)
                ];

                //Faces for triangles that make up pryamid
                pyramidGeom.faces = [
                    new THREE.Face3(3, 0, 4),
                    new THREE.Face3(0, 1, 4),
                    new THREE.Face3(1, 2, 4),
                    new THREE.Face3(2, 3, 4)
                ];

                //Set up pryamid for adding texture
                pyramidGeom.dynamic = true;
                pyramidGeom.computeFaceNormals();
                pyramidGeom.computeVertexNormals();
                pyramidGeom.computeBoundingSphere();

                pyramid = new THREE.Mesh(pyramidGeom, pyramidMaterial);

                pyramid.position.set(0, PILLAR_HEIGHT / 2, 0);
                pyramid.overdraw = true;
                pyramid.castShadow = true;
                pyramid.receiveShadow = true;

                scene.add(pyramid);
                scene.add(new THREE.FaceNormalsHelper(pyramid));

                //Create the pillar
                pillarGeometry = new THREE.CubeGeometry(PILLAR_WIDTH, PILLAR_HEIGHT, PILLAR_LENGTH); //(100, 15, 100);
                pillarMaterial = new THREE.MeshPhongMaterial({ wireframe: true, side: THREE.DoubleSide, transparent: false, opacity: 100, });

                pillar = new THREE.Mesh(pillarGeometry, pillarMaterial);
                pillar.castShadow = true;
                pillar.position.set(0, -15, 0); //(0, 12, 0);

                scene.add(pillar);

                //Begin slider 
                gui_deminsions = new dat.GUI({ autoplace: false });
                gui_deminsions.domElement.id = 'gui';
                //Parameters that for product demensions
                parameters =
                    {
                        Slab_Height: (SLAB_HEIGHT * 10),
                        Point_Height: (PYRAMID_HEIGHT * 10),
                        Pillar_Length: (PILLAR_LENGTH * 10),
                        Pillar_Width: (PILLAR_WIDTH * 10),
                        Pillar_Height: (PILLAR_HEIGHT * 10),
                        stone: "Wireframe",
                        pillarStone: "Wireframe",
                        //reset: function () { resetPier() }
                    };

                //Slider UI
                deminsions = gui_deminsions.addFolder('Dimensions (mm)');

                //Slab and pyramid
                slabY = deminsions.add(parameters, 'Slab_Height').min(MIN_SLAB_HEIGHT).max(MAX_SLAB_HEIGHT).step(1).listen();
                pyramidY = deminsions.add(parameters, 'Point_Height').min(MIN_PYRAMID_HEIGHT).max(MAX_PYRAMID_HEIGHT).step(1).listen();

                //Pillar
                pillarX = deminsions.add(parameters, 'Pillar_Length').min(MIN_PILLAR_LENGTH).max(MAX_PILLAR_LENGTH).step(1).listen();
                pillarZ = deminsions.add(parameters, 'Pillar_Width').min(MIN_PILLAR_WIDTH).max(MAX_PILLAR_WIDTH).step(1).listen();
                pillarY = deminsions.add(parameters, 'Pillar_Height').min(MIN_PILLAR_HEIGHT).max(MAX_PILLAR_HEIGHT).step(10).listen();

                deminsions.open();

                //Stone types selection for cap
                var capProductMaterial = gui_deminsions.add(parameters, 'stone', ["Wireframe", "Granite", "Sandstone", "Limestone"]).name('Cap Stone Type').listen();

                //Call function to update cap and slab textures
                capProductMaterial.onChange(function (value) {
                    updateCap();
                });

                //Stone types selection for pillar
                var pillarProductMaterial = gui_deminsions.add(parameters, 'pillarStone', ["Wireframe", "Granite", "Sandstone", "Limestone"]).name('Pillar Stone Type').listen();

                //Call function to update pillar texture
                pillarProductMaterial.onChange(function (value) {
                    updatePillar();
                });

                //Change texture of cap when stone type is changed
                //This also puts displays the stone type selected

                function updateCap() {

                    var value = parameters.stone;
                    var newMaterial;

                    if (value == "Granite") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/granite2.jpg"), shading: THREE.FlatShading, overdraw: true });

                        Cap_Stone_Type = 1;
                        CapStoneType();
                        //Display selection

                        document.getElementById('<%= hf_DisplayCapType.ClientID %>').value = "Granite";
                        document.getElementById('<%= txtDisplayCapStone.ClientID %>').value = "Granite";

                    } else if (value == "Sandstone") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/sandstone2.jpg") });

                        Cap_Stone_Type = 2;
                        CapStoneType();
                        //Display selection


                        document.getElementById('<%= hf_DisplayCapType.ClientID %>').value = "Sandstone";
                        document.getElementById('<%= txtDisplayCapStone.ClientID %>').value = "Sandstone";

                    } else if (value == "Limestone") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/limestone2.jpg") });

                        Cap_Stone_Type = 3;
                        CapStoneType();
                        //Display selection

                        document.getElementById('<%= hf_DisplayCapType.ClientID %>').value = "Limestone";
                        document.getElementById('<%= txtDisplayCapStone.ClientID %>').value = "Limestone";
                    } else
                        newMaterial = new THREE.MeshBasicMaterial({ wireframe: true });

                    //Apply new textures to cap
            slab.material = newMaterial;
            pyramid.material = newMaterial;

            animate();
        }

                //Manipulate height of slab
                //This function also controls the position of the pillar and pyramid as the slab moves.
        slabY.onChange(function (value) {
            slab.scale.y = value / (SLAB_HEIGHT * 10);

            //Move the pillar position as the slab moves
            pillar.position.y = (slab.scale.y * (-1.5 * 6.10)) - 6.5;

            //Move the pyramid as the slab moves
            pyramid.position.y = (slab.position.y + SLAB_HEIGHT / 2) + (slab.scale.y * 8) - 8;

            //Put Y scale value in global variable
            // Slab_Height = slab.scale.y;
            document.getElementById('<%= SlabHeight.ClientID %>').value = value;
                });


                //Manipulate height of pyramid point
                pyramidY.onChange(function (value) {
                    pyramid.scale.y = value / (PYRAMID_HEIGHT * 10);

                    //Put pryamid Y scale value in global variable
                    //Pyramid_Height = pyramid.scale.y;
                    document.getElementById('<%= PryHeight.ClientID %>').value = value;
                });


                //Change texture of pillar when stone type is changed
                //This also puts displays the stone type selected

                function updatePillar() {
                    var value = parameters.pillarStone;
                    var newMaterial;

                    if (value == "Granite") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/Granite Flashing.jpg"), shading: THREE.FlatShading, overdraw: true });

                        Pillar_Stone_Type = 1;
                        PillarStoneType();
                        //Display selection
                        //document.getElementById('<%= lblPillarStone.ClientID %>').textContent = "Granite";
                        //document.getElementById('<%= lblPillarStoneCaption.ClientID %>').style.display = 'inline';
                        document.getElementById('<%= hf_DisplayPillarType.ClientID %>').value = "Granite";
                        document.getElementById('<%= txtDisplayPillarStone.ClientID %>').value = "Granite";

                    } else if (value == "Sandstone") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/Sandstone flashing.jpg") });

                        Pillar_Stone_Type = 2;
                        PillarStoneType();
                        //Display selection
                        //document.getElementById('<%= lblPillarStone.ClientID %>').textContent = "Sand Stone";
                        //document.getElementById('<%= lblPillarStoneCaption.ClientID %>').style.display = 'inline';
                        document.getElementById('<%= hf_DisplayPillarType.ClientID %>').value = "Sandstone";
                        document.getElementById('<%= txtDisplayPillarStone.ClientID %>').value = "Sandstone";

                    } else if (value == "Limestone") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/Limestone flashing.jpg") });

                        Pillar_Stone_Type = 3;
                        PillarStoneType();
                        //Display selection
                        //document.getElementById('<%= lblPillarStone.ClientID %>').textContent = "Lime Stone";
                        //document.getElementById('<%= lblPillarStoneCaption.ClientID %>').style.display = 'inline';
                        document.getElementById('<%= hf_DisplayPillarType.ClientID %>').value = "Limestone";
                        document.getElementById('<%= txtDisplayPillarStone.ClientID %>').value = "Limestone";

                    } else // (value == "Wireframe")
                        newMaterial = new THREE.MeshBasicMaterial({ wireframe: true });

                    //Apply new textures to pillar
            pillar.material = newMaterial;
            animate();
        }


                //Manipulate width of pillar
                //This function also controls the width and length of the slab and pyramid as the pillar moves.
        pillarX.onChange(function (value) {
            pillar.scale.x = value / (PILLAR_WIDTH * 10);

            //Move pyramid width
            pyramid.scale.x = pillar.scale.x;

            //Move slab width
            slab.scale.x = pillar.scale.x;

            //Put X scale value in global variable
            //Pillar_Length = pillar.scale.x;

            document.getElementById('<%= HF_PillarWidth.ClientID %>').value = value;

                });

                //Manipulate height of pillar
                //This function also controls the position of the slab and pyramid as the pillar moves.
                pillarY.onChange(function (value) {
                    pillar.scale.y = value / (PILLAR_HEIGHT * 10);

                    //Move slab position as pillar moves
                    slab.position.y = (pillar.scale.y * (10 * 6.10)) - 5.8;

                    //Move pyramid position as pillar moves
                    pyramid.position.y = (slab.position.y + SLAB_HEIGHT / 2) + (slab.scale.y * 8) - 8; //(pillar.scale.y * (10 * 6.10)) + 1.8;

                    //Put Y scale value in global variable
                    //Pillar_Height = pillar.scale.y;
                    document.getElementById('<%= HF_PillarHeight.ClientID %>').value = value;

                });


                //Manipulate length of pillar
                //This function also controls the width and length of the slab and pyramid as the pillar moves.
                pillarZ.onChange(function (value) {
                    pillar.scale.z = value / (PILLAR_LENGTH * 10);

                    //Move slab length
                    slab.scale.z = pillar.scale.z;

                    //Move pyramid length
                    pyramid.scale.z = pillar.scale.z;

                    //Put Z scale value in global variable
                    //Pillar_Width = pillar.scale.z;
                    document.getElementById('<%= HF_PillarLength.ClientID %>').value = value;
                });
                function callback() { return; }

                renderers.push({ renderer: renderer, scene: scene, camera: camera, controls: controls, callback: callback });

            }

            //Functions to send co-ordinates of pryamid and slab to code behind

            function CapStoneType() {

                document.getElementById('<%= HF_CapStoneType.ClientID %>').value = Cap_Stone_Type;
            }
            function PillarStoneType() {

                document.getElementById('<%= HF_PillarStone.ClientID %>').value = Pillar_Stone_Type;
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


    <form id="frmControls" runat="server">

        <asp:Panel runat="server" ID="pnlExistingQuote" Visible="False">
            <br />
            <asp:Label runat="server" ID="lblPanelCaption" Text="Existing Quote" CssClass="panelTitle"></asp:Label>
            <br />
            <br />
            <asp:Label runat="server" ID="lblCapHeightCaption" Text="Cap Height: " CssClass="panelCaptions"></asp:Label>
            <asp:Label runat="server" ID="lblCapHeightPanel" CssClass="panellData"></asp:Label>
            <br />
            <asp:Label runat="server" ID="lblCapWidthCaption" Text="Cap Width: " CssClass="panelCaptions"></asp:Label>
            <asp:Label runat="server" ID="lblCapWidthPanel" CssClass="panellData"></asp:Label>
            <br />
            <asp:Label runat="server" ID="lblCapLengthCaption" Text="Cap Length: " CssClass="panelCaptions"></asp:Label>
            <asp:Label runat="server" ID="lblCapLengthPanel" CssClass="panellData"></asp:Label>
            <br />
            <asp:Label runat="server" ID="lblCapPointCaption" Text="Cap Point: " CssClass="panelCaptions"></asp:Label>
            <asp:Label runat="server" ID="lblCapPointPanel" CssClass="panellData"></asp:Label>
            <br />
            <asp:Label ID="lblCapSelectionCapion" runat="server" Text="Cap Stone Type: " CssClass="panelCaptions"></asp:Label>
            <asp:Label ID="lblCapTypePanel" runat="server" CssClass="panellData"></asp:Label>
            <br />
            <br />
            <asp:Label ID="lblPillWidthCaption" runat="server" Text="Pillar Width: " CssClass="panelCaptions"></asp:Label>
            <asp:Label ID="lblPillarWidthPanel" runat="server" CssClass="panellData"></asp:Label>
            <br />
            <asp:Label ID="lblPillHeightCaption" runat="server" Text="Pillar Height: " CssClass="panelCaptions"></asp:Label>
            <asp:Label ID="lblPillHeightPanel" runat="server" CssClass="panellData"></asp:Label>
            <br />
            <asp:Label ID="lblPillLengthCaption" runat="server" Text="Pillar Length: " CssClass="panelCaptions"></asp:Label>
            <asp:Label ID="lblPillLengthPanel" runat="server" CssClass="panellData"></asp:Label>
            <br />

            <asp:Label ID="lblPillSelectionCaption" runat="server" Text="Pillar Stone Type: " CssClass="panelCaptions"></asp:Label>
            <asp:Label ID="lblPillTypePanel" runat="server" CssClass="panellData"></asp:Label>
            <br />
            <asp:Label ID="lblPillCapQuantityCaption" runat="server" Text="Quantity: " CssClass="panelCaptions"></asp:Label>
            <asp:Label ID="lblPillCapQuantityPanel" runat="server" CssClass="panellData"></asp:Label>
            <br />
            <asp:Label ID="lblTotalCostPanel" runat="server" Text="Total Cost: " CssClass="panelCaptions"></asp:Label>
            <asp:Label runat="server" ID="lblExistingTotal" CssClass="panellData"></asp:Label>
            <asp:TextBox runat="server" Visible="True" ID="txtInvisibleTotal" ReadOnly="True" ></asp:TextBox>

        </asp:Panel>


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
                        OnClick="btnCalculate_Click" OnClientClick=" PillarStoneType(); CapStoneType() ;" CausesValidation="True" />
                    <br />
                    <asp:Panel runat="server" ID="pnlQuoteCalc" Visible="False">
                        <asp:Label runat="server" ID="lblDisplayTotalCost" Text="Total Cost (euros)"></asp:Label>
                        <br />
                        <asp:Label ID="lblCalculateAnswer" runat="server"></asp:Label>
                    </asp:Panel>
                    <br />
                    <br />



                    <asp:RequiredFieldValidator ID="rfvCapStone" runat="server" ErrorMessage="Select a cap stone type" ControlToValidate="txtDisplayCapStone" Display="None"></asp:RequiredFieldValidator>

                    <asp:RequiredFieldValidator ID="rfvPillarStone" runat="server" ErrorMessage="Select a pillar stone type" ControlToValidate="txtDisplayPillarStone" Display="None"></asp:RequiredFieldValidator>

                    <asp:Label ID="lblPillarStoneCaption" runat="server" CssClass="Labels"></asp:Label>

                    <asp:Label ID="lblPillarStone" CssClass="Labels" runat="server" ClientIDMode="Static"></asp:Label>




                    <asp:ValidationSummary ID="vldSummary" runat="server" ShowMessageBox="True" ShowSummary="False" />

                    <br />
                    <br />

                    <asp:Button runat="server" ID="btnContinueOrder" Text="Add more products" CssClass="Buttons" OnClick="btnContinueOrder_Click" CausesValidation="False" />

                    <asp:Button runat="server" CssClass="Buttons" ID="btnSaveConfirm" Text="Save Quote" OnClick="btnSaveConfirm_Click" />
                    <asp:Button runat="server" ID="btnCancel" Text="Cancel" CssClass="Buttons" CausesValidation="False" OnClick="btnCancel_Click" />

                    <br />


                    <%--Hidden fields for slab and pryamid measurements--%>
                    <asp:HiddenField ID="SlabLength" runat="server" />
                    <asp:HiddenField ID="SlabWidth" runat="server" />
                    <asp:HiddenField ID="PryHeight" runat="server" />
                    <asp:HiddenField ID="SlabHeight" runat="server" />
                    <asp:HiddenField ID="HF_PillarHeight" runat="server" />
                    <asp:HiddenField ID="HF_PillarWidth" runat="server" />
                    <asp:HiddenField ID="HF_PillarLength" runat="server" />
                    <asp:HiddenField runat="server" ID="HF_CapStoneType" />
                    <asp:HiddenField runat="server" ID="HF_PillarStone" />

                    <asp:HiddenField runat="server" ID="HF_CapTotal" />
                    <asp:HiddenField runat="server" ID="HF_PillarTotal" />

                    <%--  Hidden values for validation--%>
                    <asp:HiddenField runat="server" ID="hf_DisplayCapType" />
                    <asp:HiddenField runat="server" ID="hf_DisplayPillarType" />

                    <asp:TextBox runat="server" ID="txtDisplayCapStone" CssClass="stoneTextbox" Visible="True" ReadOnly="True"></asp:TextBox>
                    <asp:TextBox runat="server" ID="txtDisplayPillarStone" CssClass="stoneTextbox" Visible="True" ReadOnly="True"></asp:TextBox>


                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>
</body>
</html>
