/*
* Youtube Embed Plugin
*
* @author Jonnas Fonini <contato@fonini.net>
* @version 1.0.7
*/
function ytVidId(e){var t=/^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$/;return e.match(t)?RegExp.$1:!1}function hmsToSeconds(e){var t=e.split(":"),n=0,r=1;while(t.length>0)n+=r*parseInt(t.pop(),10),r*=60;return n}(function(){CKEDITOR.plugins.add("youtube",{lang:["en","pt","ja","hu","it","fr","tr","ru","de"],init:function(e){e.addCommand("youtube",new CKEDITOR.dialogCommand("youtube",{allowedContent:"iframe[!width,!height,!src,!frameborder,!allowfullscreen]; object param[*]"})),e.ui.addButton("Youtube",{label:e.lang.youtube.button,toolbar:"insert",command:"youtube",icon:this.path+"images/icon.png"}),CKEDITOR.dialog.add("youtube",function(t){var n;return{title:e.lang.youtube.title,minWidth:500,minHeight:200,contents:[{id:"youtubePlugin",expand:!0,elements:[{id:"txtEmbed",type:"textarea",label:e.lang.youtube.txtEmbed,autofocus:"autofocus",onKeyUp:function(e){this.getValue().length>0?this.getDialog().getContentElement("youtubePlugin","txtUrl").disable():this.getDialog().getContentElement("youtubePlugin","txtUrl").enable()},validate:function(){if(this.isEnabled()){if(!this.getValue())return alert(e.lang.youtube.noCode),!1;if(this.getValue().length===0||this.getValue().indexOf("//")===-1)return alert(e.lang.youtube.invalidEmbed),!1}}},{type:"html",html:e.lang.youtube.or+"<hr>"},{type:"hbox",widths:["70%","15%","15%"],children:[{id:"txtUrl",type:"text",label:e.lang.youtube.txtUrl,onKeyUp:function(e){this.getValue().length>0?this.getDialog().getContentElement("youtubePlugin","txtEmbed").disable():this.getDialog().getContentElement("youtubePlugin","txtEmbed").enable()},validate:function(){if(this.isEnabled()){if(!this.getValue())return alert(e.lang.youtube.noCode),!1;n=ytVidId(this.getValue());if(this.getValue().length===0||n===!1)return alert(e.lang.youtube.invalidUrl),!1}}},{type:"text",id:"txtWidth",width:"60px",label:e.lang.youtube.txtWidth,"default":e.config.youtube_width!=null?e.config.youtube_width:"640",validate:function(){if(!this.getValue())return alert(e.lang.youtube.noWidth),!1;var t=parseInt(this.getValue())||0;if(t===0)return alert(e.lang.youtube.invalidWidth),!1}},{type:"text",id:"txtHeight",width:"60px",label:e.lang.youtube.txtHeight,"default":e.config.youtube_height!=null?e.config.youtube_height:"360",validate:function(){if(!this.getValue())return alert(e.lang.youtube.noHeight),!1;var t=parseInt(this.getValue())||0;if(t===0)return alert(e.lang.youtube.invalidHeight),!1}}]},{type:"hbox",widths:["55%","45%"],children:[{id:"chkRelated",type:"checkbox","default":e.config.youtube_related!=null?e.config.youtube_related:!0,label:e.lang.youtube.chkRelated},{id:"chkOlderCode",type:"checkbox","default":e.config.youtube_older!=null?e.config.youtube_older:!1,label:e.lang.youtube.chkOlderCode}]},{type:"hbox",widths:["55%","45%"],children:[{id:"chkPrivacy",type:"checkbox",label:e.lang.youtube.chkPrivacy,"default":e.config.youtube_privacy!=null?e.config.youtube_privacy:!1},{id:"txtStartAt",type:"text",label:e.lang.youtube.txtStartAt,validate:function(){if(this.getValue()){var t=this.getValue();if(!/^(?:(?:([01]?\d|2[0-3]):)?([0-5]?\d):)?([0-5]?\d)$/i.test(t))return alert(e.lang.youtube.invalidTime),!1}}}]}]}],onOk:function(){var e="";if(this.getContentElement("youtubePlugin","txtEmbed").isEnabled())e=this.getValueOf("youtubePlugin","txtEmbed");else{var t="//",r=[],i,s=this.getValueOf("youtubePlugin","txtWidth"),o=this.getValueOf("youtubePlugin","txtHeight");this.getContentElement("youtubePlugin","chkPrivacy").getValue()===!0?t+="www.youtube-nocookie.com/":t+="www.youtube.com/",t+="embed/"+n,this.getContentElement("youtubePlugin","chkRelated").getValue()===!1&&r.push("rel=0"),i=this.getValueOf("youtubePlugin","txtStartAt");if(i){var u=hmsToSeconds(i);r.push("start="+u)}this.getContentElement("youtubePlugin","chkOlderCode").getValue()===!0?(t=t.replace("embed/","v/"),t=t.replace(/&/g,"&amp;"),r.length==0&&(t+="?"),t+="hl=pt_BR&amp;version=3",e='<object width="'+s+'" height="'+o+'">',e+='<param name="movie" value="'+t+'"></param>',e+='<param name="allowFullScreen" value="true"></param>',e+='<param name="allowscriptaccess" value="always"></param>',e+='<embed src="'+t+'" type="application/x-shockwave-flash" ',e+='width="'+s+'" height="'+o+'" allowscriptaccess="always" ',e+='allowfullscreen="true"></embed>',e+="</object>"):(r.length>0&&(t=t+"?"+r.join("&")),e='<iframe width="'+s+'" height="'+o+'" src="'+t+'" ',e+='frameborder="0" allowfullscreen></iframe>')}var a=this.getParentEditor();a.insertHtml(e)}}})}})})();