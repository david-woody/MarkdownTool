MarkdownToolView = require './markdown-tool-view'
{CompositeDisposable} = require 'atom'
configSchema = require "./config-schema"
util=require "./utils"
module.exports = MarkdownTool =
    markdownToolView: null
    config:configSchema

    activate: (state) ->
        @markdownToolView = new MarkdownToolView()

        # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
        @disposables = new CompositeDisposable()
        @disposables.add atom.commands.add 'atom-text-editor',
            'markdown-tool:insert-current-time': => @formTime()
        @disposables.add atom.commands.add 'atom-text-editor',
            'markdown-tool:insert-image':=>@addPic()
        @attachEvent()

    attachEvent: ->
        workspaceElement = atom.views.getView(atom.workspace)
        workspaceElement.addEventListener 'keydown', (e) =>
            editor = atom.workspace.getActiveTextEditor()
            if atom.config.get('markdown-tool.ImageUpload.disableImagePaste')
                editor?.observeGrammar (grammar) =>
                    console.log grammar.scopeName
                    # return unless grammar
                    # return unless grammar.scopeName is 'source.gfm'
                    @eventHandler e
            else
                @eventHandler e

    eventHandler: (e) ->
        console.log e.keyCode
        if (e.metaKey && e.keyCode == 86 || e.ctrlKey && e.keyCode == 86)
            clipboard = require('clipboard')
            console.log clipboard
            img = clipboard.readImage()
            if (img.isEmpty())
              console.log "This is not picture~~"
            unless (img.isEmpty())
               console.log img
            return if img.isEmpty()

    deactivate: ->
        @modalPanel.destroy()
        @markdownToolView.destroy()

    serialize: ->
        markdownToolViewState: @markdownToolView.serialize()

    isMarkdown: ->
        editor = atom.workspace.getActiveTextEditor()
        return false unless editor?
        console.log editor.getGrammar().scopeName
        return false

    isDisalbePaste:->

    getConfig: (config) ->
        atom.config.get "markdown-tool.QiNiu.#{config}"

    formTime: ->
        editor=atom.workspace.getActiveTextEditor()
        editor.insertText(util.formatDate())

    addPic:->
        markdownToolView = new MarkdownToolView()
        markdownToolView.display()
