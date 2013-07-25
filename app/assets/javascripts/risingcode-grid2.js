if ( !window.requestAnimationFrame ) {
  window.requestAnimationFrame = ( function() {
    return window.webkitRequestAnimationFrame ||
      window.mozRequestAnimationFrame ||
      window.oRequestAnimationFrame ||
      window.msRequestAnimationFrame ||
      function ( callback, element ) {
        window.setTimeout( callback, 1000 / 60 );
      };
  } )();
}

// Greetings to Iq/RGBA! ;)

var content, effect, canvas, gl, buffer, screenVertexPosition,
time = 0, screenWidth = 0, screenHeight = 0,
screenProgram, resizer = { timeout: null }, refreshTimeout = 1000;
var target = {};
var paused = false;

var main = function() {
  init();
}


// Initialise WebGL
function init() {
  canvas = document.getElementById("risingcode-canvas");
  effect = document.getElementById("risingcode-grid");
  canvas.id = "original-canvas";
  effect.id = "original-grid";
  gl = canvas.getContext( 'experimental-webgl');
  if (!gl) {
    return;
  }
  compileScreenProgram();
  gl.useProgram(screenProgram);
  target.framebuffer = gl.createFramebuffer();
  target.renderbuffer = gl.createRenderbuffer();
  // Create vertex buffer (2 triangles)
  buffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([ - 1.0, - 1.0, 1.0, - 1.0, - 1.0, 1.0, 1.0, - 1.0, 1.0, 1.0, - 1.0, 1.0 ]), gl.DYNAMIC_DRAW);
  gl.vertexAttribPointer(screenVertexPosition, 2, gl.FLOAT, false, 0, 0);
  onWindowResize();
  window.addEventListener('resize', onWindowResize, false);
}

function compileScreenProgram() {
  var program = gl.createProgram();
  var fragment = document.getElementById( 'example' ).textContent;
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
    canvas.width = w / 8.0;
    canvas.height = h / 8.0;
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
});

document.addEventListener('page:change', function() {
  document.body.appendChild(effect);
  onWindowResize();
});

document.addEventListener('DOMContentLoaded', main);

