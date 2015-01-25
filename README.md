# CC Tools

## Installation
**TODO**

## Usage

### Quickstart
```
CCTools.possibleProviders('3712345678901234')
// returns ['amex']

CCTools.luhnValidate('4242424242424242');
// returns true
```

### Possible Providers
The `.possibleProviders` function returns all possible credit card providers (visa, mastercard, etc) for credit cards starting with the numeric string provided.

```
CCTools.possibleProviders('3712345678901234')
// returns ['amex']
```

It support showing all possible options for incomplete credit card numbers.  For example, a card starting with "3" could be from Amex, Diners Club, or JCB, depending on what the subsequent digits are.
```
CCTools.possibleProviders('3')
// returns ['amex', 'dinersClub', 'jcb']
```

By default, Visa and Visa Electron are combined into just visa.  Likewise, dinersClub is combined from dinersClubCarteBlanche, dinersClubEnRoute, dinersClubInternational, and dinersClubUnitedStatesAndCanada.  This functionality can be disabled by passing an optional options hash to `possibleProviders`.
```
CCTools.possibleProviders('3', {combineDinersClub: false});
// returns ['amex', 'dinersClubInternational', 'jcb', 'dinersClubCarteBlanche']

CCTools.possibleProviders('4844', {combineVisa: false});
// returns ['visa', 'visaElectron']
```

Possible card providers include:
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


### Luhn Checking
Also included is a simple Luhn's Algorithm checker.

```
CCTools.luhnValidate('4242424242424242');
// returns true

CCTools.luhnValidate('4242424242424243');
// returns false
```

### Data

All data comes from http://en.wikipedia.org/wiki/Bank_card_number.
