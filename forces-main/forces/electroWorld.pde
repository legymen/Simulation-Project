class ElectroWorld {

  float k_e; // electrostatic constant (Not the real one :p )

  ArrayList<ElectroObject> things; // Arraylist for all the things
  //ArrayList<ElectroTObject> testThings; // Arraylist for all the test things

  boolean fieldOn, toggleFieldOn, enableTObjects;

  PVector field;

  ElectroWorld(float _k_e) {
    k_e = _k_e;

    things = new ArrayList<ElectroObject>();
    //testThings = new ArrayList<ElectroTObject>();

    field = new PVector(0,0);

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
        50, 
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

    // Add test objects if an electro object is present
    if (things.size() > 0) {
        for (int i = 0; i < 30; i++) {
          for (int c = 0; c < 25; c++) {
            PVector field = eField(
            new PVector(20 + i*40, 20 + c*40),
            things);
            float strength = map(field.mag(), 0, 0.005, 0, 255);
            drawArrow(20 + i*40, 20 + c*40, 30, field.heading(), strength);
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

  PVector eField(PVector location, ArrayList<ElectroObject> things) {

    PVector eField = new PVector(0,0);
    
    for (ElectroObject currentThing : things) {
      PVector cont = PVector.sub(currentThing.position, location);
      float distanceMagnitude = cont.mag();
      float contMag = k_e*currentThing.charge/sq(distanceMagnitude);
      cont.setMag(contMag);

      eField.add(cont);
    }
    return eField;
  }
  
  void drawArrow(float cx, float cy, float len, float angle, float strength) {
    stroke(strength);
    strokeWeight(1);
    pushMatrix();
    translate(cx, cy);
    rotate(angle);
    line(0, 0, len, 0);
    line(len, 0, len - 8, -8);
    line(len, 0, len - 8, 8);
    popMatrix();
  }
}
