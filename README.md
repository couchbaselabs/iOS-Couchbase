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

## Building the Demo App:

The build is finnicky, please follow these instructions exactly. Also, it hasn't been tested much with Xcode 4. Patches welcome!

* Check out this repository
* Fetch vendor code dependencies by running `git submodule init` and `git submodule update`
* Open MobileCouchbase/MobileCouchbase.xcodeproj with Xcode
* Set the build to Device and the target to MobileCouchbase
* Build it. (Rumor has it that on Xcode 4 you have to do this step twice...)
* Plug your phone into your computer (does NOT work with simulator)
* Open Demo.xcodeproj with Xcode.
* In the Xcode sidebar, browse to Resources > Demo-Info.plist and edit the "Bundle identifier" to be something you are provisioned to deploy, like `com.mycompany.Demo`
* Build and Run! (You might have to click the Pause button in the Console to "unstick" the launch. That seems to be a debug issue. When launched from the phone the app should work.)

Since this only works on the device, you will need to have an Apple Developer account to install it. [Here are some notes about how to fix provisioning profile issues if you encounter them](http://developer.apple.com/library/ios/#technotes/tn2010/tn2250.html).

## License

Portions under Apache, Erlang, and other licenses.

The overall package is released under the Apache license, 2.0.

Copyright 2011, Couchbase, Inc.

## Building the Arciem Fork

The following instructions can be used to build Mobile Couchbase for devices and simulators. This uses my forks of the necessary libraries, which have all been updated for Xcode 4 and iOS SDK 4.3. I have also eliminated the need to manually copy dependency files between the projects-- just make sure that the project directories are all siblings.

# Make a directory to hold everything

    mkdir couchdemo
    cd couchdemo/

# Get everything we need

    git clone git://github.com/arciem/ios-openssl.git
    git clone git://github.com/arciem/iMonkey.git
    git clone git://github.com/arciem/iErl14.git
    git clone git://github.com/arciem/iOS-Couchbase.git

# Build openssl

    cd ios-openssl/
    ./build.sh
    cd ..

# Build iMonkey

    cd iMonkey/
    xcodebuild -target iMonkey-iphoneos -configuration Debug -sdk iphoneos4.3
    xcodebuild -target iMonkey-iphonesimulator -configuration Debug -sdk iphonesimulator4.3
    cd ..

# Build iErl14

    cd iErl14/
    xcodebuild -target iErl14-iphoneos -configuration Debug -sdk iphoneos4.3
    xcodebuild -target iErl14-iphonesimulator -configuration Debug -sdk iphonesimulator4.3
    cd ..

# Build iOS-Couchbase

    cd iOS-Couchbase/
    git submodule init
    git submodule update
    cd MobileCouchbase/
    xcodebuild -target MobileCouchbase-iphoneos -configuration Debug -sdk iphoneos4.3
    xcodebuild -target MobileCouchbase-iphonesimulator -configuration Debug -sdk iphonesimulator4.3
    cd ../..

# Open the Demo in Xcode

    cd iOS-Couchbase/Demo/
    open Demo.xcodeproj/

# To build and run in the simulator:

* Select "Demo-iphonesimulator | iPhone 4.3 Simulator" from the popup
* Click the Run button

# To build and run on the device:

* Make sure a properly provisioned device is attached
* Select "Demo-iphoneos | <DeviceName>(osversion)" from the popup
* Click the Run button
