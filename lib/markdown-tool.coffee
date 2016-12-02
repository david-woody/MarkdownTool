MarkdownToolView = require './markdown-tool-view'
{CompositeDisposable} = require 'atom'

module.exports  = MarkdownTool =
  markdownToolView: null
  modalPanel: null
  disposables: null
  config:
    uploader:
      title: "DateFormat"
      type: 'string'
      description: "Formater for the Time（格式化时间字符串 yyyy=year MM=month dd=day HH=hour mm=minute ss=second）"
      default: "yyyy-MM-dd HH:mm:ss"

    disableImagePaster:
      title: "Disable image paster（关闭图片复制功能）"
      type: "boolean"
      default: false


    activate: (state) ->
        @markdownToolView = new MarkdownToolView(state.markdownToolViewState)
        @modalPanel = atom.workspace.addModalPanel(item: @markdownToolView.getElement(), visible: false)
        # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
        @disposables = new CompositeDisposable()
        @disposables.add atom.commands.add 'atom-text-editor',
            'markdown-tool:insert-current-time': => @formTime()
        @disposables.add atom.commands.add 'atom-text-editor',
            'markdown-tool:insert-image':=>@addPic()

    deactivate: ->
        @modalPanel.destroy()
        @subscriptions.dispose()
        @markdownToolView.destroy()

    serialize: ->
        markdownToolViewState: @markdownToolView.serialize()

  # if @modalPanel.isVisible()
  #   @modalPanel.hide()
  # else
  #   editor = atom.workspace.getActiveTextEditor()
  #   words = editor.getText().split(/\s+/).length
  #   @markdownToolView.setCount(time)
  #   @modalPanel.show()

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
        editor=atom.workspace.getActiveTextEditor()
        editor.insertText(@formatDate())

    addPic:->
        if @modalPanel.isVisible()
          @modalPanel.hide()
        else
          editor = atom.workspace.getActiveTextEditor()
          words = editor.getText().split(/\s+/).length
          @markdownToolView.setCount(words)
          @modalPanel.show()
