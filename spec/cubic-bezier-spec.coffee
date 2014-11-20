{WorkspaceView} = require 'atom'
CubicBezierCurve = require '../lib/cubic-bezier-curve'
$ = require("jquery")

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "CubicBezierCurve", ->

  [editorView, cubicView, activationPromise, workspaceElement] = []
  beforeEach ->
      runs ->
        atom.workspaceView = new WorkspaceView()

      waitsForPromise -> atom.workspaceView.open('sample.js')

      runs ->
        atom.workspaceView.attachToDom()
        editorView = atom.workspaceView.getActiveView()
        editorView.setText("cubic-bezier(0.5, 0.7, 0.25, 0.1)")
        editorView.editor.setCursorScreenPosition([3,0])

      activationPromise = atom.packages.activatePackage("cubic-bezier").then ({mainModule}) ->
        mainModule.createViews()
        {cubicView} = mainModule

  describe 'Call Window open', ->
    it 'open the window view', ->
      editorView.trigger 'cubic-bezier:open'

      runs ->
        expect(atom.workspaceView.find('.cubic-bezier').length).toEqual(1)
        expect($("#easingList").val() is "custom")
