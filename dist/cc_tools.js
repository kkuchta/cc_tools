(function() {
  var CCTools, iinMap, luhnValidate, possibleProviders, _i, _results;

  luhnValidate = function(c){for(var d=c.length,b=0,e=[[0,1,2,3,4,5,6,7,8,9],[0,2,4,6,8,1,3,5,7,9]],a=0;d--;)a+=e[b][parseInt(c.charAt(d),10)],b^=1;return 0===a%10&&0<a};;

  iinMap = {
    visa: (function() {
      _results = [];
      for (_i = 1; _i <= 300; _i++){ _results.push(_i); }
      return _results;
    }).apply(this)
  };

  possibleProviders = function() {
    return ['visa'];
  };

  CCTools = {
    luhnValidate: luhnValidate,
    possibleProviders: possibleProviders
  };

  if (typeof module !== "undefined" && module !== null) {
    module.exports = CCTools;
  } else if (typeof window !== "undefined" && window !== null) {
    window.CCTools = CCTools;
  } else if (typeof global !== "undefined" && global !== null) {
    global.CCTools = CCTools;
  }

}).call(this);
