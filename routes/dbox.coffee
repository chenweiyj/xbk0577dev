dbox = require 'dbox'
settings = require '../conf/settings'

app_key = settings.dbox_app_key
app_secret = settings.dbox_app_secret
access_token = settings.dbox_access_token

app = dbox.app { "app_key": app_key, "app_secret": app_secret }
client = app.client access_token

module.exports = client
