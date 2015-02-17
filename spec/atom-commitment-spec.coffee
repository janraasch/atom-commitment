# needs to be required first for mocking
commitment = require 'javascript-commitment'
original_whatThe = commitment.whatThe
message = 'merge derp'
permalink = 'http://link.com/123'

# dependencies
sinon = require 'sinon'
atomCommitment = require '../lib/commitment'

describe 'atomCommitment', ->
  describe '.consumeStatusBar', ->
    statusBar = {
      addLeftTile: null
    }

    beforeEach ->
      statusBar.addLeftTile = sinon.spy()
      atomCommitment.consumeStatusBar statusBar
    afterEach ->
      statusBar.addLeftTile.reset()
      atomCommitment.deactivate()

    it 'adds left tile to statusBar', ->
      arg = null
      expect(statusBar.addLeftTile.calledOnce).toBe true
      arg = statusBar.addLeftTile.getCall(0).args[0]
      expect(arg.item.classList.contains 'commitment').toBe true
      expect(arg.item.classList.contains 'inline-block').toBe true
      expect(arg.priority).toBe 100

  describe 'when the commitment:toggle event is triggered', ->
    [workspaceElement, statusBar, activationPromise] = [null, null, null]

    beforeEach ->
      commitment.whatThe = -> {message, permalink}
      workspaceElement = atom.views.getView atom.workspace
      activationPromise = atom.packages.activatePackage 'commitment'
      atom.services.consume 'status-bar', '^0.58.0', (_statusBar) ->
        statusBar = _statusBar
      waitsForPromise ->
        atom.packages.activatePackage 'status-bar'
    afterEach ->
      commitment.whatThe = original_whatThe

    it 'shows and hides the status bar tile', ->
      tiles = statusBar.getLeftTiles()
      lengthBefore = tiles.length
      lastTile = tiles[tiles.length - 1]
      expect(lastTile.getItem().classList.contains 'commitment').toBe false

      atom.commands.dispatch workspaceElement, 'commitment:toggle'

      waitsForPromise -> activationPromise

      runs ->
        tiles = statusBar.getLeftTiles()
        lastTile = tiles[tiles.length - 1]
        expect(lengthBefore < tiles.length).toBe true
        lengthBefore = tiles.length

        div = lastTile.getItem()
        expect(div.classList.contains 'commitment').toBe true
        expect(div.classList.contains 'inline-block').toBe true

        span = div.querySelector 'span'
        expect(span.classList.contains 'commitment-message').toBe true
        expect(span.style.display).toBe 'inline-block'


        a = span.querySelector 'a'
        expect(a.getAttribute('href')).toBe "#{permalink}"
        expect(a.getAttribute('name')).toBe "#{message}"
        expect(a.text).toBe "#{message}"

        atom.commands.dispatch workspaceElement, 'commitment:toggle'
        tiles = statusBar.getLeftTiles()
        lastTile = tiles[tiles.length - 1]
        expect(lengthBefore is tiles.length).toBe true
        div = lastTile.getItem()
        span = div.querySelector 'span'
        expect(span.classList.contains 'commitment-message').toBe true
        expect(span.style.display).toBe 'none'

    it 'writes message to clipboard', ->
      expect(atom.clipboard.read()).toBeNull
      atom.commands.dispatch workspaceElement, 'commitment:toggle'

      waitsForPromise -> activationPromise
      runs ->
        expect(atom.clipboard.read()).toBe "#{message}"
        atom.commands.dispatch workspaceElement, 'commitment:toggle'
        expect(atom.clipboard.read()).toBe "#{message}"

    it 'writes message and permalink to console', ->
      logSpy = sinon.spy console, 'log'
      atom.commands.dispatch workspaceElement, 'commitment:toggle'

      waitsForPromise -> activationPromise
      runs ->
        expect(logSpy.calledThrice).toBe true
        expect(logSpy.calledWith('Commitment:')).toBe true
        expect(logSpy.calledWith("#{message}")).toBe true
        expect(logSpy.calledWith("Permalink: #{permalink}")).toBe true
        logSpy.reset()
        atom.commands.dispatch workspaceElement, 'commitment:toggle'
        expect(logSpy.callCount).toBe 0
        logSpy.restore()
