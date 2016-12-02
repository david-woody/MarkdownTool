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
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'markdown-tool:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @markdownToolView.destroy()

  serialize: ->
    markdownToolViewState: @markdownToolView.serialize()

  toggle: ->
    console.log 'MarkdownTool was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
