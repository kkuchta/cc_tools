# From https://gist.github.com/ShirtlessKirk/2134376
luhnValidate = `function(c){for(var d=c.length,b=0,e=[[0,1,2,3,4,5,6,7,8,9],[0,2,4,6,8,1,3,5,7,9]],a=0;d--;)a+=e[b][parseInt(c.charAt(d),10)],b^=1;return 0===a%10&&0<a};`

# An array of acceptable starting digits for each card provider.  The acceptable
# digits may be values (eg, 4 or 237).  They may also be pairs indicating a range
# (eg [55-57] or [768-900]).  For ranges, the two numbers numbers *must* be of
# equal length (so [99-101] is invalid.  What would that even mean, though?  Is
# 999 valid under that range or not?).
iinMap = {
  amex: [34, 37]
  bankcard: [5610, [560221,560225]]
  chinaUnionPay: [62]
  dinersClubCarteBlanche: [[300,305]]
  dinersClubEnRoute: [2014, 2149]
  dinersClubInternational: [[300,305], 309, 36, [38,39]]
  dinersClubUnitedStatesAndCanada: [54, 55]
  discover: [6011, [622126,622925], [644,649], 65]
  interPayment: [636]
  instaPayment: [[637,639]]
  jcb: [[3528,3589]]
  laser: [6304, 6706, 6771, 6709]
  maestro: [[500000,509999], [560000,699999]]
  dankort: [5019]
  masterCard: [[51,55],[222100,272099]]
  solo: [6334, 6767]
  switch: [4903, 4905, 4911, 4936, 564182, 633110, 6333, 6759]
  visa: [4]
  visaElectron: [4026, 417500, 4405, 4508, 4844, 4913, 4917]
  uatp: [1]
}
supportProviders = (provider for provider, _ of iinMap)

possibleProviders = (ccNumber, options={}) ->
  options.combineDinersClub ?= true
  options.combineVisa ?= true

  unless typeof ccNumber is "string"
    throw "ccNumber is expected to be a string, but was #{ccNumber}"

  if ccNumber.length is 0
    return _uniq((_combineProvider(p, options) for p in supportProviders))

  candidates = []
  for provider, ranges of iinMap
    provider = _combineProvider(provider, options)

    for range in ranges
      if typeof range is 'number' and _fragmentMatchesValue(ccNumber, range)
        candidates.push provider
      else if Array.isArray(range) and _fragmentMatchesRange(ccNumber, range[0], range[1])
        candidates.push provider
  _uniq(candidates)

_uniq = (array) ->
  resultArray = []
  for element in array
    if resultArray.indexOf(element) is -1
      resultArray.push element
  return resultArray

_combineProvider = (provider, options) ->
  if options.combineVisa and provider.match /^visa/
    'visa'
  else if options.combineDinersClub and provider.match /^dinersClub/
    'dinersClub'
  else
    provider

_fragmentMatchesValue = (fragment, value) ->
  lengthToCompare = Math.min(value.toString().length, fragment.length)
  fragment = fragment.substring(0, lengthToCompare)
  value = value.toString().substring(0, lengthToCompare)
  return fragment == value

# Fragment is a string, start/end are integers
_fragmentMatchesRange = (fragment, start, end) ->
  lengthToCompare = Math.min(start.toString().length, fragment.length)

  fragment = parseInt( fragment.substring(0, lengthToCompare) )
  start = parseInt( start.toString().substring(0, lengthToCompare) )
  end = parseInt( end.toString().substring(0, lengthToCompare) )

  return fragment >= start and fragment <= end

CCTools = {
  luhnValidate: luhnValidate,
  possibleProviders: possibleProviders
  _fragmentMatchesRange: _fragmentMatchesRange
  _fragmentMatchesValue: _fragmentMatchesValue
  _supportedProviders: supportProviders
  _uniq: _uniq
}

if module?
  module.exports = CCTools
else if window?
  window.CCTools = CCTools
else if global?
  global.CCTools = CCTools
