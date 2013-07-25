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

document.addEventListener('DOMContentLoaded', main);


function init() {
  canvas = document.getElementById("risingcode-canvas");
  effect = document.getElementById("risingcode-grid");
  canvas.id = "original-canvas";
  effect.id = "original-grid";
  setTimeout(function() {
    //var transform = perp() + " rotateX(40deg) translateY(-" + (canvas.height * 0.0)  + "px) scale3d(2.0, 1.0, 1.0)";
    //canvas.style.webkitTransform = transform;
    //canvas.style.transform = transform;
  }, 5000);
  effect.appendChild(canvas);

  // Initialise WebGL
  gl = canvas.getContext( 'experimental-webgl');

  if (gl) {
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

//function perp() {
//  var p = "perspective(" + canvas.height / 4.0 + "px)";
//  return p;
//}

function onWindowResize(event) {
  if (resizer.timeout) {
    clearTimeout(resizer.timeout);
  }

  effect.style.display = 'none';
  //content.style.display = 'none';
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
    var h = document.body.offsetHeight;
    h = window.innerHeight;

    canvas.width = w / 6.0;
    canvas.height = h / 6.0;

    canvas.style.width = w + 'px';
    canvas.style.height = h + 'px';

    effect.style.width = w + 'px';
    effect.style.height = h + 'px';

    screenWidth = canvas.width;
    screenHeight = canvas.height;

    //canvas.style.webkitTransform = perp();
    //canvas.style.transform = perp();

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.uniform2f(screenProgram.uniformsCache[ 'iResolution' ], screenWidth, screenHeight);
    effect.style.display = 'block';
    //content.style.display = 'block';
    paused = false;
    //gl.flush();
    requestAnimationFrame(animate);
  }, event ? refreshTimeout : 0);
}

document.addEventListener('page:before-change', function() {
  //onWindowResize();
  paused = true;
  //effect.remove();
});

document.addEventListener('page:change', function() {
  //console.log(document.getElementById("risingcode-grid"));
  console.log("foo");
  document.body.appendChild(effect);
  //document.getElementById("risingcode-grid").remove();
  onWindowResize();
});

function animate(step) {
  time = ((step / 100000) % 1) * 1000;
  gl.uniform1f(screenProgram.uniformsCache[ 'iGlobalTime' ], time);
  gl.drawArrays(gl.TRIANGLES, 0, 6);
  if (!paused) {
    requestAnimationFrame(animate);
  }
}
