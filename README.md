## Mobile Couchbase for iOS

Apache CouchDB on iOS provides a simple way to sync your application data across devices and provide cloud backup of user data. Unlike other cloud solutions, the data is hosted on the device by Couchbase Mobile, so even when the network is down or slow (airplane, subway, backyard) the application is responsive to users.

What this means for you:

* You can embed the rock solid distributed database, Mobile Couchbase, on your iOS device.
* Your iOS apps can use Apache CouchDB's well-proven synchronization technology.
* If you <3 CouchApps, you can deploy them as iOS apps.

### Beta Release

If you just want to get started, jump to **Building the Framework**.

The biggest thing we need help with is size optimization - currently a Release build adds about 15 MB to your application. We are targeting 5 MB for our initial round of optimizations. It can definitely go lower but that work might take longer.

## Join us

There is a [Google Group here for Mobile Couchbase](https://groups.google.com/group/mobile-couchbase). Let's talk about how to optimize the Erlang build, what the best Cocoa APIs are for CouchDB, how to take advantage of replication on mobile devices. It'll be fun.


## Getting Started

These instructions assume you are familiar with how to make an iPhone app because you've done it a lot already.

If you have questions or get stuck or just want to say hi, email <mobile@couchbase.com> and let us know that you're interested in Couchbase on mobile.

## Using Mobile Couchbase

For details on how to use Mobile Couchbase in your own apps see [doc/using_mobile_couchbase.md](https://github.com/couchbaselabs/iOS-Couchbase/blob/master/doc/using_mobile_couchbase.md)


## Building The Framework

The following instructions can be used to build Mobile Couchbase for devices and simulators, using Xcode 4. (It is possible the projects might still work with Xcode 3, but we're not testing or supporting this anymore. It's difficult enough to get all the moving parts to mesh together in one version of Xcode at a time!)

### Get the main repository

    git clone git://github.com/couchbaselabs/iOS-Couchbase.git

### Get the submodules

    cd iOS-Couchbase/
    git submodule init
    git submodule update

### Open the Xcode workspace

    open Couchbase.xcworkspace

### Build the framework

* Select "CouchBase.framework" from the scheme popup in the toolbar (it doesn't matter whether you pick a device or simulator destination)
* Select "Build" from the "Product" menu (Cmd-B)

The framework will be created at

    DerivedData/Couchbase/Build/Products/Release-universal/Couchbase.framework

### Sanity Check: Run The Empty App

* First build the framework if you haven't already (the app target's dependencies won't correctly build the framework)
* Select "Empty App" from the scheme popup in the toolbar (choosing the appropriate destination, either device or simulator)
* Click the Run button

The empty app, as the name implies, doesn't actually do anything. It's just an integration test to make sure CouchDB can initialize and run. If everything goes correctly, the last line logged to the Xcode console should end with "Everything works!". Otherwise the app should log an error message and exit.

## Using The Framework In Your Xcode Projects

0. Open your Xcode project.
1. Drag the Couchbase.framework you built previously into the “Frameworks” section of the file list in your project window.
2. Open your target build settings, find the “Search Paths” group, and double-click “Framework Search Paths”.
3. Add an entry with the path of the parent directory of the framework; in our example, “$(SRCROOT)/Frameworks”.
4. If your project doesn't already contain any C++ code, you'll need to add the C++ library: Go to the target's Build Phases, open "Link Binary With Libraries", click the "+" button, and add "libstdc++.dylib".
5. Go to the target's Build Phases and add a new Run Script phase.
6. Paste the following into the script content of the new phase. (NOTE: If you put the Couchbase framework elsewhere, update the path in the 2nd argument to ‘rsync’ accordingly.)

_Important: The `rsync` command below is a single long line. Do not put a newline in the middle!_

    # The 'CouchbaseResources' subfolder of the framework contains Erlang code
    # and other resources needed at runtime. Copy it into the app bundle:
    rsync -a "${SRCROOT}/Frameworks/Couchbase.framework/CouchbaseResources" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

That’s it for the project setup. In your application code, you’ll need to start the CouchbaseEmbeddedServer object at launch time. (See CouchbaseEmbeddedServer.h, and see EmptyAppDelegate.m for an example of how to call it.)


## License

Portions under Apache, Erlang, and other licenses.

The overall package is released under the Apache license, 2.0.

Copyright 2011, Couchbase, Inc.
