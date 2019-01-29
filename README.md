# ZJJDownLoadMusic
从酷我获取url下载
首先打开酷我音乐网站：www.kuwo.cn,然后再搜索框里搜索你想要的歌曲,右键点击搜索结果的歌曲名字然后点击复制链接地址
这就是复制的歌曲链接地址http://www.kuwo.cn/yinyue/1650214/
链接中的1650214就是这首歌曲的ID，我们复制歌曲的ID。
然后就用到这段URL：http://player.kuwo.cn/webmusic/st/getNewMuiseByRid?rid=MUSIC_
把复制的歌曲ID添加到这段URL后面，效果如下：
http://player.kuwo.cn/webmusic/st/getNewMuiseByRid?rid=MUSIC_1650214 
在浏览器中打开上面这个URL，会发现都是代码，找到代码最下面几行

<mp3path>n3/32/56/3260586875.mp3</mp3path>
<aacpath>a1/77/41/4144660174.aac</aacpath>
<mp3dl>other.web.ra01.sycdn.kuwo.cn</mp3dl>

MP3外链地址：http://ra01.sycdn.kuwo.cn/resource/n3/32/56/3260586875.mp3
