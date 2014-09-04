Polymer 'note-list',
  #ready: ->
  #  ajax = this.shadowRoot.querySelector("core-ajax")
  showNotes: (event)->
      this.shadowRoot.querySelector("#notetemp").model = {notes: event.detail.response}
      this.shadowRoot.querySelector("core-animated-pages").selected = 1
  notesAreVisible: (oldValue, newValue) ->
    [].forEach.call(this.shadowRoot.querySelectorAll("note-element"), setNoteVisible)

setNoteVisible = (element) ->
  element.isVisible = true
