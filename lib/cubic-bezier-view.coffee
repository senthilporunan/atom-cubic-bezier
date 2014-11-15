{View} = require 'atom'
$ = require('atom').$
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
        @select id: "easingList", style: "width: 214px; height: 25px;", =>
          @option value: "default", selected: true, "default"
          @option value: "linear", "linear"
          @option value: "ease", "ease"
          @option value: "easeIn", "easeIn"
          @option value: "easeInOut", "easeInOut"
          @option value: "easeOut", "easeOut"
      @div id: "drawing-button", =>
        @button id: "okButton", style: "width:60px;height: 30px;padding: 10px;margin:10px;", "Save"
        @button id: "cancelButton", style: "width:60px;height: 30px;padding: 10px;margin:10px;", "Close"



  initialize: (serializeState) ->
    @cubicBezier = new CubicBezierCurve()
    atom.workspaceView.command "cubic-bezier:open", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    editor = atom.workspace.getActiveEditor()
    pos = editor.getCursorBufferPosition()
    console.log("Row: "+pos.row)
    atom.workspaceView.append(this)
    @cubicBezier = new CubicBezierCurve() unless @cubicBezier
    console.log @cubicBezier
    @cubicBezier.showCubicBezier()
