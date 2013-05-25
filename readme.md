# wintersmith-component

[Component][1] plugin for [wintersmith][2].

Still in a development stage (0.0.5), PRs welcome!


## Install

Using `wintersmith`:

```
$ wintersmith plugin install component
```

Using `npm`:

```
$ npm install wintersmith-component
```

## Usage

TODO docs. For now, see the example directory.

## Options

Specify options under the `component` key of your config.

```coffeescript
defaults =
  dev: env.mode == 'preview'        # include development dependencies
  sourceUrls: env.mode == 'preview' # add @sourceURLs for easy debugging
  src: '.'                          # location of base component.json
  js: 'build/build.js'              # path to JS output
  css: 'build/build.css'            # path to CSS output
  use: []                           # array of builder.js plugins†
```

† [list of component builder plugins][3]

[1]:https://github.com/component/component
[2]:https://github.com/jnordberg/wintersmith
[3]:https://github.com/component/component/wiki/Plugins
