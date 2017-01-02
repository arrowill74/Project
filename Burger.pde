import java.util.*;
class Burger extends Food {
  PImage btmbread, middlebread, topbread, 
    cheese, lettuce, meat, tomato, 
    conveyor, conveyorGlass, plate;

  Ingredients[] igds = new Ingredients[6]; //上面的食材
  Ingredients[] player = new Ingredients[7]; //建造中的漢堡
  List<Ingredients> burger = new ArrayList<Ingredients>(); //random 漢堡
  Ingredients falling;
  boolean igdFalling = false;

  int conveyorX; //conveyor's x
  int conveyorSpeed=5;

  int n = 1; //第幾層漢堡
  float CenterOfGravity; //重心

  // clock
  PImage clock;
  int clock_X, clock_Y, clock_W = 150, clock_H = 150;
  PFont second;
  int timeCount;

  //state
  int state;
  final int SAMPLE = 0;
  final int STACK = 1;
  final int CALCULATE = 2;

  Burger () {
    bg = loadImage("img/background/burgerBg.png");
    gray = loadImage("img/grey_food/grey_burger.png");
    finished = loadImage("img/burger/finished.png");
    clock = loadImage("img/clock.png");
    plate = loadImage("img/burger/plate.png");

    //burger
    btmbread = loadImage("img/burger/btmbread.png");
    middlebread = loadImage("img/burger/middlebread.png");
    topbread = loadImage("img/burger/topbread.png");
    cheese = loadImage("img/burger/cheese.png");
    lettuce = loadImage("img/burger/lettuce.png");
    meat = loadImage("img/burger/meat.png");
    tomato = loadImage("img/burger/tomato.png");
    conveyor = loadImage("img/burger/conveyor.png");
    conveyorGlass = loadImage("img/burger/conveyor_glass.png");

    state = SAMPLE;
    igds[0] = new Ingredients("middlebread");
    igds[1] = new Ingredients("topbread");
    igds[2] = new Ingredients("cheese");
    igds[3] = new Ingredients("lettuce");
    igds[4] = new Ingredients("meat");
    igds[5] = new Ingredients("tomato");
    player[0] = new Ingredients("btmbread");
    player[0].x = width/2-100;
    player[0].y = height-100;
    for (int i = 1; i < 7; i++) {
      player[i] = new Ingredients();
    } 

    for (int i=0; i<6; i++) {
      igds[i].xSpeed = conveyorSpeed;
      igds[i].x = -250-250*i;
      igds[i].y = 100;
    }

    //clock
    clock_X = 530;
    clock_Y = 30;
    second = createFont("Arial", 24);
    timeCount = 360;

    randomBurger();
  }

  //on table function
  void showGray(float x, float y) {
    imageMode(CORNER);
    image(gray, x, y, 160, 130);
    if (onClick()) {
      gameState = RUN;
      foodState = BURGER;
      playing = this;
    }
  }

  void showFinished(float x, float y) {
    imageMode(CORNER);
    image(finished, x, y, 160, 130);
  }

  boolean onClick() {
    if (isHit(onTableX, onTableY, 160, 130, mouseX, mouseY, 1, 1) && mousePressed) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    image(bg, 0, 0);
    switch (state) {
    case SAMPLE :
      //random burger image
      for (int i = 0; i < burger.size(); i++) {
        image(burger.get(i).img, 250, 400-i*20);
      }

      //clock display
      image(clock, clock_X, clock_Y, clock_W, clock_H);
      textFont(second, 60);
      fill(0) ;
      timeCount -- ;
      text(timeCount/60, 590, 140);
      if (timeCount <= 50) {
        timeCount = 0;
        state = STACK;
      }
      break;

    case STACK :
      //test sample, should be delete
      for (int i = 0; i < burger.size(); i++) {
        image(burger.get(i).img, 0, 580-i*20);
      }

      //conveyor roll
      conveyorX+=conveyorSpeed; 
      if (700+conveyorX%700>700) {
        image(conveyor, -700, 100);
      }
      image(conveyor, -700+conveyorX%700, 100);
      image(conveyor, 0+conveyorX%700, 100);     

      //igds roll
      for (int i=0; i<6; i++) {
        if (igds[i]!=null) {
          igds[i].display();
          igds[i].move();
        }
      }

      if (igdFalling) {
        falling.display();
        falling.falling();
        if (isHit(falling.x, falling.y, falling.img.width, falling.img.height, width/2-100, height-100-n*20, btmbread.width, btmbread.height)) {
          player[n] = new Ingredients(falling.name);
          player[n].x = falling.x;
          player[n].y = height-100-n*20;
          if (player[n].name == burger.get(n).name) {
            curblood++;
            if (n < 7) {
              n++;
            }
          } else {
            curblood--;
            state = SAMPLE;
            timeCount = 240;
            n = 1;
          }
          falling.y = -1000;
          igdFalling = false;
        }
      }

      for (int i=0; i < n; i++) {
        image(burger.get(i).img, player[i].x, player[i].y);
      }

      //conveyor glass
      image(conveyorGlass, 0, 50);

      if (n == 7) {
        state = CALCULATE;
      }
      break;

    case CALCULATE :
      for (int i=0; i < n; i++) {
        image(burger.get(i).img, player[i].x, player[i].y );
      }
      break;
    }
  }

  void randomBurger() {
    burger.add(new Ingredients("cheese"));
    burger.add(new Ingredients("lettuce"));
    burger.add(new Ingredients("meat"));
    burger.add(new Ingredients("tomato"));
    Collections.shuffle(burger);
    burger.add(new Ingredients("topbread"));
    burger.add(2, new Ingredients("middlebread"));
    burger.add(0, new Ingredients("btmbread"));
  }

  void keyReleased() {
    if ( keyCode == ' ') {
      for (int i=0; i<igds.length; i++) {
        if (igds[i].x>=150 && igds[i].x<=330) {
          igds[i].disappear();
          falling = new Ingredients(igds[i].name);
          falling.x = igds[i].x;
          falling.y = 100;
          igdFalling = true;
        }
      }
    }
  }

  float CenterOfGravity() {
    float sum = 0;
    for (int i = 0; i < player.length; i++) {
      sum += (player[i].x+100)-width/2;
    }
    CenterOfGravity = sum/7;
    return CenterOfGravity;
  }
}