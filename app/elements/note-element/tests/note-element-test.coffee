
document.addEventListener 'polymer-ready', ->
  note1Text = document.getElementById('note1').shadowRoot.getElementById('text')

  chai.expect(note1Text.innerHTML).to.equal('This is a test note!')

  chai.expect(window.getComputedStyle(note1Text).getPropertyValue('font-size')).to
  .be.above('20px')
  .and.be.below('75px')
  
  done()
