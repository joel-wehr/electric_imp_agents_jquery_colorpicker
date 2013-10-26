imp.configure("RGB Color Picker",[],[]);

red <- 255;
green <- 255;
blue <- 255;

agent.on("rgb", function(data) {
    red = data.red.tointeger();
    green = data.green.tointeger();
    blue = data.blue.tointeger();
    server.log("RGB: " + red + ", " + green + ", " + blue);
});
