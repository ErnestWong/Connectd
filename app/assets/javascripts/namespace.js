(function() {
  namespace = function(namespace) {
    if(window[namespace] === undefined) {
      return window[namespace] = {};
    }
  }
  return window[namespace] = namespace;
})();
