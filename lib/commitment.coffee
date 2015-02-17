AtomCommitmentView = require './commitment-view'
commitment = require 'javascript-commitment'
React = require 'react-atom-fork'

view = null
mountPoint = null
statusBarTile = null

printToConsole = (message, permalink) ->
  console.log 'Commitment:'
  console.log message
  console.log "Permalink: #{permalink}"

copyToClipboard = (message) ->
  atom.clipboard.write message

getMountPoint = ->
  unless mountPoint?
    mountPoint = document.createElement 'div'
    mountPoint.classList.add 'commitment', 'inline-block'
  mountPoint

consumeStatusBar = (statusBar) ->
  statusBarTile = statusBar.addLeftTile item: getMountPoint(), priority: 100

getView = ->
  view ||= React.renderComponent new AtomCommitmentView(), getMountPoint()

activate = ->
  atom.commands.add 'atom-workspace', 'commitment:toggle': toggle
  getView()

toggle = ->
  if getView().isVisible()
    getView().hide()
  else
    {message, permalink} = commitment.whatThe()
    getView().show message, permalink
    printToConsole message, permalink
    copyToClipboard message

deactivate = ->
  statusBarTile?.destroy()
  statusBarTile = null
  view = null
  mountPoint = null

module.exports = {activate, deactivate, toggle, consumeStatusBar}
