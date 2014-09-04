
DIST_DIR = "dist"
DEV_DIR  = "dev"
APP_DIR  = "app"

mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->

  # show elapsed time at the end
  require("time-grunt") grunt

  # load all grunt tasks
  require("load-grunt-tasks") grunt

  grunt.initConfig

    # SASS compilation
    sass:
      options:
        loadPath: [
          "bower_components"
          APP_DIR + "/styles/partials"
          ]
        style: "compressed"

      dev:
        options:
          sourcemap: "file"
        files: [
          expand: true
          cwd: APP_DIR
          src: [
            "styles/**/*.{scss,sass}"
            "elements/**/*.{scss,sass}"
          ]
          dest: DEV_DIR
          ext: ".css"
        ]

      dist:
        options:
          sourcemap: "none"
        files: [
          expand: true
          cwd: APP_DIR
          src: [
            "styles/**/*.{scss,sass}"
            "elements/**/*.{scss,sass}"
          ]
          dest: DIST_DIR
          ext: ".css"
        ]

    # Coffeescript compilation
    coffee:
      options:
        bare: true

      dev:
        options:
          sourceMap: true
        files: [
          expand: true
          cwd: APP_DIR
          src: [
            "scripts/**/*.coffee"
            "elements/**/*.coffee"
          ]
          dest: DEV_DIR
          ext: ".js"
        ]

      dist:
        files: [
          expand: true
          cwd: APP_DIR
          src: [
            "scripts/**/*.coffee"
            "elements/**/*.coffee"
          ]
          dest: DIST_DIR
          ext: ".js"
        ]

    # AutoPrefix CSS
    autoprefixer:
      options:
        browsers: ["last 2 versions"]

      dev:
        options:
          cascade: true
          map: true
        files: [
          expand: true
          cwd: DEV_DIR
          src: "**/*.css"
          dest: DEV_DIR
        ]

      dist:
        options:
          cascade: false
        files: [
          expand: true
          cwd: DIST_DIR
          src: [
            "**/*.css"
            "!bower_components/**/*.css"
          ]
          dest: DIST_DIR
        ]

    # Compress javascript with uglify
    uglify:
      dev:
        options:
          sourceMap: true
          sourceMapIn: (source) ->
            newFile = source + ".map"
            return newFile

        files: [
          expand: true
          cwd: DEV_DIR
          src: "**/*.js"
          dest: DEV_DIR
        ]

    # Clean temp file
    clean:
      dev: DEV_DIR + "**"
      dist: [
        DEV_DIR + "**"
        DIST_DIR + "**"
        ".sass-cache"
      ]

    # Connect web server for development
    connect:
      options:
        port: 9000
        hostname: "0.0.0.0"

      dev:
        options:
          middleware: (connect) ->
            [
              require("connect-livereload")()
              mountFolder(connect, DEV_DIR)
              mountFolder(connect, APP_DIR)
              mountFolder(connect, "")
            ]

    # Watch and livereload files
    watch:
      options:
        nospawn: true
        livereload:
          liveCSS: false

      livereload:
        options:
          livereload: true

        files: [
          "Gruntfile.coffee"
          APP_DIR + "/*.html"
          APP_DIR + "/tests/*.html"
          APP_DIR + "/elements/**/*.html"
          "{" + DEV_DIR + "," + APP_DIR + "}/elements/**/*.{css,sass,scss,js,coffee}"
          "{" + DEV_DIR + "," + APP_DIR + "}/styles/**/*.{css,sass,scss}"
          "{" + DEV_DIR + "," + APP_DIR + "}/scripts/**/*.{js,coffee}"
          APP_DIR + "/images/**/*.{png,jpg,jpeg,gif,webp}"
        ]

      sass:
        files: [
          APP_DIR + "/elements/**/*.{sass,scss}"
          APP_DIR + "/styles/**/*.{sass,scss}"
        ]
        tasks: [
          "sass:dev"
          "autoprefixer:dev"
        ]

      coffee:
        files: [
          APP_DIR + "/elements/**/*.coffee"
          APP_DIR + "/styles/**/*.coffee"
        ]
        tasks: [
          "coffee:dev"
          "uglify:dev"
        ]

    # Run the back-end server
    run:
      reminder_server:
        options:
          wait: false
        cmd: 'Reminder.exe'

    # Open the necessary browsers to the right pages
    open:
      serveChrome:
        path: "http://localhost:<%= connect.options.port %>"
        app: 'Chrome'
      serveFirefox:
        path: "http://localhost:<%= connect.options.port %>"
        app: 'Firefox'
      serveIE:
        path: "http://localhost:<%= connect.options.port %>"
        app: 'IExplore'

      testChrome:
        path: "http://localhost:<%= connect.options.port %>/tests/runner.html"
        app: 'Chrome'
      testFirefox:
        path: "http://localhost:<%= connect.options.port %>/tests/runner.html"
        app: 'Firefox'
      testIE:
        path: "http://localhost:<%= connect.options.port %>/tests/runner.html"
        app: 'IExplore'

    # Mocha-slimerjs test runner
    mocha_slimer:
      options:
        run: true
        urls: [
          "http://localhost:<%= connect.options.port %>/tests/runner.html"
        ]
      normal:
        run: true

      travis:
        options:
          xvfb: true

  grunt.registerTask "cleanWorkspace", (target) ->
    grunt.task.run [
      "clean:dist"
    ]

  grunt.registerTask "buildDev", (target) ->
    grunt.task.run [
      "clean:dev"
      "sass:dev"
      "autoprefixer:dev"
      "coffee:dev"
      "uglify:dev"
      "run:reminder_server"
      "connect:dev"
    ]

  grunt.registerTask "serveLaunchApp", (target) ->
    grunt.task.run [
      "buildDev"
      "open:serveChrome"
      "open:serveFirefox"
      "open:serveIE"
      "watch"
    ]

  grunt.registerTask "serveLaunchTest", (target) ->
    grunt.task.run [
      "buildDev"
      "open:testChrome"
      "open:testFirefox"
      "open:testIE"
      "watch"
    ]

  grunt.registerTask "serve", (target) ->
    grunt.task.run [
      "buildDev"
      "watch"
    ]

  grunt.registerTask "test", (target) ->
    grunt.task.run [
      "clean:dev"
      "sass:dev"
      "autoprefixer:dev"
      "coffee:dev"
      "uglify:dev"
      "run:reminder_server"
      "connect:dev"
      "mocha_slimer:normal"
    ]
