express = require 'express'
http = require 'http'
router = express.Router()

# GET home page. 
router.get '/', (req, res) ->
  options = 
    host: 'analytics23.server.163.org'
    port: 8888
    path: '/api/lesson-rank/?date=2014-05-11&comparedate=2014-05-10&limit=0,10'
    method: 'GET'  
  
  reqPost = http.request options, (resPost) ->
    # may come in chunks of unknown size
    resData = ''
    resPost.on 'data', (chunk) ->
      resData += chunk

    resPost.on 'end', ->
      res.render 'index', { title: 'Express', data: JSON.parse resData }

  reqPost.end()
  reqPost.on 'error', (e) ->
    console.error e

module.exports = router

