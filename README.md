## Mobile Couchbase for iOS

Apache CouchDB on iOS provides a simple way to sync your application data across devices and provide cloud backup of user data. Unlike other cloud solutions, the data is hosted on the device by Couchbase Mobile, so even when the network is down or slow (airplane, subway, backyard) the application is responsive to users.

## Experimental Release

If you just want to get started, jump to **Building the Demo App**

This release is a best effort library and application for data storage and synchronization. We're already making a lot of progress thanks to feedback and patches from users.

The biggest thing we need help with is size optimization - currently a Release build adds about 15 MB to your application. We are targeting 5 MB for our initial round of optimizations. It can definitely go lower but that work might take longer.

## Getting Started

These instructions assume you are familiar with how to make an iPhone app because you've done it a lot already.

One potential gotcha: there is **NO SIMULATOR SUPPORT**

If you have questions or get stuck or just want to say hi, email <mobile@couchbase.com> and let us know that you're interested in Couch on mobile.

## Using Mobile Couchbase

For details on how to use Mobile Couchbase in your projects see [doc/using_mobile_couchbase.md](https://github.com/couchbaselabs/iOS-Couchbase/blob/master/doc/using_mobile_couchbase.md)

## Building the Demo App:

The build is finnicky, please follow these instructions exactly. Also, it hasn't been tested much with Xcode 4. Patches welcome!

* check out this repository
* Fetch vendor code dependencies by running `git submodule init` and `git submodule update`
* Open MobileCouchbase/MobileCouchbase.xcodeproj with Xcode
* Set the build to Device and the target to MobileCouchbase
* Build it. (Rumor has it that on Xcode 4 you have to do this step twice...)
* Plug your phone into your computer (does NOT work with simulator)
* Open Demo.xcodeproj with Xcode.
* In the Xcode sidebar, browse to Resources > Demo-Info.plist and edit the "Bundle identifier" to be something you are provisioned to deploy.
* Build and Run! (You might have to click the Pause button in the Console to "unstick" the launch. That seems to be a debug issue. When launched from the phone the app should work.)

Since this only works on the device, you will need to have an Apple Developer account to install it. [Here are some notes about how to fix provisioning profile issues if you encounter them](http://developer.apple.com/library/ios/#technotes/tn2010/tn2250.html).

## License

Portions under Apache, Erlang, and other licenses.

The overall package is released under the Apache license, 2.0.

Copyright 2011, Couchbase, Inc.