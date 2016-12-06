{CompositeDisposable} = require 'atom'
{$, View, TextEditorView} = require "atom-space-pen-views"
remote = require "remote"
dialog = remote.dialog || remote.require "dialog"
fromPasteUrl = null # remember last inserted image directory
utils= require "./utils"
uploader=require "./upload_image"
# uploader = require('./upload_image');
# fs = require "fs-plus"
module.exports =
class MarkdownToolView extends View
    @content: ->
        @div class: "markdown-tool markdown-tool-dialog", =>
            @label "Insert Image", class: "icon icon-device-camera"
            @div =>
                @label "Image Path (src)", class: "message"
                @subview "imageEditor", new TextEditorView(mini: true)
                @div class: "dialog-row", =>
                    @button "Choose Local Image", outlet: "openImageButton", class: "btn"
                    @label outlet: "message", class: "side-label"
                @label "UploadName", class: "message"
                @subview "uploadNameEditor", new TextEditorView(mini: true)
                @div class: "dialog-row", =>
                    @button "Upload", outlet: "uploadButton", class: "btn"
                    @label outlet: "uploadMessage", class: "side-label"
                @label "Title (alt)", class: "message"
                @subview "titleEditor", new TextEditorView(mini: true)
                @div class: "col-1", =>
                    @label "Width (px)", class: "message"
                    @subview "widthEditor", new TextEditorView(mini: true)
                @div class: "col-1", =>
                    @label "Height (px)", class: "message"
                    @subview "heightEditor", new TextEditorView(mini: true)
                @div class: "col-2", =>
                    @label "Alignment", class: "message"
                    @subview "alignEditor", new TextEditorView(mini: true)
            @div class: "image-container", =>
                @img outlet: 'imagePreview'


    initialize:->
        utils.setTabIndex([@imageEditor, @openImageButton, @titleEditor,
            @widthEditor, @heightEditor, @alignEditor])
        @openImageButton.on "click", => @openImageDialog()
        @uploadButton.on "click",=>@uploadImage()
        @imageEditor.on "blur", =>
            file = @imageEditor.getText().trim()
            @updateImageSource(file)
            # @updateCopyImageDest(file)
        @disposables = new CompositeDisposable()
        @disposables.add(atom.commands.add(
            @element, {
                "core:confirm": => @onConfirm(),
                "core:cancel": => @detach()
            }))

    onConfirm: ->
        # return unless @imgSrc
        @insertImage();
        @detach()

    insertImage: ->
      title = @titleEditor.getText().trim()
      text = "![#{title}](http://#{@imgSrc})"
      @editor.insertText(text)


    display:(pasteUrl) ->
        fromPasteUrl=pasteUrl
        @panel ?= atom.workspace.addModalPanel(item: this, visible: false)
        @previouslyFocusedElement = $(document.activeElement)
        @editor = atom.workspace.getActiveTextEditor()
        @panel.show()
        @imageEditor.focus()


    detach: ->
        if @panel.isVisible()
            @panel.hide()
            @previouslyFocusedElement?.focus()
        super

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    # Tear down any state and detach
    destroy: ->
        @element.remove()

    getElement: ->
        @element

    openImageDialog: ->
        files = dialog.showOpenDialog
            properties: ['openFile']
            defaultPath: lastInsertImageDir
        return unless files && files.length > 0
        @showUploadMessage("")
        @imageEditor.setText(files[0])
        @uploadNameEditor.setText(utils.getFileName(files[0]))
        @updateImageSource(files[0])
        #
        # lastInsertImageDir = path.dirname(files[0]) unless utils.isUrl(files[0])
        @titleEditor.focus()

    updateImageSource: (file) ->
        return unless file
        @displayImagePreview(file)

    displayImagePreview: (file) ->
        return if @imageOnPreview == file

        if utils.isImageFile(file)
            @message.text("Opening Image Preview ...")
            console.log "resolve="+@resolveImagePath(file)
            @imagePreview.attr("src", @resolveImagePath(file))
            @imagePreview.load =>
                @message.text("")
                @setImageContext()
            @imagePreview.error =>
                @message.text("Error: Failed to Load Image.")
                @imagePreview.attr("src", "")
        else
            @message.text("Error: Invalid Image File.") if file
            @imagePreview.attr("src", "")
            @widthEditor.setText("")
            @heightEditor.setText("")
            @alignEditor.setText("")
        @imageOnPreview = file # cache preview image src
        # try to resolve file to a valid src that could be displayed

    resolveImagePath: (file) ->
        console.log file
        return "" unless file
        return file if utils.isUrl(file) || file

    setImageContext: ->
        { naturalWidth, naturalHeight } = @imagePreview.context
        @widthEditor.setText("" + naturalWidth)
        @heightEditor.setText("" + naturalHeight)

        position = if naturalWidth > 300 then "center" else "right"
        @alignEditor.setText(position)

    uploadImage:->
        return unless @uploadNameEditor.getText()
        if(!fromPasteUrl){
          @showUploadMessage("This has uploaded!")
        }
        imageUploader=new uploader(@uploadNameEditor.getText())

        setTimeout =>
            imageUploader.upload @imageEditor.getText(), (err, data)=>
                if err
                    console.log err
                    @showUploadMessage("Error(#{err.code}): #{err.error}")
                else
                    @showUploadMessage("Success!")
                    @imgSrc = data.url
                    @titleEditor.focus()
        ,200

      showUploadMessage: (msg) ->
        @uploadMessage.text(msg)
