# Using Mobile Couchbase

**Note: Updated for Xcode 4**

### Get the main repository

    git clone git://github.com/couchbaselabs/iOS-Couchbase.git

### Get the submodules

    cd iOS-Couchbase/
    git submodule init
    git submodule update

### Open the Xcode workspace

    open Couchbase.xcworkspace

### Build Couchbase and TouchJSON

    Select the scheme `Couchbase-iphonesimulator` and Build (press `⌘ B`)
    Select the scheme `TouchJSON-iphonesimulator` and Build (preff `⌘ B`)
    Select the scheme `Couchbase-iphoneos` and Build (optional, only if doing on device development)
    Select the scheme `TouchJSON-iphoneos` and Build (optional, only if doing on device development)

### Create a new workspace/project

   File > New Workspace...

   File > New Project...

<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/001.png" width="400"/>

###  Copy Couchbase dependencies into your project

* Drag the `Couchbase.h` file alongside the other files in the sidebar of your project

<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/002.png" width="400"/>

* If you like, you may copy the files into the destination group's folder, or create references to the added files make sure the files are added to your target

<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/003.png" width="400"/>

* Drag the `libCouchbase-iphonesimulator.a` and `libTouchJSON-iphonesimulator.a` files to the `Frameworks` group in your project and add them to your target

<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/004.png" width=400/>
<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/005.png" width=400/>

* Optionally, drag the `libCouchbase-iphoneos.a` and `libTouchJSON-iphoneos.a` files to the `Frameworks` group in your project and add them to your target (only if doing on device development)

<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/006.png" width=400/>
<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/007.png" width=400/>

* Drag the `Couchbase.bundle` to the `Supporting Files` group and add it to your target, this ensures that all Mobile Couchbase runtime files are embedded into your application

<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/008.png" width=400/>
<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/009.png" width=400/>
<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/010.png" width=400/>

* Click on the project and select your active target, navigate to the Build Phases tab, expand the Link Binary with Libaries section

<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/011.png" width=400/>

* Click the `+` button at the bottom of this section

<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/012.png" width=400/>

* Add `libstdc++.dylib` from the list of Apple supplied iOS libraries.

<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/013.png" width=400/>

* Make your App Delegate conform to the `CouchbaseDelegate` protocol by adding `#import "Couchbase.h"` to your app delegate's header file in the Xcode sidebar.

<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/014.png" width=400/>

* Implement the required `couchbaseDidStart` delegate callback method.
 
Do this by adding some code to your app delegate's `.m` file:

    -(void)couchbaseDidStart:(NSURL *)serverURL {
          NSLog(@"Couch is ready!");
    }

* Start Mobile Couchbase in your `application:didFinishLaunchingWithOptions:` by adding `[Couchbase startCouchbase:self];`

<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/015.png" width=400/>

* Press `⌘ R` or choose `Build and Run` form the `Build` menu and watch Mobile Couchbase start up in the Console `⇧ ⌘ R`.

<img src="https://github.com/mschoch/iOS-Couchbase/raw/master/doc/resources/016.png" width=400/>

Thank you for trying Mobile Couchbase. Let us know what you're doing with it by emailing `mobile@couchbase.com` -- nothing makes us happier than seeing Couch solve real problems.
