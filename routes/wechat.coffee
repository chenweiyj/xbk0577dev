express = require 'express'
crypto = require 'crypto'
wechat = require 'wechat'

logger = require './logger' 
dbox_client = require './dbox'

settings = require '../conf/settings'

menuconf = require '../conf/menuconf'

api = new wechat.API settings.appid, settings.appsecret

router = express.Router()

token = settings.token
defaultMenu = menuconf.defaultMenu

dboxlog = (message) -> 
  date = new Date message.CreateTime * 1000
  wechatlog = settings.wechatlog + date.toISOString().split("T")[0]
  dbox_client.get wechatlog, (status, reply) ->
    buffer = JSON.stringify message
    if status == 200
      buffer = reply.toString() + "\n" + buffer
      dbox_client.put wechatlog, buffer, (status, reply) ->
    else
      dbox_client.put wechatlog, buffer, (status, reply) ->


router.get '/', (req, res) ->
  echostr = req.query.echostr
  if wechat.checkSignature req.query, token
    res.send echostr 
  else
    res.send 401, 'You are not wechat server!'

router.post '/', wechat token, 
  wechat.text (message, req, res, next) ->
    if wechat.checkSignature req.query, token
      dboxlog message
      logger.info message
      if /^menu:reset$/.test message.Content
        # create a new menu by message.Content
        #[open, menu..., end] = message.Content.split(splitreg)
        api.createMenu defaultMenu, (err, result) -> console.log result
      
      messageString = JSON.stringify message 
      res.reply messageString + '\n<a href="http://www.baidu.com/">商城</a>'
    else
      logger.warn 'Not from wechat server!'
      next()
  .image (message, req, res) ->
    if wechat.checkSignature req.query, token
      dboxlog message
      logger.info message 
      res.reply JSON.stringify message
    else
      next()
  .location (message, req, res) ->
    if wechat.checkSignature req.query, token
      dboxlog message
      logger.info message 
      res.reply JSON.stringify message
    else
      next()
  .voice (message, req, res) ->
    if wechat.checkSignature req.query, token
      dboxlog message
      logger.info message 
      res.reply JSON.stringify message
    else
      next()
  .event (message, req, res) ->
    # message.Event is 'subscribe' | 'unsubscribe' | 'CLICK' | 'VIEW'
    if wechat.checkSignature req.query, token
      dboxlog message
      logger.info message 
      res.reply JSON.stringify message
    else
      next()

module.exports = router
