winston = require 'winston'

logger = new winston.Logger {
  transports: [
    new winston.transports.DailyRotateFile { 
      filename: './logs/wechat.log', 
      datePattern: '.yyyy-MM-dd'
    }
  ]
  exceptionHandlers: [
    new winston.transports.File { filename: './logs/exceptions.log' }
  ]
}

module.exports = logger
