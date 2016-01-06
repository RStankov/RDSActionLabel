# Work in Progress

[![Build Status](https://secure.travis-ci.org/RStankov/RDSActionLabel.png)](http://travis-ci.org/RStankov/RDSActionLabel)

# RDSActionLabel

A UILabel subclass, that adds highlighting support to labels. Supporting hashtags, mentions, urls and having the ability to recognize custom texts. Written in Swift.

## Installation

```
use_frameworks!

pod 'RDSActionLabel'
```

## Usage

```swift
let label = RDSActionLabel()

label.text = "Comment containing several #hash-1 #hash-2 from @username linking to http://example.com"

label.matchUsername(color: mentionColor, selectedColor: mentionSelectedColor) { self.selectUser($0) }
label.matchHashtag(color: hashtagColor, selectedColor: hashtagSelectedColor) { self.selectHash($0) }
label.matchUrl(color: URLColor, selectedColor: URLSelectedColor) { self.selectUrl($0) }
```

#### Defining your own matchers

```swift
let label = RDSActionLabel()

label.match("custom regular expression", color: color, selectedColor: selectedColor) { self.handle($0) }
```

#### Use in Objective-C

```objective-c
#import "RDSActionLabel-Swift.h"

RDSActionLabel *label = [RDSActionLabel new]

// you pass `nil` for using the default values
[self.legalLabel matchUrlWithColor:urlColor selectedColor:selectedUrlColor handle:^(NSString * _Nonnull urlString) {
  [self handleUrl:urlString];
}];
```

### Tests

```
gem install scan
./bin/test
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Run the tests
6. Create new Pull Request

## License

**[MIT License](https://github.com/RStankov/RDSActionLabel/blob/master/LICENSE.txt)**
