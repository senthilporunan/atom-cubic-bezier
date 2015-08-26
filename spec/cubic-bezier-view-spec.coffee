
CubicBezierView = require '../lib/cubic-bezier-view'
CubicBezierCurve = require '../lib/cubic-bezier-curve'
{View} = require 'atom-space-pen-views'
$ = require("jquery")

describe "CubicBezierView", ->

  [editorView, cubicView, activationPromise] = []
  beforeEach ->
      waitsForPromise -> atom.workspace.open('sample.js')
      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorView = atom.views.getView(editor)
        jasmine.attachToDOM(editorView)
        editor.getBuffer().setText("cubic-bezier(0.7, 0.4, 0.4, 1)")

      activationPromise = atom.packages.activatePackage("cubic-bezier").then ({mainModule}) ->
        mainModule.createViews()
        {cubicView} = mainModule

  describe 'check the window open', ->
    it 'should have open the view', ->
      atom.commands.dispatch editorView, 'cubic-bezier:open'
      waitsForPromise ->
         activationPromise

      runs ->
        expect($(editorView).find('.cubic-bezier').length).toEqual(1)

  describe 'check the window close', ->
    it 'should have open the view', ->
      $('#cancelButton').click()

      runs ->
        expect($(editorView).find('.cubic-bezier').length).toEqual(0)
