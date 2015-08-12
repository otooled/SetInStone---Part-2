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
        var Top_Slap_Height = 100, Top_Slab_Width = 120, Side_Slab_Width = 150, Side_Slab_Height = 250, Fireplace_Depth = 60;

        //Global variables
        var topSlab;
        var sideSlab;
        var rightSlab;
        var slabDepth;

        var fireplace_parameters;
        var firePlace_gui;
        var fireplace_deminsions;
        var topSlabY;
        var sideSlabY;
        var sideSlabZ;
        var fireplace_depth;

        var light, topSlabGeometry, sideSlabGeometry, right_sideSlabGeometry, slabMaterial, color;
        
        //default size for top slab cap
        var TOP_SLAB_WIDTH = 40; TOP_SLAB_LENGTH = 500; TOP_SLAB_HEIGHT = 120; FIREPLACE_DEPTH = 60;
        
        //default size for side slab
        var SIDE_SLAB_WIDTH = 40; SIDE_SLAB_LENGTH = 120; SIDE_SLAB_HEIGHT = 250;
        //FIREPLACE_DEPTH = 60;
        
        //default size for side slab
        //var RIGHT_SIDE_SLAB_WIDTH = 40; RIGHT_SIDE_SLAB_LENGTH = 120; RIGHT_SIDE_SLAB_HEIGHT = 150;
       
        
        //max dimensions for top slab caps
        var MIN_TOP_SLAB_HEIGHT = 110; 
        var MAX_TOP_SLAB_HEIGHT = 160;
        
        //max dimensions for side slab - left side
        var MIN_SIDE_SLAB_HEIGHT = 200, MAX_SIDE_SLAB_HEIGHT = 400;
        
        var MIN_SIDE_SLAB_WIDTH = 30, MAX_SIDE_SLAB_WIDTH = 45;
        
        //Depth demensions for fireplace
        var MIN_FIREPLACE_DEPTH = 40, MAX_FIREPLACE_DEPTH = 100;
        var DisplayMarbleType = 0;
        </script>

    <title>Set In Stone - Fireplace</title>

