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
<div id="Stats-output">
</div>
<!-- Div which will hold the Output -->
<div id="WebGL-output">
</div>

<!-- Javascript code that runs our Three.js examples -->
<script type="text/javascript">

    // once everything is loaded, we run our Three.js stuff.
    function init() {

        var stats = initStats();

        // create a scene, that will hold all our elements such as objects, cameras and lights.
        var scene = new THREE.Scene();

        // create a camera, which defines where we're looking at.
        var camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);

        // create a render and set the size
        var webGLRenderer = new THREE.WebGLRenderer();
        webGLRenderer.setClearColor(new THREE.Color(0xEEEEEE, 1.0));
        webGLRenderer.setSize(window.innerWidth, window.innerHeight);
        webGLRenderer.shadowMapEnabled = true;

        var cylinder = createMesh(new THREE.CylinderGeometry(20, 20, 20));
        // add the sphere to the scene
        scene.add(cylinder);

        // position and point the camera to the center of the scene
        camera.position.x = -30;
        camera.position.y = 40;
        camera.position.z = 50;
        camera.lookAt(new THREE.Vector3(10, 0, 0));

        // add the output of the renderer to the html element
        document.getElementById("WebGL-output").appendChild(webGLRenderer.domElement);

        // call the render function
        var step = 0;


        // setup the control gui
        var controls = new function () {
            // we need the first child, since it's a multimaterial

            this.radiusTop = 20;
            this.radiusBottom = 20;
            this.height = 20;

            this.radialSegments = 8;
            this.heightSegments = 8;

            this.openEnded = false;

            this.redraw = function () {
                // remove the old plane
                scene.remove(cylinder);
                // create a new one

                cylinder = createMesh(new THREE.CylinderGeometry(controls.radiusTop, controls.radiusBottom, controls.height, controls.radialSegments, controls.heightSegments, controls.openEnded));
                // add it to the scene.
                scene.add(cylinder);
            };
        };

        var gui = new dat.GUI();
        gui.add(controls, 'radiusTop', -40, 40).onChange(controls.redraw);
        gui.add(controls, 'radiusBottom', -40, 40).onChange(controls.redraw);
        gui.add(controls, 'height', 0, 40).onChange(controls.redraw);
        gui.add(controls, 'radialSegments', 1, 20).step(1).onChange(controls.redraw);
        gui.add(controls, 'heightSegments', 1, 20).step(1).onChange(controls.redraw);
        gui.add(controls, 'openEnded').onChange(controls.redraw);


        render();

        function createMesh(geom) {

            // assign two materials
            var meshMaterial = new THREE.MeshNormalMaterial();
            meshMaterial.side = THREE.DoubleSide;
            var wireFrameMat = new THREE.MeshBasicMaterial();
            wireFrameMat.wireframe = true;

            // create a multimaterial
            var mesh = THREE.SceneUtils.createMultiMaterialObject(geom, [meshMaterial, wireFrameMat]);

            return mesh;
        }

        function render() {
            stats.update();

            cylinder.rotation.y = step += 0.01;

            // render using requestAnimationFrame
            requestAnimationFrame(render);
            webGLRenderer.render(scene, camera);
        }

        function initStats() {

            var stats = new Stats();
            stats.setMode(0); // 0: fps, 1: ms

            // Align top-left
            stats.domElement.style.position = 'absolute';
            stats.domElement.style.left = '0px';
            stats.domElement.style.top = '0px';

            document.getElementById("Stats-output").appendChild(stats.domElement);

            return stats;
        }
    }
    window.onload = init;
</script>
</body>
</html>
