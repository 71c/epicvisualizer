import java.util.Collections;

import ddf.minim.*;
import ddf.minim.analysis.*;


float multiply = 0;
int extraColorValue = 127;
int extraColorPlace = 3;
int xPlace = 1;
float firstPlace = 0;
float secondPlace = 0;
float speed = .0003f;
boolean started = true;
float r = 0;
boolean xKeyFast = false;
String[] songs = new String[7];
float currentVolume;
float halfWidth;
float halfHeight;

ArrayList<Float> levelsList = new ArrayList<Float>();

Minim minim;
AudioPlayer song;
FFT fft;
BeatDetect beat;


public void settings() {
    //this.fullScreen();
  size(1440, 800, P2D);
  
}

public void setup() {
  minim = new Minim(this);
  song = minim.loadFile("Deadmau5 - Arguru.mp3");
  fft = new FFT(song.bufferSize(), song.sampleRate());
  background(0);
  noStroke();
  smooth();
  song.play();
  frameRate(60);
  
  songs[0] = "Deadmau5 - Arguru.mp3";
  songs[1] = "Deadmau5 - Clockwork (1080p) -- HD.mp3";
  songs[2] = "Deadmau5 - Faxing Berlin (1080p) -- HD.mp3";
  songs[3] = "Deadmau5 - HR 8938 Cephei (1080p) -- HD.mp3";
  songs[4] = "Deadmau5 - Jaded -- HD.mp3";
  songs[5] = "Deadmau5 - Pets (Original Mix).mp3";
  songs[6] = "Colleen D'Agostino feat. deadmau5 - Stay (Drop The Poptart Edit).mp3";
}

public void spiral(float r) {
  float multiplyI;
  float rCosMultiplyIPlusWidthOn2;
  float rSinMultiplyIPlusHeightOn2;
  float weight;
  background(0);
  levelsList.add(currentVolume);
  if (currentVolume != song.mix.level()) {
    currentVolume = song.mix.level();
    if (levelsList.size() == 280)
      levelsList.remove(0);
    levelsList.add(currentVolume);
  }
  for (int i = 0; i < width; i++) {
    r++;
    multiplyI = multiply * i;
    rCosMultiplyIPlusWidthOn2 = r * cos(multiplyI) + halfWidth;
    rSinMultiplyIPlusHeightOn2 = r * sin(multiplyI) + halfHeight;


    if (xPlace == 1) {
      firstPlace = 255 * rCosMultiplyIPlusWidthOn2 / width;
      secondPlace = 255 * rSinMultiplyIPlusHeightOn2 / height;
    } else {
      firstPlace = 255 * rSinMultiplyIPlusHeightOn2 / height;
      secondPlace = 255 * rCosMultiplyIPlusWidthOn2 / width;
    }
    
    
    if (extraColorPlace == 1)
      fill(extraColorValue, firstPlace, secondPlace);
    else if (extraColorPlace == 2)
      fill(firstPlace, extraColorValue, secondPlace);
    else if (extraColorPlace == 3)
      fill(firstPlace, secondPlace, extraColorValue);

//      weight = (extraSize * 1.5f * sqrt(sqrt(x + y))) / 2;
//      strokeWeight(weight);
//      weight = pow((x + y) * currentVolume * 8, 0.25f);
//      weight = pow((r*i + halfWidth) * currentVolume * 8, 0.25f);
    weight = pow(i * i * currentVolume * 8, 0.25f);         // THIS <---- IS THE ONE USED CURRENTLY.
//      weight = ((x + y) * currentVolume * 8) * 0.0001f; // attempt to speed up ...
      //weight = pow((x + y) * map(currentVolume, Collections.min(levelsList), Collections.max(levelsList), 0.5f, 5), 0.25f);
    
//      weight = 5;
    
//      strokeWeight(weight);
//      point(rCosMultiplyIPlusWidthOn2, rSinMultiplyIPlusHeightOn2);
    
    
    ellipse(rCosMultiplyIPlusWidthOn2, rSinMultiplyIPlusHeightOn2, weight, weight);
  }
}

public void draw() {
  halfWidth = width / 2;
  halfHeight = height / 2;
  spiral(r);
  if (started) {
    multiply += speed;
  }
  if (keyPressed) {
    if (keyCode == LEFT)
      multiply -= speed * 2;
    if (keyCode == RIGHT)
      multiply += speed;
    if (keyCode == DOWN)
      speed -= 0.000005;
    if (keyCode == UP)
      speed += 0.000005;
    if (key == '[')
      multiply -= 0.125;
    if (key == ']')
      multiply += .125;
    if ((key == ',') || (key == '<'))
      extraColorValue -= 1;
    if ((key == '.') || (key == '>'))
      extraColorValue += 1;
    if (key == '1')
      extraColorPlace = 1;
    if (key == '2')
      extraColorPlace = 2;
    if (key == '3')
      extraColorPlace = 3;
    if (key == 'x' && xKeyFast)
      xPlace = xPlace == 1 ? 2 : 1;
    if (key == '-')
      r--;
    if ((key == '=') || (key == '+'))
      r++;
    if (key == 'r')
      multiply = 0;
    if (key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9' || key == '0') {
      song.pause();
      song = minim.loadFile(songs[(int) key - 52]);
      song.play();
    }
  }
  println(frameRate);
}

public void keyPressed() {
  if (key == 'x' && !xKeyFast) {
    xPlace = xPlace == 1 ? 2 : 1;
  }
  if (key == ' ') {
    started = !started;
    if (!started) {
      song.pause();
    } else {
      song.play();
    }
  }
  if (key == 'c') {
    xKeyFast = !xKeyFast;
  }
}
