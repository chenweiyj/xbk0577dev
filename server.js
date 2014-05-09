#!/usr/bin/env node
var debug = require('debug')('xbk0577dev');
var app = require('./app');

app.set('port', process.env.VCAP_APP_PORT || 3000);

var server = app.listen(app.get('port'), function() {
  debug('Express server listening on port ' + server.address().port);
});
