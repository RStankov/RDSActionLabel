# Work in Progress

[![Build Status](https://secure.travis-ci.org/RStankov/RDSActiveLabel.png)](http://travis-ci.org/RStankov/RDSActiveLabel)

# RDSActiveLabel

A UILabel subclass, that adds highlighting support to labels. Supporting hashtags, mentions, urls and having the ability to recognize custom texts. Written in Swift.

## Installation

```
TODO: Cocoa pods instructions
```

## Usage

```swift

let label = RDSActiveLabel()

label.text = "Comment containing several #hash-1 #hash-2 from @username linking to http://example.com/page"

label.addMatcher("^@\\w+", color: userColor, selectedColor: selectedUserColor) { self.selectedUser($0) }
label.addMatcher("#\\w+", color: hashtagColor, selectedColor: hashtagSelectedColor) { self.selectedHashTag($0) }
label.addMatcher("(?i)https?://(?:www\\.)?\\S+(?:/|\\b)", color: URLColor, selectedColor: URLSelectedColor) { self.selectedURL($0) }
```

```
TODO: GIF DEMO
```

```
TODO: All features
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Run the tests (`rake`)
6. Create new Pull Request

## License

**[MIT License](https://github.com/RStankov/RDSActiveLabel/blob/master/LICENSE.txt)**
