Builder = require 'component-builder'
path    = require 'path'
flatten = require('underscore').flatten
union   = require('underscore').union

module.exports = (env, cb) ->

  defaults =
    dev: env.mode == 'preview'
    sourceUrls: env.mode == 'preview'
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

    # configure builder
    builder.copyAssetsTo env.config.output
    builder.copy = true
    builder.dev = options.dev
    builder.sourceUrls = options.sourceUrls
    builder.urlPrefix = env.config.baseUrl
    # TODO builder plugins (.use()) and lookups (.addLookup)

    builder.build (err, res) ->

      if err?
        return cb err        

      app = {}
      app[options.js]  = new ComponentOutput 'js', res.require + res.js
      app[options.css] = new ComponentOutput 'css', res.css

      # register asset files
      files = union flatten(res.files), flatten(res.images), flatten(res.fonts)
      for file in files
        relative = path.relative env.config.output, file
        full = path.join env.workDir, file
        app[relative] = new env.plugins.StaticFile({relative:relative,full:full})

      cb err, app

  cb()
