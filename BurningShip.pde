
/// Parameters ///

int Res    = 5000;
int Iter   = 250;
float Mag  = 0.14;
float Xloc = 0.134;
float Yloc = -1.22;
boolean UseGradient = true;


/// Complex Number Implementation ///

class complex {
  double a, b;
  complex(double _a, double _b) {
    a = _a;
    b = _b;
  }
}

complex cadd(complex x, complex y) {
  complex z = new complex((x.a+y.a), (x.b+y.b));
  return z;
}

complex csub(complex x, complex y) {
  complex z = new complex((x.a-y.a), (x.b-y.b));
  return z;
} 

complex cmul(complex x, complex y) {
  complex z = new complex((x.a*y.a)-(x.b*y.b), (x.b*y.a)+(x.a*y.b));
  return z;
} 

complex cdiv(complex x, complex y) {
  double a=x.a, b=x.b, c=y.a, d=y.b;
  complex z = new complex((((a*c)+(b*d))/((c*c)+(d*d))), (((b*c)-(a*d))/((c*c)+(d*d))));
  return z;
}

float cabs(complex x) {
  return sqrt((float)(x.a*x.a + x.b*x.b));
}


/// Misc Functions ///

double dabs(double x) {
  if (x < 0) { return -x; }
  return x;
}

boolean escapeTimeCheck(complex c) {
  if (((c.a*c.a) + (c.b*c.b)) < 4.0) {
    return true;
  }
  return false;
}


/// Fractal Function ///

float BurningShipFunc(complex c, int i) {
  complex z = new complex(0, 0);
  int k=0;
  while (k<i && escapeTimeCheck(z)) {
    complex z_abs = new complex(dabs(z.a), dabs(z.b));
    z = cadd(cmul(z_abs, z_abs), c);
    k++;
  }
  float sm = k + 1 - log(log(cabs(z))) / log(2);
  return sm;
}


/// Gradient ///

PImage Gradient;
color GetGrad(float index) {
  int intIndex = floor(map(index, 0.0, Iter, 0.0, Gradient.width));
  color c = Gradient.get(intIndex, int(Gradient.height/2));
  return c;
}


/// Canvas ///

PGraphics Canvas;
void DrawBurningShip(int res, int iterations) {
  Canvas.beginDraw();
  Canvas.colorMode(HSB, 360, 100, 100);
  Canvas.background(0);
  float d = Mag/res;
  int donePercentage = 0;
  int onePercent = int(res/100); 
  for (int x=0; x<res; x++) {
    for (int y=0; y<res; y++) {
      double jx = (Xloc-(Mag/2))+(x*d);
      double jy = (Yloc-(Mag/2))+(y*d);
      complex jc = new complex(jx, jy);
      float j = BurningShipFunc(jc, iterations);
      if (UseGradient) {
        color gc = GetGrad(j);
        Canvas.stroke(hue(gc), saturation(gc), brightness(gc));
      }
      else {
        float H = map(sqrt(j), 0.0, sqrt(iterations), 0.0, 360.0)+10;
        float B = map(j, 0.0, iterations, 100.0, 20.0);
        Canvas.stroke(H, 80, B);
      }
      Canvas.point(x, y);
    }
    if ((x % onePercent) == 0) {
      println((donePercentage+1) + "% Complete...");
      donePercentage++;
    }
  }
  Canvas.endDraw();
}



/// Main Function ///

void setup() {
  size(Res, Res);
  background(0);
  stroke(255);
  colorMode(HSB, 360, 100, 100);
  Canvas = createGraphics(width, height);
  if (UseGradient) {Gradient = loadImage("gradient.png");}
  println("Drawing Set...");
  DrawBurningShip(width, Iter);
  image(Canvas, 0,0);
  println("Saving Image...");
  save("BurningShip.png");
  println("Done");
  exit();
}


