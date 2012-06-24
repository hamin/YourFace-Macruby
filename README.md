# Your Face in 10 minutes...with Macruby!
# Talk/Code given at GORUCO 2012 Sat, June 23, 2012

## [Slides are here](https://github.com/hamin/YouFace-MacRuby-Slides.git)

In this talk we will build a face detection and recognition app all in Ruby with the power of MacRuby… in 10 minutes! The purpose of this talk is to demonstrate how one can take advantage of Apple API’s and Ruby tools to quickly build powerful desktop applications.


## Installation and usage ##

These instructions have been written for OS X.

### Pre-requisites ###
  * [MacRuby](http://macruby.org) Install MacRuby (nightly release should be fine)
  * [Face.com API Key](http://developers.face.com/)
    
### Install dependencies ###

Install the Face.com gem. Note I modified the existing 'face' gem and removed the json gem it was using.

    $ sudo macgem install macruby-face

### Configure ###

Make sure to set @face_key and @face_secret from your Face.com credentials in AppDelegate.rb:

### Build & Run ###

1. First in XCode switch to the 'Development' Scheme and Build
2. Switch back to the App 'YourFace' Scheme and hit Run
    
That should be it :)

## Screenshot ##

![Screenshot](http://i.imgur.com/tQ0A7.png)

### License ###

(The MIT License)

Copyright (c) 2012 Haris Amin

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the 'Software'), to deal in
the Software without restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.