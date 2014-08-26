Polymer 'note-list',
  #ready: ->
  #  ajax = this.shadowRoot.querySelector("core-ajax")
  showNotes: (event)->
      this.shadowRoot.querySelector("#notetemp").model = {notes: event.detail.response}
      this.shadowRoot.querySelector("core-animated-pages").selected = 1
  notesAreVisible: (oldValue, newValue) ->
    noteElements = this.shadowRoot.querySelectorAll("note-element")
    setNoteVisible element for element in noteElements

setNoteVisible = (element) ->
  element.isVisible = true
