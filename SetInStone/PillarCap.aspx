<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PillarCap.aspx.cs" Inherits="SetInStone.WebForm1" UnobtrusiveValidationMode="None" %>

<%@ Import Namespace="System.Web.Optimization" %>
<%@Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagPrefix="ajaxToolkit" %>
<%@ Register assembly="Telerik.Web.UI" namespace="Telerik.Web.UI" tagprefix="telerik" %>
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
        var Display_stone = 0;
        //Height of pyramid
        //var Pyramid_Height = 200;

        //This will act as width & length as slab
        //var Slab_Width = 0, Slab_Length = 1, Slab_Height = 0.25;
        //var Slab_Width = 800, Slab_Length = 1000, Slab_Height = 250;
        //Slab creation
        var slabGeometry, slabMaterial;
        var slab;

        //Slider and gui variables
        var parameters;
        var gui;
        var deminsions;
        var slabX, slabY, slabZ;
        var pyramidY;
        
        //Pyramid creation
        var pyramid;

        //default size for new pier cap
        var SLAB_WIDTH = 80; SLAB_LENGTH = 100; SLAB_HEIGHT = 25; PYRAMID_HEIGHT = 20;

        //max dimensions for pier caps
        var MIN_SLAB_WIDTH = 400; MIN_SLAB_LENGTH = 400; MIN_SLAB_HEIGHT = 150; MIN_PYRAMID_HEIGHT = 0;
        var MAX_SLAB_WIDTH = 1200; MAX_SLAB_LENGTH = 1200; MAX_SLAB_HEIGHT = 350; MAX_PYRAMID_HEIGHT = 300;

    
        
    </script>
     

    <title>Set In Stone</title>
