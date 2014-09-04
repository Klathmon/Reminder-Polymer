Polymer 'note-element',
  ready: ->
    dueDateObject = moment(this.dueDate, "YYYY-MM-DDTHH:mm:ss.SSSZ") #RFC3339
    this.dueFromNow = dueDateObject.fromNow()
    this.dueDateParsed = dueDateObject.format('LLL')
  isVisible: false
  isVisibleChanged: (oldValue, newValue) ->
    if newValue
      autoSizeText(this.shadowRoot.getElementById("text"))

autoSizeText = (textDiv) ->
  textDiv.style.overflow = "auto"
  fontSize = 5
  textDiv.style.fontSize = fontSize + "em"
  while textDiv.scrollWidth > textDiv.clientWidth || textDiv.scrollHeight > textDiv.clientHeight
    fontSize -= .5
    textDiv.style.fontSize = fontSize + "em"
    # console.log textDiv.scrollHeight + " " + textDiv.clientHeight
    break if fontSize <= 1
