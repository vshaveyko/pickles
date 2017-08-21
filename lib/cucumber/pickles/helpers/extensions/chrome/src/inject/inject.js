chrome.extension.sendMessage({}, function(response) {

  var elt = document.createElement("script");

  elt.innerHTML = "var oldOpen=XMLHttpRequest.prototype.open;window.activeRequests=0,XMLHttpRequest.prototype.open=function(a,b,c,d,e){window.activeRequests++,this.addEventListener(\"readystatechange\",function(){4==this.readyState&&window.activeRequests--},!1),oldOpen.call(this,a,b,c,d,e)};";


  document.head.appendChild(elt);

      var style = document.createElement('style');
      style.type = 'text/css';
      style.innerHTML = '* {' +
      '/*CSS transitions*/' +
      ' -o-transition-property: none !important;' +
      ' -moz-transition-property: none !important;' +
      ' -ms-transition-property: none !important;' +
      ' -webkit-transition-property: none !important;' +
      '  transition-property: none !important;' +
      // '/*CSS transforms*/' +
      // '  -o-transform: none !important;' +
      // ' -moz-transform: none !important;' +
      // '   -ms-transform: none !important;' +
      // '  -webkit-transform: none !important;' +
      // '   transform: none !important;' +
      '  /*CSS animations*/' +
      '   -webkit-animation: none !important;' +
      '   -moz-animation: none !important;' +
      '   -o-animation: none !important;' +
      '   -ms-animation: none !important;' +
      '   animation: none !important;}';

         document.head.appendChild(style);


});