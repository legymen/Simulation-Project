/**
* The electroObject class implements a simple object with charge that can
* respond to a force applied to it.
* This is done by every frame first sum all forces, then calculate
* acceleration, velocity and position.
*
* @author  Andreas W
* @version 1.0
* @since   2022-02-14
*/

class ElectroObject {

  PVector position;
  PVector velocity;
  PVector acceleration;

  PVector totalForce;

  boolean stationary;

  float charge;
  float mass;
  float size;
  color col;

  ElectroObject(
    PVector _pos, 
    PVector _vel, 
    PVector _acc,
    float _mass,
    float _charge, 
    float _size, 
    color _col,
    boolean _stationary) {

    position = _pos;
    velocity = _vel;
    acceleration = _acc;
    charge = _charge;
    mass = _mass;
    size = _size;
    col = _col;
    stationary =  _stationary;

    totalForce = new PVector(0, 0);
  }

  void run() {
    render();
    update();
  }

  void update() {
    // Updates acceleration, velocity and position if not stationary
    if (stationary){
      acceleration = totalForce.div(mass); // Newtons second law
      velocity.add(acceleration);
      position.add(velocity);
    }
    // Resets acceleration and force
    acceleration.mult(0);
    totalForce.mult(0);
  }

  void render(){
    // Renders the object as a circle
    stroke(255);
    fill(col);
    ellipse(position.x, position.y, size, size);
    line(position.x, position.y, position.x + 1000 * totalForce.x, position.y + 1000 * totalForce.y);
  }

  void applyForce(PVector force){
    // Applies a force to the object
    totalForce.add(force);
  }
  
  void drawArrow(int cx, int cy, int len, float angle){
  pushMatrix();
  translate(cx, cy);
  rotate(radians(angle));
  line(0,0,len, 0);
  line(len, 0, len - 8, -8);
  line(len, 0, len - 8, 8);
  popMatrix();
}

}
