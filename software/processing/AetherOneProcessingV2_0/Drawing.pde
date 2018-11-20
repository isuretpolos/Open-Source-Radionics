/**
* The draw loop of processing
*/
void draw() {
 
  noStroke();
  background(0);
  image(backgroundImage, 0, 0, width, height);
  fill(0,150);
  rect(0,0,600,555);
  rect(0,560,600,200);
  rect(610,0,440,555);
  
  fill(255);
  // 531x305
  
  stroke(255);
  text("INPUT", 10, 25);
  text("OUTPUT", 10, 55);
  //text("x: "+mouseX+" y: "+mouseY, 320, 495);

  int x = 30;
  int y = 90;
  drawGreenLED("ARDUINO\nCONNECTED", x, y, 20, arduinoConnection.arduinoFound);
  drawBlueLED("CLEARING", x + 70, y, 20, arduinoConnection.clearing);
  drawGreenLED("ANALYSING", x + 140, y, 23, false);
  drawGreenLED("BROADCASTING", x, y + 70, 20, arduinoConnection.broadcasting);
  drawGreenLED("COPY", x + 70, y + 70, 10, arduinoConnection.copy);
  drawBlueLED("GROUNDING", x + 140, y + 70, 25, arduinoConnection.grounding);
  drawRedLED("HOTBITS", x, y + 130, 20, arduinoConnection.collectingHotbits);
  drawBlueLED("SIMULATION", x + 70, y + 130, 26, !arduinoConnection.arduinoFound);

  if (arduinoConnection.arduinoConnectionEstablished() == false) {
    if ((arduinoConnectionMillis + 2500) < millis()) {
      arduinoConnectionMillis = millis();
      arduinoConnection.getPort();
      delay(250);
    }
  }

  textSize(11);
  String trngModeText = "  TRNG Mode";
  if (trngMode == false) {
    fill(255,50,10);
    trngModeText = "  PRNG Simulation Mode";
  }
  text("Hotbits " + core.hotbits.size() + trngModeText, 10, 315);
  fill(255);
  
  textSize(16);
  stroke(0, 0, 255);
  
  fill(164, 197, 249);
  if (selectedDatabase != null) {
    text(selectedDatabase.getName(), 10, 330);
  }
  
  int yRate = 350;
 
  for (int iRate=0; iRate<rateList.size(); iRate++) {
    
      RateObject rateObject = rateList.get(iRate);
      
      boolean selectRate = false;
      
      if (mouseY >= yRate - 20 && mouseY < yRate && mouseX < 600) {
        fill(10, 255, 10, 120);
        noStroke();
        rect(0, yRate - 16, 600, 20);
        selectRate = true;
      }
      
      fill(rateObject.level * 25);
      text(rateObject.level, 60,yRate);

      if (selectRate) {
        fill(255);
      } else if (rateObject.gv == 0) {
        fill(150);
      } else if (rateObject.gv > generalVitality && rateObject.gv > 1000) {
        fill(32, 255, 24);
      } else if (rateObject.gv > generalVitality) {
        fill(28, 204, 22);
      } else if (rateObject.gv < generalVitality) {
        fill(255, 105, 30);
      } else {
        fill(12, 134, 178);
      }
      
      text(rateObject.rate, 85, yRate);
      
      if (rateObject.gv != 0) {
        fill(208, 147, 255);
        text(rateObject.gv, 10, yRate);
      }
      
      yRate += 20;
  }
  
  // Draw the rate level from the last analysis
  int xRD = 0;
  
  if (ratesDoubles.size() > 0) {
    fill(164, 197, 249);
    text("Spectrum of the Analysis:",10,580);
  }
  
  for (String key :ratesDoubles.keySet()) {
    Integer level = ratesDoubles.get(key);
    stroke(0,25 * level,0);
    if (key.equals(cp5.get(Textfield.class, "Output").getText())) {
      stroke(255);
    }
    line(xRD,760,xRD,760 - (level*15));
    xRD++;
    if (xRD >= 599) xRD = 0;
  }
  
  noStroke();
  
  if (generalVitality == null && rateList.size() > 0) {
    fill(135, 223, 255);
    text("Check General Vitality as next step!", 10, yRate);
  } else if (generalVitality != null) {
    fill(150, 227, 255);
    text("General Vitality is " + generalVitality, 10, yRate);
  } else if (selectedDatabase != null && rateList.size() == 0) {
    fill(66, 214, 47);
    text("Focus and then click on ANALYZE", 10, yRate);
  }
  
  // PHOTOGRAPHY
  if (tile != null) {
    fill(0);
    rect(620,40,420,460);
    tile.drawTile();
  }
  
  if (connectMode || disconnectMode) {
    if (core.getRandomNumber(1000) > 950) {
      progress += 1;
      core.setProgress(progress);
    }
    
    if (progress >= 100) {
      
      if (connectMode) {
        monitorText = "CONNECTED!";
      }
      
      if (disconnectMode) {
        monitorText = "DISCONNECTED!";
      }
      
      connectMode = false;
      disconnectMode = false;
      core.persistHotBits();
    }
  }
}

/**
* Draw LEDs on the gui ...
*/
void drawRedLED(String text, int x, int y, int textOffset, boolean on) {
  drawLED(text, x, y, textOffset, on, 255, 0, 0);
}

void drawGreenLED(String text, int x, int y, int textOffset, boolean on) {
  drawLED(text, x, y, textOffset, on, 0, 255, 0);
}

void drawBlueLED(String text, int x, int y, int textOffset, boolean on) {
  drawLED(text, x, y, textOffset, on, 0, 0, 255);
}

void drawLED(String text, int x, int y, int textOffset, boolean on, int r, int g, int b) {
  fill(50, 0, 0);
  if (on) {
    fill(r, g, b);
  }
  stroke(200);
  strokeWeight(3);
  ellipse(x, y, 30, 30);
  strokeWeight(1);

  fill(255);
  textSize(9);
  text(text, x - textOffset, y + 30);
}
