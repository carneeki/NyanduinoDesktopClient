/*
 * Nyanduino Debugger
 *
 * Basically - show me the LEDs and play a tone
 * based on the serial over USB output of the
 * Nyanduino sketch.
 */
/*
 * Colour mapping taken from:
 * http://www.vimeo.com/12366587
 *
 * C - Red        pin2 #ff0000
 * D - Yellow     pin3 #ffcc00
 * E - Green      pin4 #00ff00
 * F - Light Blue pin5 #6666ff
 * G - Dark Blue  pin6 #0000ff
 * A - Purple     pin7 #6600ff
 * B - Pink       pin8 #ff9999
 */

import fullscreen.*;

import ddf.minim.*;
import ddf.minim.signals.*;

import processing.serial.*;

// Setup Audio
Minim minim;
AudioOutput out;
SineWave sine;

// Setup Serial
// 115200
Serial comm;

FullScreen fs;

String commData;
int note;
int len;

static final int REST     = 0;
static final int NOTE_DS4 = 51;
static final int NOTE_E4  = 52;
static final int NOTE_FS4 = 54;
static final int NOTE_GS4 = 56;
static final int NOTE_AS4 = 58;
static final int NOTE_B4  = 59;
static final int NOTE_CS5 = 61;
static final int NOTE_D5  = 62;
static final int NOTE_DS5 = 63;
static final int NOTE_E5  = 64;
static final int NOTE_FS5 = 66;
static final int NOTE_GS5 = 68;

String commport = "COM3";

void setup() {
  // init screen
  size(320,200);
  background(255);
  
  frameRate(50);
  
  fs = new FullScreen(this);
  fs.enter();
  
  // init audio
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
  sine = new SineWave(440, 0.1, out.sampleRate());
  out.addSignal(sine);
  
  // init serial
  comm = new Serial(this, commport, 115200);
  comm.bufferUntil('\n');
}

void draw() {
  // nothing reall todo here; it's all based on
  // serialEvent callback.
}

void serialEvent(Serial comm) {
  commData = comm.readStringUntil('\n');
  commData = commData.substring(0, commData.length() - 1);
  
  note = int(commData.substring(0, commData.indexOf(",")));
  len = int(commData.substring(commData.indexOf(",") +1, commData.length() - 1));
  
  doNote(note, len);
}

void doNote(int note, int len) {
  println("note: " + note + " len: " + len);
  doLed(note);
  doSound(note);
  delay(len);
  out.noSound();
  
}

void doLed(int note) {
/*
 * DS4 - Dark Yellow  51 #aa8800
 * E4  - Green        52 #77ff44 090'
 * FS4 - Dark Blue    54 #00ffff
 * GS4 - Purple Blue  56 #0033ff 225
 * AS4 - Purple       58 #5700aa 270
 * B4  - Pink         59 #ff00bb 315
 * CS4 - Dark Red     61 #660000
 * D5  - Yellow       62 #ffcc00 045'
 * DS5 - Dark Yellow  63 #aa8800
 * E5  - Green        64 #77ff44 090'
 * FS5 - Light Blue   66 #00ff44 135'
 * GS5 - Dark Purple  68 #330066
 *
 * [1] C4  - Red         60 #ff0000 000'
 * [1] A5  - Purple      #8300ff 270
 * [1] B5  - Pink        #ff00bb 315
 * [1] C5  - 
 */
  switch(note) {
    case NOTE_DS4:
      background(#aa8800);
      break;
    case NOTE_E4:
      background(#77ff44);
      break;
    case NOTE_FS4:
      background(#00ffff);
      break;
    case NOTE_GS4:
      background(#0033ff);
      break;
    case NOTE_AS4:
      background(#5700aa);
      break;
    case NOTE_B4:
      background(#ff00bb);
      break;
    case NOTE_CS5:
      background(#660000);
      break;
    case NOTE_D5:
      background(#ffcc00);
      break;
    case NOTE_DS5:
      background(#aa8800);
      break;
    case NOTE_E5:
      background(#77ff44);
      break;
    case NOTE_FS5:
      background(#00ff44);
      break;
    case NOTE_GS5:
      background(#330066);
      break;
    case -1:
    case REST:
      background(0);
      break;
    default:
      println("Unaccounted value: " + note);
      break;
  }
}

void doSound(int note) {
  float Hz;
  float base = 2.0;
  float exponent = ((note - 57.0)/12.0);
  
  Hz = 440 * pow(base, exponent);
  
  sine.setFreq(Hz);
  out.sound();
}

void stop() {
  out.close();
  minim.stop();
  super.stop();
}
