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
        @disposables.add atom.commands.add 'atom-text-editor',
            'markdown-tool:insert-current-time': => @formTime()

    deactivate: ->
        @modalPanel.destroy()
        @subscriptions.dispose()
        @markdownToolView.destroy()

    serialize: ->
        markdownToolViewState: @markdownToolView.serialize()


    formatDate : ->
        time=new Date()
        format="yyyy-MM-dd HH:mm:ss"
        dict = {
        "yyyy": time.getFullYear(),
        "M": time.getMonth() + 1,
        "d": time.getDate(),
        "H": time.getHours(),
        "m": time.getMinutes(),
        "s": time.getSeconds(),
        "MM": ("" + (time.getMonth() + 101)).substr(1),
        "dd": ("" + (time.getDate() + 100)).substr(1),
        "HH": ("" + (time.getHours() + 100)).substr(1),
        "mm": ("" + (time.getMinutes() + 100)).substr(1),
        "ss": ("" + (time.getSeconds() + 100)).substr(1)
        };
        return format.replace /(yyyy|MM?|dd?|HH?|ss?|mm?)/g,
  	         (key)=>
    	          return dict[key];

    formTime: ->
        # time=new Date().toLocaleString()
        # if @modalPanel.isVisible()
        #   @modalPanel.hide()
        # else
        #   editor = atom.workspace.getActiveTextEditor()
        #   words = editor.getText().split(/\s+/).length
        #   @markdownToolView.setCount(time)
        #   @modalPanel.show()
        editor=atom.workspace.getActiveTextEditor()
        editor.insertText(@formatDate())
