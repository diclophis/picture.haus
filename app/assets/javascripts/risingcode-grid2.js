var shaderz = false;
// Greetings to Iq/RGBA! ;)

var content, effect, canvas, gl, buffer, screenVertexPosition,
time = 0, screenWidth = 0, screenHeight = 0,
screenProgram, resizer = { timeout: null }, refreshTimeout = 1000;
var target = {};
var paused = false;
var precision = 6.0;
var image = null; //new Image();

if ( !window.requestAnimationFrame ) {
  window.requestAnimationFrame = ( function() {
    return window.webkitRequestAnimationFrame ||
      window.mozRequestAnimationFrame ||
      window.oRequestAnimationFrame ||
      window.msRequestAnimationFrame ||
      function ( callback, element ) {
        window.setTimeout( callback, 1000 / 30 );
      };
  } )();
}

// Initialise WebGL
var main = function() {
  canvas = document.getElementById("risingcode-canvas");
  effect = document.getElementById("risingcode-grid");
  canvas.id = "original-canvas";
  effect.id = "original-grid";
  gl = canvas.getContext( 'experimental-webgl');
  if (!gl) {
    return;
  }
  compileScreenProgram();
  if (screenProgram) {
    gl.useProgram(screenProgram);
    target.framebuffer = gl.createFramebuffer();
    target.renderbuffer = gl.createRenderbuffer();
    // Create vertex buffer (2 triangles)
    buffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([ - 1.0, - 1.0, 1.0, - 1.0, - 1.0, 1.0, 1.0, - 1.0, 1.0, 1.0, - 1.0, 1.0 ]), gl.DYNAMIC_DRAW);
    gl.vertexAttribPointer(screenVertexPosition, 2, gl.FLOAT, false, 0, 0);

    if (image) {
      var texture = gl.createTexture();
      gl.bindTexture(gl.TEXTURE_2D, texture);

      // Set the parameters so we can render any size image.
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);

      // Upload the image into the texture.
      gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image);
    }

    onWindowResize();
    window.addEventListener('resize', onWindowResize, false);
  }
}

function compileScreenProgram() {
  var program = gl.createProgram();

  var shaders = document.getElementsByClassName("shader");
  if (shaders.length == 0) {
    return;
  }
  var debugShader = document.getElementsByClassName("debug")[0];
  var fragment = debugShader ? debugShader.textContent : shaders[Math.floor(Math.random() * shaders.length)].textContent;
  //var fragment = document.getElementById( 'starnest' ).textContent;
  var vertex = document.getElementById( 'vertexShader' ).textContent;
  var vs = createShader( vertex, gl.VERTEX_SHADER );
  var fs = createShader( fragment, gl.FRAGMENT_SHADER );
  gl.attachShader( program, vs );
  gl.attachShader( program, fs );
  gl.deleteShader( vs );
  gl.deleteShader( fs );
  gl.linkProgram( program );
  if ( !gl.getProgramParameter( program, gl.LINK_STATUS ) ) {
    console.error( 'VALIDATE_STATUS: ' + gl.getProgramParameter( program, gl.VALIDATE_STATUS ), 'ERROR: ' + gl.getError() );
    return;
  }
  screenProgram = program;
  gl.useProgram( screenProgram );
  cacheUniformLocation( program, 'iGlobalTime' );
  cacheUniformLocation( program, 'iResolution' );
  screenVertexPosition = gl.getAttribLocation(screenProgram, "position");
  gl.enableVertexAttribArray( screenVertexPosition );
}

function cacheUniformLocation( program, label ) {
  if ( program.uniformsCache === undefined ) {
    program.uniformsCache = {};
  }
  program.uniformsCache[ label ] = gl.getUniformLocation( program, label );
}

function createShader(src, type) {
  var shader = gl.createShader( type );
  var line, lineNum, lineError, index = 0, indexEnd;
  gl.shaderSource( shader, src );
  gl.compileShader( shader );
  if ( !gl.getShaderParameter( shader, gl.COMPILE_STATUS ) ) {
    var error = gl.getShaderInfoLog( shader );
    while ((error.length > 1) && (error.charCodeAt(error.length - 1) < 32)) {
      error = error.substring(0, error.length - 1);
    }
    console.error( error );
    return null;
  }
  return shader;
}

function onWindowResize(event) {
  if (resizer.timeout) {
    clearTimeout(resizer.timeout);
  }
  effect.style.display = 'none';
  paused = true;
  resizer.timeout = setTimeout(function() {
    var isMaxWidth = ((resizer.currentWidth === resizer.maxWidth) || (resizer.currentWidth === resizer.minWidth)),
      isMaxHeight = ((resizer.currentHeight === resizer.maxHeight) || (resizer.currentHeight === resizer.minHeight));

    resizer.isResizing = false;
    resizer.maxWidth = window.innerWidth - 75;
    resizer.maxHeight = window.innerHeight - 125;
    if (isMaxWidth || (resizer.currentWidth > resizer.maxWidth)) {
      resizer.currentWidth = resizer.maxWidth;
    }
    if (isMaxHeight || (resizer.currentHeight > resizer.maxHeight)) {
      resizer.currentHeight = resizer.maxHeight;
    }
    if (resizer.currentWidth < resizer.minWidth) { resizer.currentWidth = resizer.minWidth; }
    if (resizer.currentHeight < resizer.minHeight) { resizer.currentHeight = resizer.minHeight; }
    var w = window.innerWidth;
    var h = window.innerHeight;
    canvas.width = w / precision;
    canvas.height = h / precision;
    canvas.style.width = w + 'px';
    canvas.style.height = h + 'px';
    effect.style.width = w + 'px';
    effect.style.height = h + 'px';
    screenWidth = canvas.width;
    screenHeight = canvas.height;
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.uniform2f(screenProgram.uniformsCache[ 'iResolution' ], screenWidth, screenHeight);
    effect.style.display = 'block';
    paused = false;
    requestAnimationFrame(animate);
  }, event ? refreshTimeout : 0);
}

function animate(step) {
  time = ((step / 100000) % 1) * 1000;
  gl.uniform1f(screenProgram.uniformsCache[ 'iGlobalTime' ], time);
  gl.drawArrays(gl.TRIANGLES, 0, 6);
  if (!paused) {
    requestAnimationFrame(animate);
  }
}

document.addEventListener('page:before-change', function() {
  paused = true;
  var primaryDivs = document.getElementsByClassName('primary');
  for (var i=0; i<primaryDivs.length; i++) {
    primaryDivs.style = "";
  }
  var secondaryDivs = document.getElementsByClassName('secondary');
  for (var i=0; i<secondaryDivs.length; i++) {
    secondaryDivs.style = "";
  }
  document.body.style = "display: none;";
});

document.addEventListener('page:change', function() {
  if (shaderz) {
    document.body.appendChild(effect);
    onWindowResize();
  }
  FastClick.attach(document.body);
  document.body.style = "";
  console.log("foo");
});

window.addEventListener('load', function() {
  FastClick.attach(document.body);
}, false);


if (shaderz) {
  document.addEventListener('DOMContentLoaded', main);
}
