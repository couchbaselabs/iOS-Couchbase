## Mobile Couchbase for iOS

Apache CouchDB on iOS provides a simple way to sync your application data across devices and provide cloud backup of user data. Unlike other cloud solutions, the data is hosted on the device by Couchbase Mobile, so even when the network is down or slow (airplane, subway, backyard) the application is responsive to users.

## Experimental Release

This release is a best effort library and application for data storage and synchronization. We're already making a lot of progress thanks to feedback and patches from users.

The biggest thing we need help with is size optimization - currently a Release build adds about 15 MB to your application. We are targeting 5 MB for our initial round of optimizations. It can definitely go lower but that work might take longer.

## Getting Started

These instructions assume you are familiar with how to make an iPhone app because you've done it a lot already.

One potential gotcha: there is **NO SIMULATOR SUPPORT**

If you have questions or get stuck or just want to say hi, email <mobile@couchbase.com> and let us know that you're interested in Couch on mobile.

## Using Mobile Couchbase

For details on how to use Mobile Couchbase in your projects see [doc/using_mobile_couchbase.md](https://github.com/couchbaselabs/iOS-Couchbase/blob/master/doc/using_mobile_couchbase.md)

## Trying the Demo App:

* Fetch vendor code dependencies by running `git submodule init` and `git submodule update`
* Open Demo.xcodeproj with Xcode.
* Plug your phone into your computer (does NOT work with simulator)
* From the Run menu, select "Run with Performance Tool" > "Activity Monitor"

I don't know why but if you run it with the Activity Monitor on, it is much more responsive and boots faster. Any hints on what could cause this are much appreciated.


## License

Portions under Apache, Erlang, and other licenses.

The overall package is released under the Apache license, 2.0.

Copyright 2011, Couchbase, Inc.