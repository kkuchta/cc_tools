require 'should'
CCTools = require '../src/cc_tools'

describe "luhns", ->
  describe 'valid numbers', ->
    validNumbers = [
      '4242424242424242',
      '4111111111111111',
      '347883644164726',
      '5246468617030400'
    ]

    for number in validNumbers
      it "returns true for valid cc number #{number}", ->
        CCTools.luhnValidate(number).should.be.true

  describe 'invalid numbers', ->
    invalidNumbers = [
      '4242424242424243'
    ]
    for number in invalidNumbers
      it "returns false for invalid cc number #{number}", ->
        CCTools.luhnValidate(number).should.be.false

describe '_fragmentMatchesRange', ->
  it 'works for a range shorter than target number', ->
    CCTools._fragmentMatchesRange('123', 11, 13).should.be.true
    CCTools._fragmentMatchesRange('110', 11, 13).should.be.true
    CCTools._fragmentMatchesRange('139', 11, 13).should.be.true
    CCTools._fragmentMatchesRange('109', 11, 13).should.be.false
    CCTools._fragmentMatchesRange('140', 11, 13).should.be.false
  it 'works for a range equal in length to the target number', ->
    CCTools._fragmentMatchesRange('11', 11, 13).should.be.true
    CCTools._fragmentMatchesRange('12', 11, 13).should.be.true
    CCTools._fragmentMatchesRange('13', 11, 13).should.be.true
    CCTools._fragmentMatchesRange('10', 11, 13).should.be.false
    CCTools._fragmentMatchesRange('14', 11, 13).should.be.false
    CCTools._fragmentMatchesRange('99', 11, 13).should.be.false
    CCTools._fragmentMatchesRange('00', 11, 13).should.be.false
  it 'works for a range longer than the target number', ->
    CCTools._fragmentMatchesRange('12', 111, 139).should.be.true
    CCTools._fragmentMatchesRange('11', 111, 139).should.be.true
    CCTools._fragmentMatchesRange('13', 111, 139).should.be.true
    CCTools._fragmentMatchesRange('14', 111, 139).should.be.false
    CCTools._fragmentMatchesRange('99', 111, 139).should.be.false
    CCTools._fragmentMatchesRange('00', 111, 139).should.be.false

describe '_fragmentMatchesValue', ->
  it 'works', ->
    CCTools._fragmentMatchesValue('123', 1).should.be.true
    CCTools._fragmentMatchesValue('123', 12).should.be.true
    CCTools._fragmentMatchesValue('123', 123).should.be.true
    CCTools._fragmentMatchesValue('123', 1234).should.be.true
    CCTools._fragmentMatchesValue('123', 124).should.be.false
    CCTools._fragmentMatchesValue('123', 14).should.be.false
    CCTools._fragmentMatchesValue('123', 1243).should.be.false

describe 'possibleProviders', ->
  resultMap = {
    '1': ['uatp']
    '1098765': ['uatp']
    '222123': ['masterCard']
    '272099': ['masterCard']
    '2721': []
    '3': ['amex', 'dinersClubInternational', 'jcb', 'dinersClubCarteBlanche']
    '300': ['dinersClubCarteBlanche', 'dinersClubInternational']
    '302': ['dinersClubCarteBlanche', 'dinersClubInternational']
    '306': []
    '309': ['dinersClubInternational']
    '3412345': ['amex']
    '3529': ['jcb']
    '37': ['amex']
    '3712345': ['amex']
    '38': ['dinersClubInternational']
    '4': ['switch', 'visa', 'visaElectron']
    '4903': ['switch', 'visa']
    '4844': ['visa', 'visaElectron']
    '509999': ['maestro']
    '5019123': ['dankort', 'maestro']
    '5018123': ['maestro']
    '510000': ['masterCard']
    '55123': ['dinersClubUnitedStatesAndCanada', 'masterCard']
    '56': ['bankcard', 'maestro', 'switch']
    '5610': ['bankcard', 'maestro']
    '564182': ['switch', 'maestro']
    '6': ['chinaUnionPay', 'discover', 'interPayment', 'instaPayment', 'laser', 'solo', 'switch', 'maestro']
    '61': ['maestro']
    '62': ['chinaUnionPay', 'maestro', 'discover']
    '620': ['maestro', 'chinaUnionPay']
    '622126123': ['discover', 'maestro', 'chinaUnionPay']
    '6304': ['laser', 'maestro']
    '6334': ['maestro', 'solo']
    '636': ['interPayment', 'maestro']
    '6759123': ['switch', 'maestro']
    '6771': ['laser', 'maestro']
    '699999': ['maestro']
    '700000': []
    '9000': []
  }

  it "Returns correct providers", ->
    for number, possibleProviders of resultMap
      correctProviders = possibleProviders.sort().join(',')
      testProviders = CCTools.possibleProviders(number).sort().join(',')
      #console.log "correctProviders=#{correctProviders}"
      #console.log "testProviders=#{testProviders}"
      testProviders.should.equal correctProviders

  it "handles long numbers", ->
    number = '4903' + '27460193851236798405' 
    possibleProviders = ['switch', 'visa']
    correctProviders = possibleProviders.sort().join(',')
    testProviders = CCTools.possibleProviders(number).sort().join(',')
    testProviders.should.equal correctProviders

  it "handles empty input", ->
    testProviders = CCTools.possibleProviders('').sort().join(',')
    testProviders.should == CCTools._supportedProviders.sort().join(',')

  it "errors on non-string input", ->
    (-> CCTools.possibleProviders({foo:'bar'})).should.throw()
