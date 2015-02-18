React = require 'react-atom-fork'
CommitmentView = require '../lib/commitment-view'

describe 'commitment-view', ->
  [mount_point, sut_html, sut, element] = [null, null, null, null]

  beforeEach ->
    mount_point = document.createElement 'div'
    element = new CommitmentView()
    sut = React.renderComponent element, mount_point

  describe 'initial state', ->
    it 'is not visible', ->
      expect(sut.isVisible()).toBe false

    it 'has no message or link', ->
      sut_html = sut.getDOMNode().innerHTML
      expect(sut_html).toMatch /href=\"\"/
      expect(sut_html).toMatch /name=\"\"/
      expect(sut_html).toMatch /><\/a>/

  it '::show', ->
    sut.show 'massage', 'http://link'
    sut_html = sut.getDOMNode().innerHTML
    expect(sut.isVisible()).toBe true
    expect(sut_html).toMatch /href=\"http\:\/\/link\"/
    expect(sut_html).toMatch /name=\"massage\"/
    expect(sut_html).toMatch />massage<\/a>/

  it '::hide', ->
    sut.hide()
    expect(sut.isVisible()).toBe false
