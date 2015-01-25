(function() {
  var CCTools, iinMap, luhnValidate, possibleProviders, provider, supportProviders, _, _combineProvider, _fragmentMatchesRange, _fragmentMatchesValue, _uniq;

  luhnValidate = function(c){for(var d=c.length,b=0,e=[[0,1,2,3,4,5,6,7,8,9],[0,2,4,6,8,1,3,5,7,9]],a=0;d--;)a+=e[b][parseInt(c.charAt(d),10)],b^=1;return 0===a%10&&0<a};;

  iinMap = {
    amex: [34, 37],
    bankcard: [5610, [560221, 560225]],
    chinaUnionPay: [62],
    dinersClubCarteBlanche: [[300, 305]],
    dinersClubEnRoute: [2014, 2149],
    dinersClubInternational: [[300, 305], 309, 36, [38, 39]],
    dinersClubUnitedStatesAndCanada: [54, 55],
    discover: [6011, [622126, 622925], [644, 649], 65],
    interPayment: [636],
    instaPayment: [[637, 639]],
    jcb: [[3528, 3589]],
    laser: [6304, 6706, 6771, 6709],
    maestro: [[500000, 509999], [560000, 699999]],
    dankort: [5019],
    masterCard: [[51, 55], [222100, 272099]],
    solo: [6334, 6767],
    "switch": [4903, 4905, 4911, 4936, 564182, 633110, 6333, 6759],
    visa: [4],
    visaElectron: [4026, 417500, 4405, 4508, 4844, 4913, 4917],
    uatp: [1]
  };

  supportProviders = (function() {
    var _results;
    _results = [];
    for (provider in iinMap) {
      _ = iinMap[provider];
      _results.push(provider);
    }
    return _results;
  })();

  possibleProviders = function(ccNumber, options) {
    var candidates, p, range, ranges, _i, _len;
    if (options == null) {
      options = {};
    }
    if (options.combineDinersClub == null) {
      options.combineDinersClub = true;
    }
    if (options.combineVisa == null) {
      options.combineVisa = true;
    }
    if (typeof ccNumber !== "string") {
      throw "ccNumber is expected to be a string, but was " + ccNumber;
    }
    if (ccNumber.length === 0) {
      return _uniq((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = supportProviders.length; _i < _len; _i++) {
          p = supportProviders[_i];
          _results.push(_combineProvider(p, options));
        }
        return _results;
      })());
    }
    candidates = [];
    for (provider in iinMap) {
      ranges = iinMap[provider];
      provider = _combineProvider(provider, options);
      for (_i = 0, _len = ranges.length; _i < _len; _i++) {
        range = ranges[_i];
        if (candidates.indexOf(provider) === -1) {
          if (typeof range === 'number' && _fragmentMatchesValue(ccNumber, range)) {
            candidates.push(provider);
          } else if (Array.isArray(range) && _fragmentMatchesRange(ccNumber, range[0], range[1])) {
            candidates.push(provider);
          }
        }
      }
    }
    return candidates;
  };

  _uniq = function(array) {
    var element, resultArray, _i, _len;
    resultArray = [];
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      element = array[_i];
      if (resultArray.indexOf(element) === -1) {
        resultArray.push(element);
      }
    }
    return resultArray;
  };

  _combineProvider = function(provider, options) {
    if (options.combineVisa && provider.match(/^visa/)) {
      return 'visa';
    } else if (options.combineDinersClub && provider.match(/^dinersClub/)) {
      return 'dinersClub';
    } else {
      return provider;
    }
  };

  _fragmentMatchesValue = function(fragment, value) {
    var lengthToCompare;
    lengthToCompare = Math.min(value.toString().length, fragment.length);
    fragment = fragment.substring(0, lengthToCompare);
    value = value.toString().substring(0, lengthToCompare);
    return fragment === value;
  };

  _fragmentMatchesRange = function(fragment, start, end) {
    var lengthToCompare;
    lengthToCompare = Math.min(start.toString().length, fragment.length);
    fragment = parseInt(fragment.substring(0, lengthToCompare));
    start = parseInt(start.toString().substring(0, lengthToCompare));
    end = parseInt(end.toString().substring(0, lengthToCompare));
    return fragment >= start && fragment <= end;
  };

  CCTools = {
    luhnValidate: luhnValidate,
    possibleProviders: possibleProviders,
    _fragmentMatchesRange: _fragmentMatchesRange,
    _fragmentMatchesValue: _fragmentMatchesValue,
    _supportedProviders: supportProviders,
    _uniq: _uniq
  };

  if (typeof module !== "undefined" && module !== null) {
    module.exports = CCTools;
  } else if (typeof window !== "undefined" && window !== null) {
    window.CCTools = CCTools;
  } else if (typeof global !== "undefined" && global !== null) {
    global.CCTools = CCTools;
  }

}).call(this);
