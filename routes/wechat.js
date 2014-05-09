// Generated by CoffeeScript 1.7.1
var api, crypto, dbox_client, dboxlog, defaultMenu, express, logger, menuconf, router, settings, token, wechat;

express = require('express');

crypto = require('crypto');

wechat = require('wechat');

logger = require('./logger');

dbox_client = require('./dbox');

settings = require('../conf/settings');

menuconf = require('../conf/menuconf');

api = new wechat.API(settings.appid, settings.appsecret);

router = express.Router();

token = settings.token;

defaultMenu = menuconf.defaultMenu;

dboxlog = function(message) {
  var date, wechatlog;
  date = new Date(message.CreateTime * 1000);
  wechatlog = settings.wechatlog + date.toISOString().split("T")[0];
  return dbox_client.get(wechatlog, function(status, reply) {
    var buffer;
    buffer = JSON.stringify(message);
    if (status === 200) {
      buffer = reply.toString() + "\n" + buffer;
      return dbox_client.put(wechatlog, buffer, function(status, reply) {});
    } else {
      return dbox_client.put(wechatlog, buffer, function(status, reply) {});
    }
  });
};

router.get('/', function(req, res) {
  var echostr;
  echostr = req.query.echostr;
  if (wechat.checkSignature(req.query, token)) {
    return res.send(echostr);
  } else {
    return res.send(401, 'You are not wechat server!');
  }
});

router.post('/', wechat(token, wechat.text(function(message, req, res, next) {
  var messageString;
  if (wechat.checkSignature(req.query, token)) {
    dboxlog(message);
    logger.info(message);
    if (/^menu:reset$/.test(message.Content)) {
      api.createMenu(defaultMenu, function(err, result) {
        return console.log(result);
      });
    }
    messageString = JSON.stringify(message);
    return res.reply(messageString + '\n<a href="http://www.baidu.com/">商城</a>');
  } else {
    logger.warn('Not from wechat server!');
    return next();
  }
}).image(function(message, req, res) {
  if (wechat.checkSignature(req.query, token)) {
    dboxlog(message);
    logger.info(message);
    return res.reply(JSON.stringify(message));
  } else {
    return next();
  }
}).location(function(message, req, res) {
  if (wechat.checkSignature(req.query, token)) {
    dboxlog(message);
    logger.info(message);
    return res.reply(JSON.stringify(message));
  } else {
    return next();
  }
}).voice(function(message, req, res) {
  if (wechat.checkSignature(req.query, token)) {
    dboxlog(message);
    logger.info(message);
    return res.reply(JSON.stringify(message));
  } else {
    return next();
  }
}).event(function(message, req, res) {
  if (wechat.checkSignature(req.query, token)) {
    dboxlog(message);
    logger.info(message);
    return res.reply(JSON.stringify(message));
  } else {
    return next();
  }
})));

module.exports = router;