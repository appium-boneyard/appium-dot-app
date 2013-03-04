var express = require('express');
var ansispan = require('ansispan');

(function() {
  var app = express();
  app.use(express.logger());
  app.use(express.bodyParser());
  app.use(app.router);

  app.all('*', function(req, res) {
    message = req.body;
    message_text = JSON.stringify(req.body);
    console.log(message_text);
    if (message.params.message){
      $('#appium-output').append('<p>' + ansispan(message.params.message.replace(/90/g, "37")) + '</p>')
    } else {
      //$('#appium-output').append('<p>' + message_text + '</p>')
    }
    $(document).scrollTop($(document).height());
    return res.send();
  });

  app.listen(9003, '0.0.0.0', function() {
  });
})();

console.log("Webhook server listening on 9003..")
