
CubicBezierView = require '../lib/cubic-bezier-view'
CubicBezierCurve = require '../lib/cubic-bezier-curve'
{WorkspaceView} = require 'atom'
$ = require("jquery")

describe "CubicBezierView", ->

  [editorView, cubicView, activationPromise, workspaceElement] = []
  beforeEach ->
      runs ->
        atom.workspaceView = new WorkspaceView()

      waitsForPromise -> atom.workspaceView.open('sample.js')

      runs ->
        atom.workspaceView.attachToDom()
        editorView = atom.workspaceView.getActiveView()
        editorView.setText("cubic-bezier(0.7, 0.4, 0.4, 1)")

      activationPromise = atom.packages.activatePackage("cubic-bezier").then ({mainModule}) ->
        mainModule.createViews()
        {cubicView} = mainModule

  describe 'check the window open', ->
    it 'should have open the view', ->
      editorView.trigger 'cubic-bezier:open'

      runs ->
        expect(atom.workspaceView.find('.cubic-bezier').length).toEqual(1)

  describe 'check the window close', ->
    it 'should have open the view', ->
      $('#cancelButton').click()

      runs ->
        expect(atom.workspaceView.find('.cubic-bezier').length).toEqual(0)
