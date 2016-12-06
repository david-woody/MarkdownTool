MarkdownToolView = require './markdown-tool-view'
{CompositeDisposable} = require 'atom'
configSchema = require "./config-schema"
util=require "./utils"
uploader=require "./upload_image"
module.exports = MarkdownTool =
    markdownToolView: null
    config:configSchema


    activate: (state) ->
        @markdownToolView = new MarkdownToolView()
        # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
        @disposables = new CompositeDisposable()
        @attachEvent()
        @disposables.add atom.commands.add 'atom-text-editor',
            'markdown-tool:insert-current-time': => @formTime()
        @disposables.add atom.commands.add 'atom-text-editor',
            'markdown-tool:insert-image':=>@addPic()


    attachEvent: ->
        workspaceElement = atom.views.getView(atom.workspace)
        workspaceElement.addEventListener 'keydown', (e) =>
            editor = atom.workspace.getActiveTextEditor()
            return unless editor
            return unless @isMarkdown()
            if (e.metaKey && e.keyCode == 86 || e.ctrlKey && e.keyCode == 86)
                if !atom.config.get('markdown-tool.ImageUpload.disableImagePaste')
                    @eventHandler e


    eventHandler: (e) ->
        clipboard = require('clipboard')
        console.log clipboard
        img = clipboard.readImage()
        return if img.isEmpty()
        console.log img

        stream = require('stream');
        bufferStream = new stream.PassThrough();
        bufferStream.end(img.toPng());

        filename = "markdown-tool-paste-#{new Date().toLocaleDateString()}.png"
        console.log filename
        imageUploader=new uploader(filename)
        setTimeout =>
            imageUploader.uploadByStream bufferStream, (err, data)=>
                if err
                    console.log "Error(#{err.code}): #{err.error}"
                else
                    console.log "Success!"+data.url
                    markdownToolView = new MarkdownToolView()
                    markdownToolView.display(data.url)
        ,200


    deactivate: ->
        @modalPanel.destroy()
        @markdownToolView.destroy()

    serialize: ->
        markdownToolViewState: @markdownToolView.serialize()

    isMarkdown: ->
        editor = atom.workspace.getActiveTextEditor()
        return false unless editor?
        grammars = ['source.gfm'
        'source.gfm.nvatom'
        'source.litcoffee'
        'source.asciidoc'
        'text.md'
        'text.plain'
        'text.plain.null-grammar']
        return grammars.indexOf(editor.getGrammar().scopeName) == 4

    isDisalbePaste:->

    getConfig: (config) ->
        atom.config.get "markdown-tool.QiNiu.#{config}"

    formTime: ->
        editor=atom.workspace.getActiveTextEditor()
        editor.insertText(util.formatDate())

    addPic:->
        if(@isMarkdown())
            markdownToolView = new MarkdownToolView()
            markdownToolView.display()
