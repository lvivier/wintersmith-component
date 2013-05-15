Builder = require 'component-builder'
flatten = require('underscore').flatten
union   = require('underscore').union
path    = require('path')

module.exports = (env, cb) ->

  defaults =
    development: true
    sourceUrls:  true
    src: '.' # location of base component.json
    js:  'build/build.js'
    css: 'build/build.css'

  options = env.config.component or {}
  for key, value of defaults
    options[key] ?= defaults[key]

  # script output class
  class ComponentOutput extends env.plugins.Page
    constructor: (@type, @content) ->

    getFilename: ->
      options[@type]

    getView: -> (env, locals, contents, templates, callback) ->
      callback null, new Buffer @content

  env.registerGenerator 'component', (contents, cb) ->

    builder = new Builder options.src
    builder.copyAssetsTo env.config.output

    if options.development?
      builder.development()
    if options.sourceUrls?
      builder.addSourceURLs()
    # TODO builder plugins (.use()) and lookups (.addLookup)

    builder.build (err, res) ->

      if err?
        return cb err        

      app = {}
      app['build/build.js']  = new ComponentOutput 'js', res.require + res.js
      app['build/build.css'] = new ComponentOutput 'css', res.css

      # register asset files with preview server
      if env.mode == 'preview'
        files = union flatten(res.files), flatten(res.images), flatten(res.fonts)
        for file in files
          relative = path.relative env.config.output, file
          full = path.join env.workDir, file
          app[relative] = new env.plugins.StaticFile({relative:relative,full:full})

      cb err, app

  cb()