</head>
<body>
    <br />
    <br />
    <div id="divTitle">
        <label>Set In Stone - Pillar Cap</label>
    </div>
            
    <div id='MainGraphic'>

                <script type='text/javascript'>

                    init();
                    alert(document.getElementById("<%= SlabHeight.ClientID %>").value);
                    
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
                        camera.position.set(100, 100, 200);

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
                        slab.position.set(0, SLAB_HEIGHT / 2, 0);

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
                            new THREE.Face3(3, 0, 4), // faces are triangles
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

                        pyramid.position.set(0, SLAB_HEIGHT, 0);
                        pyramid.overdraw = true;
                        pyramid.castShadow = true;
                        pyramid.receiveShadow = true;

                        scene.add(pyramid);
                        scene.add(new THREE.FaceNormalsHelper(pyramid));

                        //Begin slider 
                        gui = new dat.GUI({ autoplace: false });
                        gui.domElement.id = 'gui';

                                                <%--//SLAB_HEIGHT = document.getElementById("<%= SlabHeight.ClientID %>").value;--%>
                        
                        //Parameters that for product demensions
                        parameters =
                            {
                                Length: (SLAB_LENGTH * 10),
                                Width: (SLAB_WIDTH * 10),
                                Slab_Height: (SLAB_HEIGHT * 10),                         
                                Point_Height: (PYRAMID_HEIGHT * 10),  
                                stone: "Wireframe",
                                reset: function() { resetPier() }
                            };

                                                <%--//parameters(0).value = (document.getElementById("<%= SlabHeight.ClientID %>").value * 10);
                        //alert(parameters(0).value);--%>
                        
                        //Slider UI
                        deminsions = gui.addFolder('Pier Cap Dimensions (mm)');

                        //Slab controls
                        slabX = deminsions.add(parameters, 'Width').min(MIN_SLAB_LENGTH).max(MAX_SLAB_LENGTH).step(1).listen();
                        slabZ = deminsions.add(parameters, 'Length').min(MIN_SLAB_WIDTH).max(MAX_SLAB_WIDTH).step(1).listen();
                        slabY = deminsions.add(parameters, 'Slab_Height').min(MIN_SLAB_HEIGHT).max(MAX_SLAB_HEIGHT).step(1).listen();

                        //slab.scale.x = value / (20 * 10);


                        //Pyramid controls
                        pyramidY = deminsions.add(parameters, 'Point_Height').min(MIN_PYRAMID_HEIGHT).max(MAX_PYRAMID_HEIGHT).step(1).listen();
                        deminsions.open();

                        //Stone types selection
                        var productMaterial = gui.add(parameters, 'stone', ["Wireframe", "Granite", "Sandstone", "Limestone"]).name('Stone Type').listen();

                        //Call function to update cap and slab textures
                        productMaterial.onChange(function(value) {
                            updateSlab();
                        });
                      

                        //Change texture of cap when stone type is changed
                        //This also puts displays the stone type selected
                        
                        function updateSlab() {
                            var value = parameters.stone;
                            var newMaterial;
                            if (value == "Granite") {
                                newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/granite2.jpg"), shading: THREE.FlatShading, overdraw: true });
                                
                                Display_stone = 1;
                                //Display selection
                                //document.getElementById('<%= lblStoneTitle.ClientID %>').style.display = 'inline';
                                //document.getElementById('<%= lblDisplayStoneType.ClientID %>').innerText = "Granite";
                                document.getElementById('<%= hf_StoneType.ClientID %>').value = "Granite";
                                document.getElementById('<%= txtDisplayStone.ClientID %>').value = "Granite";
                              
                               
                                DisplayStoneSelection();

                            } else if (value == "Sandstone") {
                                newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/sandstone2.jpg") });

                                Display_stone = 2;
                                
                                document.getElementById('<%= hf_StoneType.ClientID %>').value = "Sandstone";
                                document.getElementById('<%= txtDisplayStone.ClientID %>').value = "Sandstone";
                                DisplayStoneSelection();
                                //Display selection
                                
                                
                            } else if (value == "Limestone") {
                                newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/limestone2.jpg") });

                                Display_stone = 3;
                                
                                document.getElementById('<%= hf_StoneType.ClientID %>').value = "Limestone";
                                document.getElementById('<%= txtDisplayStone.ClientID %>').value = "Limestone";
                                DisplayStoneSelection();
                                //Display selection
                                
                            } else // (value == "Wireframe")
                                newMaterial = new THREE.MeshBasicMaterial({ wireframe: true });

                            //Apply new textures
                            slab.material = newMaterial;
                            pyramid.material = newMaterial;

                            animate();
                        }


                        //functions to alter shape with sliders
                        slabX.onChange(function(value) {
                            slab.scale.x = value / (SLAB_WIDTH * 10);
                            pyramid.scale.x = slab.scale.x;

                            //Put X scale value in global variable
                            //Slab_Length = slab.scale.x;
                            document.getElementById('<%= SlabWidth.ClientID %>').value = value;
                            // Slab_Width = slab.scale.x;
                           
                        });

                        //Manipulate height of slab
                        //This function also controls the position of the slab and pyramid as the slab moves.
                        slabY.onChange(function(value) {
                            slab.scale.y = value / (SLAB_HEIGHT * 10);
                            
                            //Keep slab position stationary
                            slab.position.y = (slab.scale.y * 25) / 2;
                            
                            //Keep pyramid position stationary
                            pyramid.position.y = (slab.scale.y * 25);

                            //Put Y scale value in global variable
                            //Slab_Height = slab.scale.y;
                            document.getElementById('<%= SlabHeight.ClientID %>').value = value;
                        });

                        //Manipulate length of the slab
                        //This function also controls the width and length of the slab and pyramid as the slab moves.
                        slabZ.onChange(function (value) {
                            
                            //Move slab length
                            slab.scale.z = value / (SLAB_LENGTH * 10);
                            
                            //Move pyramid length
                            pyramid.scale.z = slab.scale.z;

                            //Put Z scale value in global variable
                            //Slab_Width = slab.scale.z;
                            document.getElementById('<%=SlabLength.ClientID %>').value = value;
                        });

                        //Manipulate height of pyramid point
                        pyramidY.onChange(function(value) {
                            pyramid.scale.y = value / (PYRAMID_HEIGHT * 10);

                            //Put pryamid Y scale value in global variable
                            //Pyramid_Height = pyramid.scale.y;
                            document.getElementById('<%= PryHeight.ClientID %>').value = value;
                        });

                       

                        function callback() { return; }

                        renderers.push({ renderer: renderer, scene: scene, camera: camera, controls: controls, callback: callback });

                    }

                    //Functions to send co-ordinates of pryamid and slab to code behind
                  

                    function DisplayStoneSelection() {
                        
                        document.getElementById('<%= DisplayStoneType.ClientID %>').value = Display_stone;
                        
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
        <asp:Panel runat="server" ID="pnlExistingQuote" Visible="False">
            <br/>
            <asp:Label runat="server" ID="lblPanelCaption" Text="Existing Quote" CssClass="panelTitle"></asp:Label>
            <br/>
            <br/>
            <asp:Label runat="server" ID="lblCapHeightCaption" Text="Cap Height: " CssClass="panelCaptions"></asp:Label>
            <asp:Label runat="server" ID="lblCapHeightPanel" CssClass="panellData"></asp:Label>
            <br/>
            <asp:Label runat="server" ID="lblCapWidthCaption" Text="Cap Width: " CssClass="panelCaptions"></asp:Label>
            <asp:Label runat="server" ID="lblCapWidthPanel" CssClass="panellData"></asp:Label>
            <br/>
            <asp:Label runat="server" ID="lblCapLengthCaption" Text="Cap Length: " CssClass="panelCaptions"></asp:Label>
            <asp:Label runat="server" ID="lblCapLengthPanel" CssClass="panellData"></asp:Label>
            <br/>
            <asp:Label runat="server" ID="lblCapPointCaption" Text="Cap Point: " CssClass="panelCaptions"></asp:Label>
            <asp:Label runat="server" ID="lblCapPointPanel" CssClass="panellData"></asp:Label>
            <br/>
             <asp:Label ID="lblStoneTitle" runat="server" Text="Cap Stone Type: "  CssClass="panelCaptions"></asp:Label>
             <asp:Label ID="lblDisplayStoneType" runat="server" CssClass="panellData"></asp:Label>
            <br/>
            <asp:Label ID="lblQuantityCaption" runat="server" Text="Quantity: "  CssClass="panelCaptions"></asp:Label>
             <asp:Label ID="lblQuantityCaptionPanel" runat="server" CssClass="panellData"></asp:Label>
            <br/>
<%--            <asp:Label ID="lblTotalCostPanel" runat="server" Text="Total Cost: "  CssClass="panelCaptions"></asp:Label>--%>
<%--            <asp:Label runat="server" ID="lblExistingTotal" CssClass="panellData" Text='<%#string.Format("{0:n2}",Eval("totalamt")) %>'></asp:Label>--%>
            <asp:TextBox runat="server" Visible="False" ID="txtInvisibleTotal" ReadOnly="True"></asp:TextBox>

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
                    <asp:Button CssClass="Buttons" runat="server" ID="btnCalculate" Text="Calculate Cost" OnClick="btnCalculate_Click"
                        OnClientClick=" DisplayStoneSelection(); " />
                     <br/>
                      <asp:Panel runat="server" ID="pnlQuoteCalc" Visible="False">
                        <asp:Label runat="server" ID="lblDisplayTotalCost" Text="Total Cost (euros)" ></asp:Label>
                        <br/>
                        <asp:Label ID="lblCalculateAnswer" runat="server"  ></asp:Label>
                        </asp:Panel>
                     <br />
                    <br />
                     <br />
                   
<%--                   <asp:TextBox runat="server" ID="txtDisplayTitle" Text="Cap Stone Type:" CssClass="stoneTextbox" ReadOnly="True"></asp:TextBox>--%>
                    
                      <asp:RangeValidator ID="rgvQuantity" runat="server" ControlToValidate="txtQuantity" ErrorMessage="Max limit - 30" MaximumValue="30" MinimumValue="1" Type="Integer" Display="None"></asp:RangeValidator>
                    
                    <asp:RequiredFieldValidator ID="rfvStoneType" runat="server" ControlToValidate="txtDisplayStone" Display="None" ErrorMessage="Select a stone type"></asp:RequiredFieldValidator>
                    <asp:RequiredFieldValidator ID="rfvQuantity" runat="server" ControlToValidate="txtQuantity" Display="None" ErrorMessage="Enter a quantity"></asp:RequiredFieldValidator>
                    

                    <asp:ValidationSummary ID="vldSummary" runat="server" ShowMessageBox="True" ShowSummary="False" />
                    <br />

                    <asp:Button runat="server" ID="btnAddProducts" Text="Add more products" OnClick="btnAddProducts_Click" CssClass="Buttons" CausesValidation="False"/>
                    <asp:Button runat="server" CssClass="Buttons" ID="btnSaveConfirm" Text="Save Quote"
                        OnClick="btnSaveConfirm_Click" />
                    <asp:Button runat="server" ID="btnCancel" Text="Cancel" CssClass="Buttons" OnClick="btnCancel_Click" CausesValidation="False" />
                    <asp:TextBox runat="server" ID="txtDisplayStone"  CssClass="stoneTextbox" Visible="True" ReadOnly="True" 
                        ></asp:TextBox>
                  
                    <%--Hidden fields for slab and pryamid measurements--%>
                    <asp:HiddenField ID="SlabLength" runat="server" />
                    <asp:HiddenField ID="SlabWidth" runat="server" />
                    <asp:HiddenField ID="PryHeight" runat="server" />
                    <asp:HiddenField ID="SlabHeight" runat="server" />
                    
                    <asp:HiddenField runat="server" ID="DisplayStoneType"/>
                    
                   <asp:HiddenField runat="server" ID="hf_StoneType"/>

                    
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

        <asp:ValidationSummary ID="vlsCapValidation" runat="server" />

    </form>
    

</body>
</html>
