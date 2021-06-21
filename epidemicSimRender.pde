// Import java random lib
import java.util.Random;

JSONArray bakeData;

float MEAN, STD_DEV;

// Declare new random generator
Random gen;

// Create a walker array
Walker[] walkers;

// Create graphs
Graph infGraph;
Graph deathGraph;

int lengthFps = 60*5;

int frames = 0;

long sizeTest = 0;

boolean play = false;

void setup() {
  // Set window size
  size(600, 600);
  frameRate(60);
  // Disable stroke and enable anti-aliasing
  noStroke();
  smooth();

  if (play) {
    bakeData = loadJSONArray("data/image.json");
  } else {
    bakeData = new JSONArray();
  }

  // Define generator and graphs
  gen = new Random();
  infGraph = new Graph(color(100, 50, 50, 200));
  deathGraph = new Graph(color(50, 50, 100, 200));

  // Spawn a number of walkers with a specified size and infection spawn chance
  spawnWalkers(30000, 2, 0.01);

  // Set normal distribution parameters
  MEAN = 3;
  STD_DEV = 1;
}

void draw() {
  if (!play) {

    if (frameCount > lengthFps) {
      println(sizeTest);
      //saveJSONArray(bakeData, "data/image.json");
      delay(1000);
      print("done");
      play = true;
    }

    int infected = 0;
    int dead = 0;

    int immune = 0;

    background(255);

    JSONArray frameData =  new JSONArray();

    // For every agent (walker)
    for (int i = 0; i < walkers.length; i++) {
      if (walkers[i].inf) infected++;
      if (walkers[i].dead) dead++;
      if (walkers[i].immune) immune++;

      walkers[i].step();
      walkers[i].outcome(0.01, 0.001);
      walkers[i].infect(1/frameRate);
      //walkers[i].render();

      JSONObject object = new JSONObject();
      object.setFloat("x", walkers[i].x);
      object.setFloat("y", walkers[i].y);

      object.setBoolean("inf", walkers[i].inf);
      object.setBoolean("dead", walkers[i].dead);
      object.setBoolean("immune", walkers[i].immune);
      sizeTest += 8.375;
      frameData.setJSONObject(i, object);
    }

    bakeData.setJSONArray(frameCount, frameData);
    // Show simulation GUI
    fill(0);
    text("Agents: " + walkers.length, 6, 10);
    text("Susceptible: " + (walkers.length-infected-dead-immune), 6, 20);
    text("Recovered: " + immune, 6, 30);
    text("Infectious: " + infected, 6, 40);
    text("Dead: " + dead, 6, 50);
    text("Frame Rate: " + (float) round(frameRate*100)/100 + " (" + (float)round(millis()/frameCount*10)/10 + " ms)", 6, 60);
    text("Time: " + millis()/1000 + " s", 6, 70);
    text("Rendering: " + frameCount + "/" + lengthFps + " - Time left: " + (lengthFps-frameCount)*(millis()/frameCount)/1000 + " seconds", 6, 80);
    // Update and render graphs
    /*infGraph.update(-infected);
     deathGraph.update(-dead);
     infGraph.render();
     deathGraph.render();*/
  } else {
    int infected = 0;
    int dead = 0;

    int immune = 0;

    background(255);
    if(frameCount-lengthFps >= lengthFps) return;
    JSONArray frameData = bakeData.getJSONArray(frameCount-lengthFps);

    // For every agent (walker)
    for (int i = 0; i < walkers.length; i++) {
      JSONObject walkerData = frameData.getJSONObject(i);

      if (walkerData.getBoolean("inf")) {
        fill(255, 0, 0);
      } else if (walkerData.getBoolean("dead")) {
        fill(0);
      } else if (walkerData.getBoolean("immune")) {
        fill(0, 0, 255);
      } else {
        fill(0, 255, 0);
      }
      circle(walkerData.getFloat("x"), walkerData.getFloat("y"), 2);

      /*if (walkers[i].inf) infected++;
      if (walkers[i].dead) dead++;
      if (walkers[i].immune) immune++;*/
    }
    // Show simulation GUI
    fill(0);
    text("Agents: " + walkers.length, 6, 10);
    text("Susceptible: " + (walkers.length-infected-dead-immune), 6, 20);
    text("Recovered: " + immune, 6, 30);
    text("Infectious: " + infected, 6, 40);
    text("Dead: " + dead, 6, 50);
    text("Frame Rate: " + (float) round(frameRate*100)/100 + " (" + (float)round(millis()/frameCount*10)/10 + " ms)", 6, 60);
    text("Time: " + millis()/1000 + " s", 6, 70);

    // Update and render graphs
    /*infGraph.update(-infected);
    deathGraph.update(-dead);
    infGraph.render();
    deathGraph.render();*/
  }
}
