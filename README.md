atom-cubic-bezier [![Build Status](https://travis-ci.org/senthilporunan/atom-cubic-bezier.svg?branch=master)](https://travis-ci.org/senthilporunan/atom-cubic-bezier)
=================

atom-cubic-bezier  is an easing function generator for Atom editor

![Cubic Bezier in action](https://rawgit.com/senthilporunan/atom-cubic-bezier/master/resources/output.gif)

## Installation
```
apm install cubic-bezier
```

## Features
* CSS3 predefined easing functions
* Custom easing function generation by simple dragging
* Live easing effect
* Loading bezier curve based on user selection

## Key Bindings
`Ctrl + Alt + B` : Open/Reset Cubic Bezier Curve


Customizing Key Bindings:

Update your `~/.atom/keymap.cson` (`File` > `Open Your Keymap`) with:

```cson
'.workspace':
    'ctrl-alt-b' : 'cubic-bezier:open'
```



## Contributors
https://github.com/senthilporunan/atom-cubic-bezier/graphs/contributors


## License

This plugin is licensed under the [MIT license](https://github.com/senthilporunan/atom-cubic-bezier)

Copyright (c) 2014 [Senthil Porunan](http://www.toolitup.com)

Powered by [toolitup.com](http://www.toolitup.com)
