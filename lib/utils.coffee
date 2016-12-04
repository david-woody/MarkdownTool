{$} = require "atom-space-pen-views"
os = require "os"
path = require "path"
# ==================================================
# General Utils
#
setTabIndex = (elems) ->
  elem[0].tabIndex = i + 1 for elem, i in elems

getFileName=(file)->
   pos=file.lastIndexOf("\\");
   return file.substring(pos+1);

formatDate = (formate) ->
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
URL_REGEX = ///
  ^
  (?:\w+:)?\/\/                       # any prefix, e.g. http://
  ([^\s\.]+\.\S{2}|localhost[\:?\d]*) # some domain
  \S*                                 # path
  $
  ///i

isUrl = (url) -> URL_REGEX.test(url)


IMG_EXTENSIONS = [".jpg", ".jpeg", ".png", ".gif", ".ico"]

isImageFile = (file) ->
  file && (path.extname(file).toLowerCase() in IMG_EXTENSIONS)


module.exports =
  getFileName:getFileName
  setTabIndex:setTabIndex
  formatDate: formatDate
  isUrl: isUrl
  isImageFile: isImageFile
