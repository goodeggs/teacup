'use strict'

{ spawn, fork, exec } = require 'child_process'
path = require 'path'
fs = require 'fs'

gaze = require 'gaze'

# Helpers

run = (command, callback) ->
  exec command, (error, stdout, stderr) ->
    process.stdout.write(stdout) if stdout
    process.stderr.write(stderr) if stderr
    callback(error, stdout, stderr) if callback

# Watchers

class Watchers
  constructor: ->
    self = @
    gaze 'package.json', ->
      @on 'changed', -> spawn('npm', ['install'], stdio: 'inherit')
        .on 'exit', -> console.log 'npm packages updated'
    gaze 'src/**/*.coffee', ->
      @on 'all', (event, filePath) ->
        self.compile(filePath)

    @compile = (filePath) ->
      filePath = filePath.replace("#{__dirname}/", '')
      destDirPath = path.dirname(filePath).replace /^src/, 'lib'
      run "./node_modules/.bin/coffee -mco #{destDirPath} #{filePath}", (error) ->
        console.log "#{filePath} -> #{destDirPath}" if not error
        run "./node_modules/.bin/uglifyjs -m -c -o lib/teacup.min.js lib/teacup.js"

  exit: ->

# Tasks

task 'dev', 'development', ->
  if not process.send # parent
    runningDev = null
    runDev = ->
      console.log 'Start a new dev'
      dev = spawn 'cake', ['dev'], stdio: [0, 1, 2, 'ipc']
      dev.on 'message', (msg) ->
        if msg is 'ready'
          if runningDev
            console.log 'Kill the old dev'
            runningDev.send 'die'
          runningDev = dev
    runDev()
    gaze 'Cakefile', ->
      @on 'added', -> runDev()
      @on 'changed', -> runDev()
  else # child
    watchers = new Watchers
    # IPC
    process.on 'exit', -> watchers.exit()
    process.on 'message', (msg) -> process.exit() if msg is 'die'
    process.send 'ready'
