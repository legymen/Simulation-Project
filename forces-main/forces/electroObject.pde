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
    boolean _stationary) {

    position = _pos;
    velocity = _vel;
    acceleration = _acc;
    charge = _charge;
    mass = _mass;
    size = _size;
    stationary =  _stationary;

    totalForce = new PVector(0, 0);
    if (charge > 0) {
      col = color(255,0,0);
    }
    else {
      col = color(0,0,255);
    }
  }

  void run() {
    render();
    update();
  }

  void update() {
    // Updates acceleration, velocity and position if not stationary
    if (!stationary) {
      acceleration = totalForce.div(mass); // Newtons second law
      velocity.add(acceleration);
      position.add(velocity);
    }
    // Resets acceleration and force
    acceleration.mult(0);
    totalForce.mult(0);
  }

  void render() {
    // Renders the object as a circle
    float forceLen;
    float maxLen;
    stroke(255);
    fill(col);
    ellipse(position.x, position.y, size, size);
    forceLen = 1000 * totalForce.mag();
    maxLen = constrain(forceLen, 0, 300);
    drawArrow(position.x, position.y, maxLen, totalForce.heading());
  }

  void applyForce(PVector force) {
    // Applies a force to the object
    totalForce.add(force);
  }

  void drawArrow(float cx, float cy, float len, float angle) {
    pushMatrix();
    translate(cx, cy);
    rotate(angle);
    line(0, 0, len, 0);
    line(len, 0, len - 8, -8);
    line(len, 0, len - 8, 8);
    popMatrix();
  }
}
