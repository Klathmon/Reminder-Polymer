Polymer 'due-date',
  date: undefined
  displayText: ''
  hoverText: ''
  dateObject: null
  # updateDisplayInterval: 6000 + Math.floor(Math.random() * 100) # In milliseconds
  ready: ->
    this.dateChanged()
  dateChanged: ->
    this.dateObject = moment(this.date, "YYYY-MM-DDTHH:mm:ss.SSSZ") #RFC3339
    this.updateDisplay()
  updateDisplay: ->
    if typeof this.date != 'undefined'
      this.displayText = "Due " + this.dateObject.fromNow()
      this.hoverText = this.dateObject.format('LLL')
