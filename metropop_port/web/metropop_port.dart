import 'dart:html';
import 'dart:math';
import 'dart:async';

//based on http://www.processing.org/exhibition/works/metropop/applet.html
//with structure from https://github.com/dart-lang/bleeding_edge/blob/master/dart/samples/solar/web/solar.dart


int NUM_PARTICLES = 10000;
int NUM_ATTRACTORS = 6;

List<Attractor> attractors = new List();
List<Particle> particles = new List();


void main() {
  CanvasElement canvas = document.querySelector('#canvas');
  CanvasRenderingContext2D context = canvas.getContext('2d');
  
  canvas.style.background = '#FFFFFF';
 
  for (var i = 0; i < NUM_ATTRACTORS; i++) {
    attractors.add(new Attractor());
  }
  
  for (var i = 0; i < NUM_PARTICLES; i++) {
    particles.add(new Particle());
  }
  
  scheduleMicrotask(requestRedraw);
  
}

void draw(num _) {  
  
  CanvasElement canvas = document.querySelector('#canvas');
  CanvasRenderingContext2D context = canvas.getContext('2d');
  
  for (var i = 0; i < NUM_PARTICLES; i++) {
    for (var j = 0; j < NUM_ATTRACTORS; j++) {
      particles[i].attract(attractors[j]);
    }
    particles[i].update();
    context.setStrokeColorRgb(0, 0, 0, 0.1);
    context.strokeRect(particles[i]._x, particles[i]._y, 0.00005, 0.00005);
  }
  requestRedraw();
  
}

void requestRedraw() {
  window.requestAnimationFrame(draw);
}

//create a point which acts as a 'Gravity well'.
class Attractor {
  
  double _x;
  double _y;
  static final Random randomGen = new Random();
  
  Attractor({double x, double y}) {
    //if positional argument is not supplied, get random position constrainted by canvas dimensions.
    if (x == null) {
      _x = randomGen.nextDouble()*(document.querySelector('#canvas').clientWidth);
    } else {
      _x = x;
    }
    if (y == null) {
      _y = randomGen.nextDouble()*(document.querySelector('#canvas').clientHeight);
    } else {
      _y = y;
    }
  }
}

//create a point with a random position and velocity.
class Particle {
  
  double damp = 0.00002;
  double accel = 4000.0;
  
  double _x, _y; 
  double _vx, _vy;
  static final Random randomGen = new Random();
  
  Particle() {
    //initialise with random position
    _x = randomGen.nextDouble()*(document.querySelector('#canvas').clientWidth);
    _y = randomGen.nextDouble()*(document.querySelector('#canvas').clientHeight);
    
    //initialise with random velocity
    _vx = (randomGen.nextDouble()*2-1)*accel;
    _vy = (randomGen.nextDouble()*2-1)*accel; 
  }
  
  void attract(Attractor a) {
    double dist = pow(a._x-_x, 2) + pow(a._y-_y, 2);
    
    if (dist > 0.1) {
      _vx += accel * (a._x-_x) / dist;
      _vy += accel * (a._y-_y) / dist;
    }
  }
  
  void update() {
    _x += _vx;
    _y += _vy;
    
    _vx *= damp;
    _vy *= damp;
    
  }
  
}


  

