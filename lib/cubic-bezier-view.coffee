{View} = require 'atom'
$ = require('atom').$
cubicBezier = require './cubic-bezier-curve'
hideWindow = false

module.exports =
class CubicBezierView extends View
  @content: ->
    @div class: 'cubic-bezier overlay from-top', =>
      @div id: "drawing-plane", class: "drawing-plane", =>
        @canvas id: "cubic-bezier", width: '200px', height: '540px'
        @button id: "FP0", class: "curve-pointer fixed"
        @button id: "FP1", class: "curve-pointer fixed"
        @button id: "P0", class: "curve-pointer moveable ui-draggable ui-draggable-handle"
        @button id: "P1", class: "curve-pointer moveable ui-draggable ui-draggable-handle"
        @canvas id: "playBall", height: '60px', width: '60px', class: "curve-pointer moveable"
      @div id: "drawing-button", =>
        @button id: "okButton", style: "width:60px;height: 30px;padding: 10px;margin:10px;", "Save"
        @button id: "cancelButton",  style: "width:60px;height: 30px;padding: 10px;margin:10px;", "Cancel"



  initialize: (serializeState) ->
    atom.workspaceView.command "cubic-bezier:open", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
      @showGraph()
      cubicBezier.showCubicBezier(this)


  showGraph: ->
    #TODO: Take care implementation of ok and cancel button
    $ -> $('#cancelButton').click ->
          @toggle()
          hideWindow = true
