"use strict"
LIVERELOAD_PORT = 35729
lrSnippet = require("connect-livereload")(port: LIVERELOAD_PORT)
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)


# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->

  # show elapsed time at the end
  require("time-grunt") grunt

  # load all grunt tasks
  require("load-grunt-tasks") grunt

  grunt.initConfig
    watch:
      options:
        nospawn: true
        livereload:
          liveCSS: false

      livereload:
        options:
          livereload: true

        files: [
          "app/*.html"
          "app/elements/{,*/}*.html"
          "{.tmp,app}/elements/{,*/}*.css"
          "{.tmp,app}/styles/{,*/}*.css"
          "{.tmp,app}/scripts/{,*/}*.js"
          "app/images/{,*/}*.{png,jpg,jpeg,gif,webp}"
        ]

      js:
        files: ["app/scripts/{,*/}*.js"]
        tasks: ["jshint"]

      styles:
        files: [
          "app/styles/{,*/}*.css"
          "app/elements/{,*/}*.css"
        ]
        tasks: [
          "copy:styles"
          "autoprefixer:server"
        ]

      sass:
        files: [
          "app/styles/{,*/}*.{scss,sass}"
          "app/elements/{,*/}*.{scss,sass}"
        ]
        tasks: [
          "sass:server"
          "autoprefixer:server"
        ]

      coffee:
        files: [
          "app/scripts/{,*/}*.coffee"
          "app/elements/{,*/}*.coffee"
        ]
        tasks: ["coffee:server"]


    # Compiles Sass to CSS and generates necessary files if requested
    sass:
      options:
        sourcemap: "none"
        loadPath: "bower_components"

      dist:
        options:
          style: "compressed"

        files: [
          expand: true
          cwd: "app"
          src: [
            "styles/{,*/}*.{scss,sass}"
            "elements/{,*/}*.{scss,sass}"
          ]
          dest: "dist"
          ext: ".css"
        ]

      server:
        files: [
          expand: true
          cwd: "app"
          src: [
            "styles/{,*/}*.{scss,sass}"
            "elements/{,*/}*.{scss,sass}"
          ]
          dest: ".tmp"
          ext: ".css"
        ]


    # Compiles Coffeescript to Javascript and generates necessary files if requested
    coffee:
      options:
        sourceMap: false
        bare: true

      dist:
        files: [
          expand: true
          cwd: "app"
          src: [
            "scripts/{,*/}*.coffee"
            "elements/{,*/}*.coffee"
          ]
          dest: "dist"
          ext: ".js"
        ]

      server:
        files: [
          expand: true
          cwd: "app"
          src: [
            "scripts/{,*/}*.coffee"
            "elements/{,*/}*.coffee"
          ]
          dest: ".tmp"
          ext: ".js"
        ]

    autoprefixer:
      options:
        browsers: ["last 2 versions"]

      server:
        files: [
          expand: true
          cwd: ".tmp"
          src: "**/*.css"
          dest: ".tmp"
        ]

      dist:
        files: [
          expand: true
          cwd: "dist"
          src: [
            "**/*.css"
            "!bower_components/**/*.css"
          ]
          dest: "dist"
        ]

    connect:
      options:
        port: 9000

        # change this to '0.0.0.0' to access the server from outside
        hostname: "0.0.0.0"

      livereload:
        options:
          middleware: (connect) ->
            [
              lrSnippet
              mountFolder(connect, ".tmp")
              mountFolder(connect, "app")
            ]

      test:
        options:
          middleware: (connect) ->
            [
              mountFolder(connect, ".tmp")
              mountFolder(connect, "test")
              mountFolder(connect, "app")
            ]

      dist:
        options:
          middleware: (connect) ->
            [mountFolder(connect, "app")]

    open:
      server:
        path: "http://localhost:<%= connect.options.port %>"

    clean:
      dist: [
        ".tmp"
        "dist/*"
        ".sass-cache"
      ]
      server: ".tmp"

    jshint:
      options:
        jshintrc: ".jshintrc"
        reporter: require("jshint-stylish")

      all: [
        "app/scripts/{,*/}*.js"
        "!app/scripts/vendor/*"
        "test/spec/{,*/}*.js"
      ]

    mocha:
      all:
        options:
          run: true
          urls: ["http://localhost:<%= connect.options.port %>/index.html"]

    useminPrepare:
      html: "app/index.html"
      options:
        dest: "dist"

    usemin:
      html: ["dist/{,*/}*.html"]
      css: ["dist/styles/{,*/}*.css"]
      options:
        dirs: ["dist"]
        blockReplacements:
          vulcanized: (block) ->
            "<link rel=\"import\" href=\"" + block.dest + "\">"

    vulcanize:
      default:
        options:
          strip: true

        files:
          "dist/elements/elements.vulcanized.html": ["dist/elements/**/*.html"]

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "app/images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "dist/images"
        ]

    minifyHtml:
      options:
        quotes: true
        empty: true

      app:
        files: [
          expand: true
          cwd: "dist"
          src: "*.html"
          dest: "dist"
        ]

    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: "app"
          dest: "dist"
          src: [
            "*.{ico,txt}"
            ".htaccess"
            "*.html"
            "elements/**"
            "images/{,*/}*.{webp,gif}"
            "bower_components/**"
          ]
        ]

      styles:
        files: [
          expand: true
          cwd: "app"
          dest: ".tmp"
          src: ["{styles,elements}/{,*/}*.css"]
        ]

  grunt.registerTask "server", (target) ->
    grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
    grunt.task.run ["serve:" + target]
    return

  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "open"
        "connect:dist:keepalive"
      ])
    grunt.task.run [
      "clean:server"
      "sass:server"
      "coffee:server"
      "copy:styles"
      "autoprefixer:server"
      "connect:livereload"
      "open"
      "watch"
    ]
    return

  grunt.registerTask "test", [
    "clean:server"
    "connect:test"
    "mocha"
  ]
  grunt.registerTask "build", [
    "clean:dist"
    "sass"
    "coffee"
    "copy"
    "useminPrepare"
    "imagemin"
    "concat"
    "autoprefixer"
    "uglify"
    "vulcanize"
    "usemin"
    "minifyHtml"
  ]
  grunt.registerTask "default", [
    "jshint"

    # 'test'
    "build"
  ]
  return
