MarkdownToolView = require './markdown-tool-view'
{CompositeDisposable} = require 'atom'

module.exports = MarkdownTool =
  markdownToolView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @markdownToolView = new MarkdownToolView(state.markdownToolViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @markdownToolView.getElement(), visible: false)
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @disposables = new CompositeDisposable()
    @registerEditorCommands()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @markdownToolView.destroy()

  serialize: ->
    markdownToolViewState: @markdownToolView.serialize()

  registerEditorCommands: ->
    # Register command that toggles this view
    @disposables.add(atom.commands.add 'atom-text-editor','markdown-tool:insert-current-time': (event) ->
      editor = @getModel()
      editor.insertText(new Date().toLocaleString()))
