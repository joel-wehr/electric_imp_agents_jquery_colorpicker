imp.configure("RGB Color Picker",[],[]);

agent.on("rgb", function(data) {
    server.log("RGB: " + data.red + ", " + data.green + ", " + data.blue);
});
