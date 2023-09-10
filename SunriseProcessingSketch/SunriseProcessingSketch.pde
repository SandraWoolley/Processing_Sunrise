// A simple Processing sketch that reads JSON local sunrise and UTC (Coordinated Universal Time) offset from the sunrisesunet.io API
// Draws a simple mercator projection world map and on user click prints loacls sunrise time and UTC offset in minutes at the bottom of the screen.
// Sandra Woolley, Keele University, 2023

//Mercator projection image by Strebe: https://en.wikipedia.org/wiki/Mercator_projection#/media/File:Mercator_projection_Square.JPG
//Sunrisesunet API: https://sunrisesunset.io/api/
JSONObject jsonWhole;
JSONObject jsonInner;
float longitude;
float latitude;

void setup() {
  //Setup up window, draw style and screen text and draw the Mercator world map
  size(1000, 800);
  textSize(30);
  fill(0);
  text( "Sunrise times across the globe via a JSON query of the sunrisesunset.io API", 20, 30);
  textSize(20);
  text( "Click the map below for the local sunrise time and UTC offset in minutes", 20, 55);
  image(loadImage("mercator.jpg"), 20, 90, width-40, height-140);
}
void draw() {
  //Map longitude and latitude to mouseX and mouseY position
  longitude=map(mouseX, 20, width-20, -180, 180);
  latitude=map(mouseY, 90, height-50, 90, -90);
  //Draw a text box for longitude and latitude output
  fill(0);
  rect(20, 60, width-40, 20);
  fill(255);
  text( "Mouse position: Longitude = "+nf(longitude, 0, 2) + " and Latitude = "+nf(latitude, 0, 2) + " degrees", 20, 75);
}
void mouseClicked() {
  //Make API query
  String APIQuery="https://api.sunrisesunset.io/json?lat=" + latitude + "&lng=" + longitude;
  jsonWhole = loadJSONObject(APIQuery);
  println(jsonWhole); //print to console to check JSON received

  //Draw a text box for output
  fill(0);
  rect(20, height-50, width-40, 30);
  fill(255);

  //Check if map is clicked and return from mouseClicked if not
  if (jsonWhole==null) {
    text("  Please click inside the map", 20, height-30);
    return; //return from mouseClicked if user clicks outside the image
  }
  String statusString = jsonWhole.getString("status");
  // println(statusString);

  //Check if status is OK. If it is, check if sunrise is null (ie if there is no sunrise)
  if (statusString.equals("OK")) {
    jsonInner=jsonWhole.getJSONObject("results");
    //println(jsonInner);
    if (jsonInner.isNull("sunrise")) {
      text("Oops! Today there is no sunrise at Longitude = "+nf(longitude, 0, 2) + " and Latitude = "+nf(latitude, 0, 2)+ " degrees", 20, height-30);
      return;
    }
    //Report sunrise time and UTC offset
    String sunRise = jsonInner.getString("sunrise");
    int utc_offSet = jsonInner.getInt("utc_offset");
    text("  Local time sunrise is:  "+ sunRise+ " and the UTC time difference is: "+ utc_offSet+ " minutes", 20, height-30);
  }
}
