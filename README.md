# Script Ruby parser plugin for Embulk

TODO: Write short description here and embulk-parser-script_ruby.gemspec file.

## Overview

* **Plugin type**: parser
* **Guess supported**: no

## Configuration

- **script**: script (string, required)
- **class**: class name (string, required)
- **columns**: Array of columns name & type (Array, required)

## Example

config.yaml

```yaml
in:
  type: any file input plugin type
  parser:
    type: script_ruby
    script: parser_hoge
    class: ParserHoge
    columns:
      - name: id
        type: string
      - name: url
        type: string
```

lib/parser_hoge.rb

```ruby 
require 'json'

class ParserHoge
  def initialize
  end

  def parser(io)
    json = io.read
    obj = JSON.parse(json)
    obj.each do | row |
      yield row
    end
  end
end
```

run 

```
embulk run config.yaml -I lib 
```

## Build

```
$ rake
```
