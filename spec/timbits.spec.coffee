timbits = require 'timbits' 
assert = require 'assert' 
path = require 'path'

homeFolder = path.join("#{process.cwd()}", "examples")

#start serving timbits

server = {}

module.exports =

	"setup": ->
		server = timbits.serve( {home: homeFolder, port: 8785 })
	 
	"teardown": ->
		server.close()
		
## Test Case #1 - check we have a valid server running
	"test that the express server object returned is functioning, note by default the root redirects so hhtp status code should be 302": (beforeExit)->
		assert.response server, 
			url: "/"
			method: "GET"
		,
			status: 200
			headers: "Content-Type": "text/html; charset=utf-8;"
		, (res) ->
			"Test Case #1 - check we have a valid server running\n" 


## Test Case #2 - Plain timbit request
	"test the plain timbit request, this is the simpliest request we could try": (beforeExit) ->
		assert.response server, 
			url: "/plain/"
			method: "GET"
		,
			status: 200
			body: /Hello Anonymous/
		, (res) ->
			"Test Case #2 - Plain timbit request\n"

		
## Test Case #3 - Plain timbit with querystring
	"test the plain timbit request with the addition of a querystring": (beforeExit) ->
		calls = 0
		assert.response server, 
			url: "/plain/?who=cthulhu"
		,
			body: /cthulhu/
		, (res) ->
			"Test Case #3 - Plain timbit with querystring\n"			


## Test Case #4 - Cherry timbit which uses the eat callback to override or extend the render method
	"test the cherry timbit, specifically we are vetting that the eat callback is working allowing us to customize the context rendered": (beforeExit) ->
		calls = 0
		assert.response server, 
			url: "/cherry/"
		,
			body: /The current server date\/time is/
			status: 200
		, (res) ->
			"Test Case #4 - Cherry timbit which uses the eat callback to override or extend the render method\n"


## Test Case #5 - Chocolate timbit which utilizes custom views
	"test the chocolate timbit which allows us to use alternate views if they exist, this is a test of the 'alternate' view which does exist": (beforeExit) ->
		calls = 0
		assert.response server, 
			url: "/chocolate/alternate?q=coffeescript"
		,
			body: /coffeescript/
			status: 200
		, (res) ->
			"Test Case #5 - Chocolate timbit which utilizes custom views\n"

	
## Test Case #6 - Chocolate timbit requesting a view that can not be found (500 Error)
	"test the choclate timbit using an alternate view that does not exist": (beforeExit) ->
		calls = 0
		assert.response server, 
			url: "/chocolate/badrequest?q=coffeescript"
		,
			body: /Error/
			status: 500
		, (res) ->
			"Test Case #6 - Chocolate timbit requesting a view that can not be found (500 Error)\n"

## Test Case #7 - Dutchie timbit which uses the fetch callback to re-route these calls through the chocolate timbit with views
	"test the dutchie timbit which implements the fetch callback to re-route calls here to the chocolate timbit with views": (beforeExit) ->
		calls = 0
		assert.response server, 
			url: "/dutchie/alternate?q=nodejs"
		,
			body: /Alternate dutchie Timbit View/
			status: 200
		, (res) ->
			"Test Case #7 - Dutchie timbit which uses the fetch callback to re-route these calls through the chocolate timbit with views\n"

## Test Case #8 - Dutchie timbit which has an invalid path that should generate a 404
	"test the dutchie timbit with an invalid path in the request": (beforeExit) ->
		calls = 0
		assert.response server, 
			url: "/dutchie/another/nodejs/alternate"
		,
			status: 404
		, (res) ->
			"Test Case #8 - Dutchie timbit which has an invalid path that should generate a 404\n"
