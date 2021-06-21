// Spawns a specified number of agents with a defined size and some infection spawn chance.
void spawnWalkers(int num, int size, float infChance) {
  walkers = new Walker[num];
  for (int i = 0; i < num; i++) {
    boolean inf = false;
    float xPos = random(0, width);
    float yPos = random(0, height);

    if (random(1) < infChance) {
      inf = true;
    }
    walkers[i] = new Walker(xPos, yPos, size, inf);
  }
}
