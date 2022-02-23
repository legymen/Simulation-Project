class ElectroWorld {

  float k_e; // electrostatic constant (Not the real one :p )

  ArrayList<ElectroObject> things; // Arraylist for all the things

  boolean fieldOn, toggleFieldOn;

  ElectroWorld(float _k_e) {
    k_e = _k_e;

    things = new ArrayList<ElectroObject>();

    fieldOn = false;
    toggleFieldOn = false;
  }

  void run() {

    // Add a thing if mouse released
    if (mReleased) {
      float charge = 0;
      if (mouseButton == LEFT) {
        charge = 100;
      } else if (mouseButton == RIGHT) {
        charge = -100;
      }

      things.add(new ElectroObject(
        new PVector(mouseX, mouseY), 
        new PVector(0, 0), 
        new PVector(0, 0), 
        50, 
        charge, 
        10,
        true));

      mReleased = false;
    }

    // Control electrostatic constant
    if (keysPressed.hasValue("w")) {
      k_e = k_e + 0.001;
    } else if (keysPressed.hasValue("s")) {
      k_e = k_e - 0.001;
    }

    // Toggle field on
    if (keysPressed.hasValue("t") && !toggleFieldOn) {
      fieldOn = !fieldOn;
      toggleFieldOn = true;
    } else {
      toggleFieldOn = false;
    }

    // Render and update the world
    render();
    update();
  }

  void update() {

    // Apply electroforce to all things
    for (ElectroObject currentThing : things) {
      for (ElectroObject thing : things) {
        if (currentThing != thing) {
          currentThing.applyForce(calculateElectrostaticForce(currentThing, thing));
        }
      }
    }

    // Run all things
    for (ElectroObject currentThing : things) {
      currentThing.run();
    }
  }

  void render() {
    background(0);

    // Render the dashboard with the k_e-value
    fill(50);
    rect(0, 0, 500, 70);
    fill(255);
    textSize(30);
    textAlign(LEFT, TOP);
    text("electrostatic constant = " + nf(k_e, 0, 3), 20, 20);
  }

  PVector calculateElectrostaticForce(ElectroObject currentThing, ElectroObject thing) {

    PVector distanceVector = PVector.sub(thing.position, currentThing.position);
    float distanceMagnitude = distanceVector.mag();
    float forceMagnitude = (-1)*k_e*currentThing.charge*thing.charge/sq(distanceMagnitude);
    return distanceVector.setMag(forceMagnitude);
  }
}