</head>
<body>
    <br />
    <br />
    <div id="divTitle">
        <label>Set In Stone - Fireplace</label>
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

                //Create the top slab

                topSlabGeometry = new THREE.CubeGeometry(TOP_SLAB_WIDTH, TOP_SLAB_HEIGHT, TOP_SLAB_LENGTH);
                slabMaterial = new THREE.MeshPhongMaterial({ wireframe: true, side: THREE.DoubleSide, transparent: false, opacity: 100 });
                topSlab = new THREE.Mesh(topSlabGeometry, slabMaterial);
                topSlab.position.set(0, 95, 0);
                
                // Create left slab of fireplace
                sideSlabGeometry = new THREE.CubeGeometry(SIDE_SLAB_WIDTH, SIDE_SLAB_HEIGHT, SIDE_SLAB_LENGTH);
                sideSlab = new THREE.Mesh(sideSlabGeometry, slabMaterial);
                sideSlab.position.set(0, -90, 180);
                
                //Create right side slab
                right_sideSlabGeometry = new THREE.CubeGeometry(SIDE_SLAB_WIDTH, SIDE_SLAB_HEIGHT, SIDE_SLAB_LENGTH);
                rightSlab = new THREE.Mesh(right_sideSlabGeometry, slabMaterial);
                rightSlab.position.set(0, -90,-180);

                scene.add(topSlab, sideSlab, rightSlab);

               

                firePlace_gui = new dat.GUI({ autoplace: false });
                firePlace_gui.domElement.id = 'gui';

                fireplace_parameters =
                    {
                        Top_Slab_Height: (TOP_SLAB_HEIGHT),
                        Base_Height: (SIDE_SLAB_HEIGHT ),
                        Base_Width: (SIDE_SLAB_WIDTH),
                        Fireplace_Depth: (FIREPLACE_DEPTH),
                        baseStone: "Wireframe",
                        topSlap: "Wireframe"
                        //reset: function () { resetPier() }
                    };

                //Slider UI
                fireplace_deminsions = firePlace_gui.addFolder('Fireplace Dimensions (mm)');
                //slabX = topSlab_deminsions.add(parameters, 'Width').min(MIN_SLAB_LENGTH).max(MAX_SLAB_LENGTH).step(1).listen();
                //slabZ = topSlab_deminsions.add(parameters, 'Length').min(MIN_SLAB_WIDTH).max(MAX_SLAB_WIDTH).step(1).listen();
                topSlabY = fireplace_deminsions.add(fireplace_parameters, 'Top_Slab_Height').min(MIN_TOP_SLAB_HEIGHT).max(MAX_TOP_SLAB_HEIGHT).step(1).listen();
                
                sideSlabY = fireplace_deminsions.add(fireplace_parameters, 'Base_Height').min(MIN_SIDE_SLAB_HEIGHT).max(MAX_SIDE_SLAB_HEIGHT).step(1).listen();
                sideSlabZ = fireplace_deminsions.add(fireplace_parameters, 'Base_Width').min(MIN_SIDE_SLAB_WIDTH).max(MAX_SIDE_SLAB_WIDTH).step(1).listen();
                fireplace_depth = fireplace_deminsions.add(fireplace_parameters, 'Fireplace_Depth').min(MIN_FIREPLACE_DEPTH).max(MAX_FIREPLACE_DEPTH).step(1).listen();
                fireplace_deminsions.open();

                var fireplaceSlabMaterial = firePlace_gui.add(fireplace_parameters, 'baseStone', ["Wireframe", "Green Marble", "White Marble", "Red Marble"]).name
                ('Stone Type').listen();

                fireplaceSlabMaterial.onChange(function(value) {
                    updateFireplace();
                });
                
                //change texture of slab when stone type is changed
                //This also puts displays the stone type selected
                function
                    updateFireplace() {
                    var value = fireplace_parameters.baseStone;
                    var newMaterial;
                    if (value == "Green Marble") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/greenMarble.jpg"), shading: THREE.FlatShading, overdraw: true });
                        //Display selection

                        DisplayMarbleType = 6;
                        //document.getElementById('<%= lblFireplaceStoneCaption.ClientID %>').style.display = 'inline';
                        //document.getElementById('<%= lblFireplaceStone.ClientID %>').innerText = "Green Marble";
                        
                        document.getElementById('<%= hf_StoneType.ClientID %>').value = "Green Marble";
                        document.getElementById('<%= txtDisplayStone.ClientID %>').value = "Green Marble";
                        DisplayMarbleSelection();

                    } else if (value == "White Marble") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/whiteMarble.jpg") });
                        
                        //Display selection
                        DisplayMarbleType = 9;
                        //document.getElementById('<%= lblFireplaceStoneCaption.ClientID %>').style.display = 'inline';
                        //document.getElementById('<%= lblFireplaceStone.ClientID %>').innerText = "White Marble";
                        
                        document.getElementById('<%= hf_StoneType.ClientID %>').value = "White Marble";
                        document.getElementById('<%= txtDisplayStone.ClientID %>').value = "White Marble";
                        DisplayMarbleSelection();
                        
                    } else if (value == "Red Marble") {
                        newMaterial = new THREE.MeshLambertMaterial({ map: THREE.ImageUtils.loadTexture("Textures/redMarble.jpg") });
                        
                        //Display selection
                        DisplayMarbleType = 4;
                        //document.getElementById('<%= lblFireplaceStoneCaption.ClientID %>').style.display = 'inline';
                        //document.getElementById('<%= lblFireplaceStone.ClientID %>').innerText = "Red Marble";
                        
                        document.getElementById('<%= hf_StoneType.ClientID %>').value = "Red Marble";
                        document.getElementById('<%= txtDisplayStone.ClientID %>').value = "Red Marble";
                        DisplayMarbleSelection();
                        
                    } else // (value == "Wireframe")
                        newMaterial = new THREE.MeshBasicMaterial({ wireframe: true });

                    topSlab.material = newMaterial;
                    sideSlab.material = newMaterial;
                    rightSlab.material = newMaterial;

                    animate();
                }

                topSlabY.onChange(function (value)
                {
                    topSlab.scale.y = value / (TOP_SLAB_HEIGHT );
                    //topSlab.position.y = (topSlab.scale.y * 25) / 2;
                    sideSlab.position.y = (topSlab.scale.y * (-9 * 5.10)) -44;
                    rightSlab.position.y = (topSlab.scale.y * (-9 * 5.10)) - 44;
                    
                    //Put Y scale value in global variable
                    //Top_Slap_Height = value;//top.scale.y;
                    document.getElementById('<%= TopHeight.ClientID %>').value = value;
                });
                
                sideSlabY.onChange(function(value) {
                    sideSlab.scale.y = value / (SIDE_SLAB_HEIGHT);
                    rightSlab.scale.y = value / (SIDE_SLAB_HEIGHT);

                    topSlab.position.y = (sideSlab.scale.y * (15 * 8.10))-26 ;//(sideSlab.position.y + TOP_SLAB_HEIGHT /2) + (sideSlab.scale.y *75) ;
                   
                    //Put Y scale value in global variable
                    //Side_Slab_Height = sideSlab.scale.y;
                    document.getElementById('<%=BaseHeight.ClientID %>').value = value;
                });
                
                sideSlabZ.onChange(function (value) {
                    sideSlab.scale.z = value / (SIDE_SLAB_WIDTH);
                    rightSlab.scale.z = value / (SIDE_SLAB_WIDTH);
                   


                    //Put Z scale value in global variable
                    //Side_Slab_Width = sideSlabZ.scale.z;
                    document.getElementById('<%= BaseWidth.ClientID %>').value = value;
                });
                
                fireplace_depth.onChange(function (value) {
                    //fireplace_depth.scale.x = value / (FIREPLACE_DEPTH);
                    rightSlab.scale.x = value / (FIREPLACE_DEPTH);
                    sideSlab.scale.x = value / (FIREPLACE_DEPTH);
                    topSlab.scale.x = value / (FIREPLACE_DEPTH);
                    //topSlab.scale.x = value / (SIDE_SLAB_LENGTH);


                    //Put X scale value in global variable
                    //Fireplace_Depth = value;// topSlab.scale.x;
                    document.getElementById('<%= Depth.ClientID %>').value = value;
                });

                function callback() { return; }

                renderers.push({ renderer: renderer, scene: scene, camera: camera, controls: controls, callback: callback });
            }              
            //Functions to send co-ordinates of pryamid and slab to code behind
           
            
            function DisplayMarbleSelection() {
                document.getElementById('<%= HF_MarbleSelection.ClientID %>').value = DisplayMarbleType;
            }
            function TopWidth() {
                document.getElementById('<%= TopWidth.ClientID %>').value = Top_Slab_Width;
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
                        OnClientClick="DisplayMarbleSelection();" OnClick="btnCalculate_Click" />
                    <br />
                    <asp:Label ID="lblPreviousDetails" runat="server"  CssClass="Labels"></asp:Label>
                    <br/>
                  
                     
                        <asp:Label ID="lblFireplaceStoneCaption" runat="server" 
                            CssClass="Labels"></asp:Label>

                        <asp:Label ID="lblFireplaceStone" runat="server"  ClientIDMode="Static" CssClass="Labels" ></asp:Label>

                      <%--<br />
                    <asp:Label runat="server" ID="lblTotalCost" Visible="True"></asp:Label>--%>
                    <br />
                    <asp:Label runat="server" ID="lblDisplayTotalCost"  CssClass="Labels" Visible="True" ></asp:Label>
                     <asp:Label runat="server" ID="lblCalculateAnswer" CssClass="Labels"></asp:Label>
                    <br />
                    <br />
                    <asp:Button runat="server" ID="btnContinue" Text="Add more products" CssClass="Buttons" OnClick="btnContinue_Click"/>
                   

                    <asp:Button runat="server" CssClass="Buttons" ID="btnSaveConfirm" Text="Save Quote" OnClick="btnSaveConfirm_Click"
                         />
                    <asp:Button runat="server" ID="btnCancel" Text="Cancel" CssClass="Buttons" CausesValidation="False" OnClick="btnCancel_Click" />
                    <asp:TextBox runat="server" ID="txtDisplayStone"  CssClass="stoneTextbox" Visible="True" ReadOnly="True" 
                        ></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvStoneType" runat="server" ControlToValidate="txtDisplayStone" Display="None" ErrorMessage="Select a marble type"></asp:RequiredFieldValidator>
                    <asp:RequiredFieldValidator ID="rfvQuantity" runat="server" ControlToValidate="txtQuantity" Display="None" ErrorMessage="Enter a quantity" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    
                    <%--Hidden fields for slab and pillar measurements--%>
                    <asp:HiddenField ID="TopHeight" runat="server" />
                    <asp:HiddenField ID="TopWidth" runat="server" Value="120" />
                    <asp:HiddenField ID="BaseHeight" runat="server" />
                    <asp:HiddenField ID="BaseWidth" runat="server" />
                    <asp:HiddenField ID="Depth" runat="server" />
                    
                    <asp:HiddenField ID="HF_MarbleSelection" runat="server"/>

                   <asp:HiddenField runat="server" ID="hf_StoneType"/>
                    <asp:Label ID="Label1" runat="server"></asp:Label>

                    <asp:ValidationSummary ID="vldSummary" runat="server" ShowMessageBox="True" ShowSummary="False" />

                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

    </form>
</body>
</html>
