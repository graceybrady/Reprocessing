import processing.sound.*;

//how to load a soundFile
//file = new SoundFile(this,"Sound/heartRate.wav"); //this loads the file based on the file name
//file.play();
//file.amp(.5); //this changes the volume level (number between 0 and 1)

//sounds
SoundFile drums;
SoundFile intro;

PImage backgroundImage;

//Animations
PImage breatheBackground;
//PImage[] bee = new PImage[3];
PImage[] breathe = new PImage[184];
PImage[] hale = new PImage[9];
int breatheClicks = 0;


//PUZZLE
final int NUM_TILES = 5;
PImage baseImage;
PImage[][] mainCopy = new PImage[NUM_TILES][NUM_TILES]; //chopped up correct
PImage[][] board = new PImage[NUM_TILES][NUM_TILES]; //chopped up jumbled
int sqSide, clickedRow, clickedCol, releasedRow, releasedCol;
int numClicks = 0; //help identify user first clicking

int timeWhenBallMoved; //when was the ball moved last
int currentTime; //stores the current time
int elapsedTime; //stores the time that has passed

void setup(){
  size(750,750);
  backgroundImage = loadImage("main.png");
  backgroundImage.resize(width, height);
  background(backgroundImage);
  frameRate(7);
  
  
  //sound
  drums = new SoundFile(this,"soundtrack.wav");
  drums.play();
  drums.amp(.2); //this changes the volume level (number between 0 and 1)
  intro = new SoundFile(this, "introduction.wav");
  intro.play();
  intro.amp(1);
  
  
  //puzzle
  baseImage = loadImage("sky.png");
  baseImage.resize(width, height);
  sqSide = width/NUM_TILES;
  chop();
  
  //caterpiller
  breatheBackground = loadImage("tree.png");
  breatheBackground.resize(width, height);
  //for(int i=0;i<breathe.length;i++){
  //  breathe[i] = loadImage("caterpiller/caterpillers" + (i+1) + ".png");
  //  breathe[i].resize(width, height);
    //hale[i] = loadImage("hale" + i + ".png");
    //hale[i].resize(width, height);
  //}
  
  //exhale inhale hold
    for(int i=0;i<hale.length;i++){
      hale[i] = loadImage("breathe/breathe" + i + ".png");
      hale[i].resize(width/6, height/6);
  }
  
  ////bee array
  //  for(int i=0;i<bee.length;i++){
  //    bee[i] = loadImage("bee/bee" + i + ".png");
  //    bee[i].resize(width/6, height/6);
  //}
}
 
void draw() {
  
  //frameRate(5);
  //  image(heartRate[frameCount%8],0,0);
  //  if (count<4){
  //    image(bed, 0, 0);
  //    image(squiggle[frameCount%4], 0, 0);
  //  }
  
  if(breatheClicks == 1){
    //caterpiller animation
    frameRate(7);
    background(breatheBackground);
    image(breathe[frameCount%184], 0,0);
    
    
    //inhale exale
    //frameRate(1);
    //frameRate(1);
    //image(hale[frameCount%9], width*3/4,height/4);
    //frameRate(1);
    frameRate(7);
  }
}

void mousePressed(){
  
  //PUZZLE CODE BEGINS
  if(mouseX < width/2 && mouseY < height/2 && numClicks == 0){
    displayPuzzle();
    numClicks=1;
  }else if(numClicks == 1){
    //user has clicked into the puzzle area
    jumble();
    displayPuzzle();
    numClicks=2;
  }else if(numClicks == 2){
      clickedRow = int(mouseY/sqSide);
      clickedCol = int(mouseX/sqSide);
  }//PUZZLE CODE ENDS
  
}


int b=0;
void keyPressed(){
  if(key == CODED && breatheClicks == 1){
    image(hale[b], 0,0);
    b++;
    ////for(int i=0;i<breathe.length;i++){
    //  if(keyCode == UP && b > 0 && b < 4){
    //    image(breathe[b],0,0);
    //    b++;
    //  }else if(keyCode == DOWN && b < 3 && b >9){
    //    image(breathe[b], 0,0);
    //    b++;
    //  }
    }if(b == 9){
      b=0;
    }
    //}
  //} 
}

void mouseReleased(){
  
  //PUZZLE CODE BEGINS
  if(numClicks == 2){
    releasedRow = int(mouseY/sqSide);
    releasedCol = int(mouseX/sqSide);
    //swap  @clickedrow, lcikedcol, with released row and col
    PImage buffer = board[clickedRow][clickedCol];
    board[clickedRow][clickedCol] = board[releasedRow][releasedCol];
    board[releasedRow][releasedCol] = buffer;
    displayPuzzle();
    //check if game has come to an end
    if(checkEndGame() == true){
      surface.setTitle("You Win!");
      image(backgroundImage,0,0);
    }
  }
  //PUZZLE CODE ENDS
  
  //BREATHE CODE BEGINS
  if(checkEndGame() == true && mouseX > width/2 && mouseY < height/2){
    background(breatheBackground);
    breatheClicks = 1;
  }
  //else if(mouseX > width/5 && mouseY < height/5 && breatheClicks == 1){
  //  numClicks = 0;
  //  background(backgroundImage);
  //}
  //BREATHE CODE ENDS
  
}



//PUZZLE
void chop(){
  //imageName.get(x, y, re dw, reqdH) - gives us portion of the image 
  for(int row=0; row<NUM_TILES; row++){
    for(int col=0; col<NUM_TILES; col++){
      mainCopy[row][col] = baseImage.get(col*sqSide, row*sqSide, sqSide, sqSide);
      board[row][col] = mainCopy[row][col];
    }
  }
}

//PUZZLE
void displayPuzzle(){
  for(int row=0; row<NUM_TILES; row++){
    for(int col=0; col<NUM_TILES; col++){
      image(board[row][col], col*sqSide, row*sqSide, sqSide, sqSide);
      //image function brings the image to given place & resize to given size
    }
  }
}

//PUZZLE
void jumble(){
  int randomRow, randomCol;
  for(int row=0; row<NUM_TILES; row++){
    for(int col=0; col<NUM_TILES; col++){
      randomRow= int(random(NUM_TILES));
      randomCol= int(random(NUM_TILES));
      //swap each tile with another random tile
      PImage buffer = board[row][col];
      board[row][col] = board[randomRow][randomCol];
      board[randomRow][randomCol] = buffer;
    }
  }
}

//PUZZLE
boolean checkEndGame(){
  for(int row=0; row<NUM_TILES; row++){
    for(int col=0; col<NUM_TILES; col++){
      if(board[row][col] != mainCopy[row][col]){
        return false;
      }
    }
  }
  return true;
}
