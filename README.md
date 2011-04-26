## Mobile Couchbase for iOS - Arciem Fork

SEE BELOW FOR INSTRUCTIONS ON BUILDING FOR THE SIMULATOR

Apache CouchDB on iOS provides a simple way to sync your application data across devices and provide cloud backup of user data. Unlike other cloud solutions, the data is hosted on the device by Couchbase Mobile, so even when the network is down or slow (airplane, subway, backyard) the application is responsive to users.

## Experimental Release

If you just want to get started, jump to **Building the Demo App**. We aren't sure about Xcode 4 support yet.

This release is a best effort library and application for data storage and synchronization. We're already making a lot of progress thanks to feedback and patches from users.

The biggest thing we need help with is size optimization - currently a Release build adds about 15 MB to your application. We are targeting 5 MB for our initial round of optimizations. It can definitely go lower but that work might take longer.

## Join us

There is a [Google Group here for Mobile Couchbase](https://groups.google.com/group/mobile-couchbase). Let's talk about how to optimize the Erlang build, what the best Cocoa APIs are for CouchDB, how to take advantage of replication on mobile devices. It'll be fun.


## Getting Started

These instructions assume you are familiar with how to make an iPhone app because you've done it a lot already.

One potential gotcha: there is **NO SIMULATOR SUPPORT**

If you have questions or get stuck or just want to say hi, email <mobile@couchbase.com> and let us know that you're interested in Couch on mobile.

## Using Mobile Couchbase

For details on how to use Mobile Couchbase in your projects see [doc/using_mobile_couchbase.md](https://github.com/couchbaselabs/iOS-Couchbase/blob/master/doc/using_mobile_couchbase.md)


## Building the Demo App

The following instructions can be used to build Mobile Couchbase for devices and simulators. This uses my forks of the necessary libraries as submodules, which have all been updated for Xcode 4 and iOS SDK 4.3.

### Get the main repository

    git clone git://github.com/arciem/iOS-Couchbase.git

### Get the submodules

    cd iOS-Couchbase/
    git submodule init
    git submodule update

### Open the Xcode workspace

    open Couchbase.xcworkspace

### To build and run the Demo App in the simulator:

* Select "CouchDemo-iphonesimulator | iPhone 4.3 Simulator" from the popup
* Click the Run button

### To build and run the Demo App on a device:

* Make sure a properly provisioned device is attached
* Select "CouchDemo-iphoneos | DeviceName(osversion)" from the popup
* Click the Run button


## License

Portions under Apache, Erlang, and other licenses.

The overall package is released under the Apache license, 2.0.

Copyright 2011, Couchbase, Inc.
