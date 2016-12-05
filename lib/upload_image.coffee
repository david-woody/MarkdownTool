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
        @domain=@getConfig("qiniuDomain")

    getToken: (uploadName) ->
      putPolicy = new qiniu.rs.PutPolicy(@bucket+":"+uploadName)
      console.log putPolicy.token()
      return putPolicy.token()

    upload: (uploadPath, callback) ->
      @imagesBucket.putFile @uploadImageName, uploadPath, (err, ret) =>
            if err
              callback(err)
            else
              callback(null,{ret: ret, url:"#{@domain}/#{ret.key}"})

    getConfig: (config) ->
      atom.config.get "markdown-tool.QiNiu.#{config}"
