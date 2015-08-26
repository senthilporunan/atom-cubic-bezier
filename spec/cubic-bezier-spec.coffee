{View} = require 'atom-space-pen-views'
CubicBezierCurve = require '../lib/cubic-bezier-curve'
$ = require("jquery")

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "CubicBezierCurve", ->

  [editorView, activationPromise, workspaceElement] = []
  beforeEach ->
      waitsForPromise -> atom.workspace.open('sample.js')

      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorView = atom.views.getView(editor)
        jasmine.attachToDOM(editorView)
        editor.getBuffer().setText("cubic-bezier(0.5, 0.7, 0.25, 0.1)")
        editor.setCursorScreenPosition([3,0])

      activationPromise = atom.packages.activatePackage("cubic-bezier")

      activationPromise.fail (reason) ->
        console.error('activation failed ',reason)

  describe 'Call Window open', ->
    it 'open the window view', ->
      atom.commands.dispatch editorView, 'cubic-bezier:open'

      waitsForPromise ->
         activationPromise

      runs ->
        expect($(editorView).find('.cubic-bezier').length).toEqual(1)
        expect($("#easingList").val() is "custom")
