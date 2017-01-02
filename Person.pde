class Person {
  PImage full;
  PImage halo;
  PImage half;

  int[] order = new int[7];
  float[] tableX = new float[7];
  float[] tableY = new float[7];
  int foodCount = 0;

  Person() {}

  Person(String who) {
    full = loadImage("img/people/" + who + ".png");
    halo = loadImage("img/people/" + who + "Halo.png");
    half = loadImage("img/people/" + who + "Half.png");

    for (int i = 0; i < 7; i++) {
      order[i] = -1;
      tableX[i] = -1;
      tableY[i] = -1;
    }
  }

  void halfDisplay() {
    imageMode(CENTER);
    image(half, 200, 250, half.width, half.height);
    setTable();
    customer = this;
    for (int i = 0; i < 7; ++i) {
      switch (order[i]) {
      case BURGER :
        foods[i] = new Burger();
        break;
      case FRENCH_FRIES :
        foods[i] = new FrenchFries();
        break;  
      case ICE_CREAM :
        foods[i] = new IceCream();
        break;  
      case DRINK :
        foods[i] = new Drink();
        break;
      default :
        foods[i] = new Food();
        break;
      }
    }
    for (int i = 0; i < foodCount; i++) {
      foods[i].onTableX = customer.tableX[i];
      foods[i].onTableY = customer.tableY[i];
    }
    //gameState = TABLE;
  }

  void setOrder(int[] order) {
    this.order = order;
    for (int i = 0; i < 7; ++i) {
      if (order[i] != -1) {
        foodCount ++;
      }
    }
  }

  void setTable() {
    switch (foodCount) {
    case 2 :
      tableX[0] = 125;
      tableY[0] = 375;
      tableX[1] = 425;
      tableY[1] = 350;
      break;  
    case 3 :
      tableX[0] = 125;
      tableY[0] = 325;
      tableX[1] = 425;
      tableY[1] = 325;
      tableX[2] = 275;
      tableY[2] = 510;
      break;  
    case 7 :
      tableX[0] = 125;
      tableY[0] = 325;
      tableX[1] = 425;
      tableY[1] = 325;
      tableX[2] = 275;
      tableY[2] = 325;
      tableX[3] = 25;
      tableY[3] = 500;
      tableX[4] = 225;
      tableY[4] = 500;
      tableX[5] = 425;
      tableY[5] = 500;
      tableX[6] = 545;
      tableY[6] = 500;
      break;
    }
  }

  //void fullDisplay(int x, int y) {
  //  imageMode(CORNER);
  //  if (isHit(mouseX, mouseY, 0, 0, x, y, full.width, full.height)) {
  //    image(halo, x, y, halo.width, halo.height);
  //    if (mousePressed) {
  //      setTable();
  //      customer = this;
  //      for (int i = 0; i < 7; ++i) {
  //        switch (order[i]) {
  //        case BURGER :
  //          foods[i] = new Burger();
  //          break;
  //        case FRENCH_FRIES :
  //          foods[i] = new FrenchFries();
  //          break;  
  //        case ICE_CREAM :
  //          foods[i] = new IceCream();
  //          break;  
  //        case DRINK :
  //          foods[i] = new Drink();
  //          break;
  //        default :
  //          foods[i] = new Food();
  //          break;
  //        }
  //      }
  //      for (int i = 0; i < foodCount; i++) {
  //        foods[i].onTableX = customer.tableX[i];
  //        foods[i].onTableY = customer.tableY[i];
  //      }
  //      gameState = TABLE;
  //    }
  //  } else {
  //    image(full, x, y, full.width, full.height);
  //  }
  //}
}