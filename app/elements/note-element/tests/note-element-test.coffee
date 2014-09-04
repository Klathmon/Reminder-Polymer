
document.addEventListener 'polymer-ready', ->
  myElement = document.querySelector('note-element')

  elementText = myElement.shadowRoot.getElementById('text')

  chai.expect(elementText.innerHTML).to.equal('This is a test note!')

  chai.expect(window.getComputedStyle(elementText).getPropertyValue('font-size')).to.be.above('20px')
  done()
