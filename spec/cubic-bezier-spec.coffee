{WorkspaceView} = require 'atom'
CubicBezier = require '../lib/cubic-bezier'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "CubicBezier", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('cubic-bezier')

  describe "when the cubic-bezier:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.cubic-bezier')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'cubic-bezier:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.cubic-bezier')).toExist()
        atom.workspaceView.trigger 'cubic-bezier:toggle'
        expect(atom.workspaceView.find('.cubic-bezier')).not.toExist()
