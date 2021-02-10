// Inverted Pendulum code ported from original Java Applet code
// by Chuck Anderson (https://www.cs.colostate.edu/~anderson/code/Pole.java), 1998.
// Stephen Sheridan TU Dublin Blanchardstown Campus 2021

// Globals
int action;
float pos, posDot, angle, angleDot;

//Constants
final double cartMass=0.5;
final double poleMass=0.1;
final double poleLength=90.0; ;
final double forceMag=15.0;
final double tau=0.09;
final double fricCart=0.00005;
final double fricPole=0.005;
final double totalMass = cartMass + poleMass;
final double halfPole = 0.5 * poleLength; ;
final double poleMassLength = halfPole * poleMass;
final double fourthirds = 4.0/3.0;
final int trackVert = 300;
final int width = 500;
final int height = 500;

public void settings() {
    size(width, height);
    // Initialize pole state.
    resetPole();
}

public void resetPole() {
    pos = width/2;
    posDot = 0.0;
    angle = 0.0;
    angleDot = 0.0;
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      action = -1;
    } 
    else if (keyCode == RIGHT) {
      action = 1;
    }
  }
  else{
    if (keyCode == ' ') {
      action = 0;
      resetPole();
    }
  }
}
public void draw(){
  // Clear the background
  background(255);
  
  //Update the state of the pole, calculate derivatives
  double force = forceMag * action;
  double sinangle = sin(angle);
  double cosangle = cos(angle);
  double angleDotSq = angleDot * angleDot;
  double common = (force + poleMassLength * angleDotSq * sinangle
                - fricCart * (posDot<0 ? -1 : 0)) / totalMass;
  double angleDDot = (5.0 * sinangle - cosangle * common
                - fricPole * angleDot / poleMassLength) /
                  (halfPole * (fourthirds - poleMass * cosangle * cosangle /
                  totalMass));
  double posDDot = common - poleMassLength * angleDDot * cosangle /
                 totalMass;

  // Update the new state
  pos += posDot * tau;
  posDot += posDDot * tau;
  angle += angleDot * tau;
  angleDot += angleDDot * tau;
          
  // Apply appropriate action to the cart
  if (angle < 0 && angleDot < 0)
    action = -1;
  else if (angle > 0 && angleDot > 0)
    action = +1;
  else
    action = 0;
          
  // Draw the track
  fill(204, 102, 0);
  stroke(204, 102, 0);
  rect(25,trackVert-10,25,10);
  rect(455,trackVert-10,25,10);
  rect(25,trackVert,455,20);
  stroke(0,0,0);
          
  // Do some very crude collision detection for end of track
  if (pos-20 <= 50){
    pos = 50+20;
    action = 1;
  }
  else if (pos+20 >= 455){
    pos = 455-20;
    action = -1;
  }
  
  // Draw the cart
  fill(0,0,0);
  rect(pos-20,trackVert-10,40,10);
          
  // Draw the pole
  line(pos,trackVert-10,(float)(pos + sin(angle) * poleLength), (trackVert-10)-(float)(poleLength * cos(angle)));
  
  // Report some output        
  text("Press <- or -> to nudge the cart or SPACE to reset simulation", 60,20);
  text("Angle= " + angle,10,420);
  text("Angular Velocity= " + angleDot,10,435);
  text("Pos= " + pos,10,450);
  text("Action= " + action,10,465);
}
