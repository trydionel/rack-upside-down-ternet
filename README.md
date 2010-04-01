# Introduction
Inspired entirely by @jasonnoble, this Rack middleware recreates the upside-down-ternet described in [http://www.ex-parrot.com/pete/upside-down-ternet.html](http://www.ex-parrot.com/pete/upside-down-ternet.html).

# Fun Stuff
Works just like any other middleware.  Bonus: set your own image transformations!

    # environment.rb
    require 'rack_upside_down_ternet'
    config.middleware.use Rack::UpsideDownTernet, '-blur 10'

# Broken Stuff
*  Uses curl instead of just grabbing the file out of the images directory
*  Doesn't even kinda work with remote/absolute URL images
*  Requires unicorn (or any multi-worker setup).  Make sure you have at least 2 workers running, as your first request will block curl from downloading images
*  Requires that you create `PROJECT_DIR/tmp` and `PROJECT_DIR/images/mod`