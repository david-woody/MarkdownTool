module.exports =
  uploader:
        title: "DateFormat"
        type: 'string'
        description: "Formater for the Time（格式化时间字符串 yyyy=year MM=month dd=day HH=hour mm=minute ss=second）"
        default: "yyyy-MM-dd HH:mm:ss"

  disableImagePaster:
    title: "Disable image paster（关闭图片复制功能）"
    type: "boolean"
    default: false

  particles:
    type: "object"
    properties:
      colours:
        type: "object"
        properties:
          type:
            title: "Colours"
            description: "Configure colour options"
            type: "string"
            default: "cursor"
            enum: [
              {value: 'cursor', description: 'Particles will be the colour at the cursor.'}
              {value: 'random', description: 'Particles will have random colours.'}
              {value: 'fixed', description: 'Particles will have a fixed colour.'}
            ]

          fixed:
            title: "Fixed colour"
            description: "Colour when fixed colour is selected"
            type: "color"
            default: "#fff"
            order: 1

  excludedFileTypes:
    type: "object"
    properties:
      excluded:
        title: "Prohibit activate-power-mode from enabling on these file types:"
        description: "Use comma separated, lowercase values (i.e. \"html, cpp, css\")"
        type: "array"
        default: ["."]
