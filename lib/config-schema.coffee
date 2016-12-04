module.exports =
    Time:
        type:"object"
        order:1
        properties:
            type:
                title: "DateFormat"
                type: 'string'
                description: "Formater for the Time（格式化时间字符串 yyyy=year MM=month dd=day HH=hour mm=minute ss=second）"
                default: "yyyy-MM-dd HH:mm:ss"


    ImageUpload:
        type: "object"
        properties:
            type:
                title: "ImageEngine"
                description: "The engines to uploader image,and Inert the imageUrl in your markdown-editor."
                type: "string"
                default: "qiniu"
                enum: [
                    {value: 'qiniu', description: 'Qiniu engine.'}
                    {value: 'imgur', description: 'Imgur engine.'}
                ]
                order: 1

            disableImagePaste:
                title: "Disable image paste（关闭图片复制功能）"
                description: "Turn the paste function on/off."
                type: "boolean"
                default: false
                order: 1


    QiNiu:
        type: "object"
        properties:
            qiniuAK:
                title: "AccessKey"
                type: 'string'
                description: "在七牛后台 “个人面板 - 密钥管理” 下查看AccessKey的值"
                default: ""
                order:1
            qiniuSK:
                title: "SecretKey"
                type: 'string'
                description: "在七牛后台 个人面板 - 密钥管理” 下查看SecretKey的值"
                default: ""
                order:2
            qiniuBucket:
                title: "Bucket"
                type: 'string'
                description: "在七牛后台 “对象存储 - 存储空间列表” 下找一个空间名称"
                default: ""
                order:3
            qiniuDomain:
                title: "Domain"
                type: 'string'
                description: "在七牛后台指定空间下 “对象存储 - 存储空间列表- 域名设置” 下查看空间绑定的域名"
                default: ""
                order:4
