qiniu=require "node-qiniu"

module.exports = class QiNiuUploader
    # action: correct-order-list-numbers, format-table
    constructor: (imageName) ->
        @uploadImageName = imageName
        qiniu.config({
            access_key: @getConfig("qiniuAK"),
            secret_key: @getConfig("qiniuSK")
          });
        @imagesBucket = qiniu.bucket(@getConfig("qiniuBucket"));

    getToken: (uploadName) ->
      putPolicy = new qiniu.rs.PutPolicy(@bucket+":"+uploadName)
      console.log putPolicy.token()
      return putPolicy.token()

    upload: (uploadPath, callback) ->
      @imagesBucket.putFile @uploadImageName, uploadPath, (err, ret) =>
            if err
              console.log err
            else
              console.log "success"


    getConfig: (config) ->
      atom.config.get "markdown-tool.QiNiu.#{config}"
