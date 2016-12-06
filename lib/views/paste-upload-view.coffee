{CompositeDisposable} = require 'atom'
{$, View, TextEditorView} = require "atom-space-pen-views"
remote = require "remote"
dialog = remote.dialog || remote.require "dialog"
utils= require "../utils"
module.exports=
  class PasteUploadView extends View
      @content: ->
          @div class: "markdown-tool markdown-tool-dialog", =>
              @label "Insert Image", class: "icon icon-device-camera"
              @div =>
                @label "Image Url(QiNiu)", class: "message"
                @subview "imageEditor", new TextEditorView(mini: true)
                @label "Title (alt)", class: "message"
                @subview "titleEditor", new TextEditorView(mini: true)
              @div class: "image-container", =>
                    @img outlet: 'imagePreview'

      initialize:->
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
        text = "![#{title}]("+@imageEditor.getText()+")"
        @editor.insertText(text)


      display:(pasteUrl) ->
          @panel ?= atom.workspace.addModalPanel(item: this, visible: false)
          @previouslyFocusedElement = $(document.activeElement)
          @editor = atom.workspace.getActiveTextEditor()
          @imageEditor.setText(pasteUrl)
          @updateImageSource(pasteUrl)
          @panel.show()

      updateImageSource: (file) ->
          return unless file
          @displayImagePreview(file)

      displayImagePreview: (file) ->
          return if @imageOnPreview == file
          if utils.isUrl(file)
              @imagePreview.attr("src", file)
              @imagePreview.load =>
                  console.log "loading"
                  @titleEditor.focus()
              @imagePreview.error =>
                  @imagePreview.attr("src", "")
          else
              @imagePreview.attr("src", "")
          @imageOnPreview = file # cache preview image src



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
