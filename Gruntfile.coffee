
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
          APP_DIR + "/elements/{,*/}*.html"
          "{" + DEV_DIR + "," + APP_DIR + "}/elements/{,*/}*.{css,sass,scss,js,coffee}"
          "{" + DEV_DIR + "," + APP_DIR + "}/styles/{,*/}*.{css,sass,scss}"
          "{" + DEV_DIR + "," + APP_DIR + "}/scripts/{,*/}*.{js,coffee}"
          APP_DIR + "/images/{,*/}*.{png,jpg,jpeg,gif,webp}"
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

      compass:
        files: [
          APP_DIR + "/elements/**/*.compass"
          APP_DIR + "/styles/**/*.compass"
        ]
        tasks: [
          "compass:dev"
        ]

    # Run the back-end server
    run:
      reminder_server:
        options:
          wait: false
        cmd: 'Reminder.exe'


  grunt.registerTask "serve", (target) ->
    grunt.task.run [
      "clean:dev"
      "sass:dev"
      "autoprefixer:dev"
      "coffee:dev"
      "uglify:dev"
      "run:reminder_server"
      "connect:dev"
      "watch"
    ]
