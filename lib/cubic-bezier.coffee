CubicBezierView = require './cubic-bezier-view'

module.exports =
  cubicBezierView: null

  activate: (state) ->
    @cubicBezierView = new CubicBezierView(state.cubicBezierViewState)

  deactivate: ->
    @cubicBezierView.destroy()

  serialize: ->
    cubicBezierViewState: @cubicBezierView.serialize()
