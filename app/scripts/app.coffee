((document) ->
  "use strict"
  document.addEventListener "polymer-ready", ->

    # Perform some behaviour
    console.log "Polymer is ready to rock!"

    return

  return

# wrap document so it plays nice with other libraries
# http://www.polymer-project.org/platform/shadow-dom.html#wrappers
) wrap(document)
