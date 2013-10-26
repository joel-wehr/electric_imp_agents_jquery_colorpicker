const html = @"<!doctype html>
 
<html lang=""en"">
<head>
  <meta charset=""utf-8"" />
  <title>Electric Imp NeoPixel Colorpicker</title>
  <link rel=""stylesheet"" href=""https://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css"" />
  <script src=""https://code.jquery.com/jquery-1.9.1.js""></script>
  <script src=""https://code.jquery.com/ui/1.10.3/jquery-ui.js""></script>
  <style>
  #red, #green, #blue {
    float: left;
    clear: left;
    width: 300px;
    margin: 15px;
  }
  #swatch {
    width: 120px;
    height: 100px;
    margin-top: 18px;
    margin-left: 350px;
    background-image: none;
  }
  #red .ui-slider-range { background: #ef2929; }
  #red .ui-slider-handle { border-color: #ef2929; }
  #green .ui-slider-range { background: #8ae234; }
  #green .ui-slider-handle { border-color: #8ae234; }
  #blue .ui-slider-range { background: #729fcf; }
  #blue .ui-slider-handle { border-color: #729fcf; }
  </style>
  <script>
    function sendToImp(value){
        if (window.XMLHttpRequest) {devInfoReq=new XMLHttpRequest();}
        else {devInfoReq=new ActiveXObject(""Microsoft.XMLHTTP"");}
        try {
            devInfoReq.open('POST', document.URL, false);
            devInfoReq.send(value);
        } catch (err) {
            console.log('Error parsing device info from imp');
        }
    }
  function hexFromRGB(r, g, b) {
    var hex = [
      r.toString( 16 ),
      g.toString( 16 ),
      b.toString( 16 )
    ];
    $.each( hex, function( nr, val ) {
      if ( val.length === 1 ) {
        hex[ nr ] = ""0"" + val;
      }
    });
    return hex.join( """" ).toUpperCase();
  }
  function refreshSwatch() {
    var red = $( ""#red"" ).slider( ""value"" ),
      green = $( ""#green"" ).slider( ""value"" ),
      blue = $( ""#blue"" ).slider( ""value"" ),
      hex = hexFromRGB( red, green, blue );
    $( ""#swatch"" ).css( ""background-color"", ""#"" + hex );
    sendToImp('{""red"":""' + red +'"",""blue"":""' + blue + '"",""green"":""' + green + '""}');
  }
  $(function() {
    $( ""#red, #green, #blue"" ).slider({
      orientation: ""horizontal"",
      range: ""min"",
      max: 255,
      value: 127,
      
      stop: refreshSwatch
    });
    $( ""#red"" ).slider( ""value"", 255 );
    $( ""#green"" ).slider( ""value"", 255 );
    $( ""#blue"" ).slider( ""value"", 255 );
  });
  </script>
</head>
<body class=""ui-widget-content"" style=""border: 0;"">
 
<p class=""ui-state-default ui-corner-all ui-helper-clearfix"" style=""padding: 4px;"">
  <span class=""ui-icon ui-icon-pencil"" style=""float: left; margin: -2px 5px 0 0;""></span>
  Electric Imp Colorpicker
</p>
 
<div id=""red""></div>
<div id=""green""></div>
<div id=""blue""></div>
 
<div id=""swatch"" class=""ui-widget-content ui-corner-all""></div>
 
 
</body>
</html>";

http.onrequest(function(request,res){
    if (request.body == "") {
        res.send(200, html);
    }else{
        local json = http.jsondecode(request.body);
        if("red" in json && "green" in json && "blue" in json){
            server.log("RGB: " + request.body);
            device.send("rgb", json);
        }else {
            server.log("Unrecognized Body: "+request.body);
        }
        res.send(200, "");
    }
});
