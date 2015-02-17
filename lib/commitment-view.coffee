React = require 'react-atom-fork'
{span, a} = require 'reactionary-atom-fork'

AtomCommitmentComponent = React.createClass
  getInitialState: ->
    message: '', permalink: '', visible: false

  render: ->
    display = if @state.visible then 'inline-block' else 'none'
    span {className: 'commitment-message', style: {display: display}},
      a {href: @state.permalink, name: @state.message}, @state.message

  isVisible: -> @state.visible is on

  show: (message, permalink) ->
    @setState visible: true, message: message, permalink: permalink

  hide: -> @setState visible: false

module.exports = AtomCommitmentComponent
