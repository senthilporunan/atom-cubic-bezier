{View} = require 'atom-space-pen-views'
$ = require('atom-space-pen-views').$
CubicBezierCurve = require './cubic-bezier-curve'
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
        @button id: "playBall", class: "curve-pointer moveable"
        @select id: "easingList", style: "width: 214px; height: 31px;", =>
          @option value: "custom", selected: true, "custom"
          @option value: "linear", "linear"
          @option value: "ease", "ease"
          @option value: "ease-in", "ease-in"
          @option value: "ease-in-out", "ease-in-out"
          @option value: "ease-out", "ease-out"
      @div id: "drawing-button", =>
        @button id: "okButton", style: "width:107px;height: 30px;margin: 5px 4px 0 0px;", "Apply"
        @button id: "cancelButton", style: "width:107px;height: 30px;margin-top:5px;", "Close"



  initialize: (serializeState) ->
    atom.commands.add 'atom-workspace',
      "cubic-bezier:open", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspace.addModalPanel({item:this})
      @cubicBezier = new CubicBezierCurve() unless @cubicBezier
      @cubicBezier.showCubicBezier(this)
