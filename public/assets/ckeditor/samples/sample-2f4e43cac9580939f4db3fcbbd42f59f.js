/**
 * Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */
// Tool scripts for the sample pages.
// This file can be ignored and is not required to make use of CKEditor.
(function(){CKEDITOR.on("instanceReady",function(e){var t=e.editor,n=CKEDITOR.document.$.getElementsByName("ckeditor-sample-required-plugins"),r=n.length?CKEDITOR.dom.element.get(n[0]).getAttribute("content").split(","):[],i=[],s;if(r.length){for(s=0;s<r.length;s++)t.plugins[r[s]]||i.push("<code>"+r[s]+"</code>");if(i.length){var o=CKEDITOR.dom.element.createFromHtml('<div class="warning"><span>To fully experience this demo, the '+i.join(", ")+" plugin"+(i.length>1?"s are":" is")+" required.</span>"+"</div>");o.insertBefore(t.container)}}var u=new CKEDITOR.dom.document(document),a=u.find(".button_icon");for(s=0;s<a.count();s++){var f=a.getItem(s),l=f.getAttribute("data-icon"),c=CKEDITOR.skin.getIconStyle(l,CKEDITOR.lang.dir=="rtl");f.addClass("cke_button_icon"),f.addClass("cke_button__"+l+"_icon"),f.setAttribute("style",c),f.setStyle("float","none")}})})();