Polymer 'note-element',
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
    break if fontSize <= 1
