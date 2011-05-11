# Using Mobile Couchbase

**Note: Updated for Xcode 4**

It takes about 10 steps to get Couchbase up and running in your applications. We are working to simplify this, but for now, here is what we've got. Please send feedback to mobile@couchbase.com if you run into any roadblocks with these instructions.

* Extract the files from the pre-built `iOS-Couchbase/build/MobileCouchbase.tar.bz2`, included in the git clone, or just download that file from here: <https://github.com/couchbaselabs/iOS-Couchbase/downloads>

* Drag the `Couchbase.h` file to the `Other Sources` group in the "Groups & Files" sidebar of your project

<img src="https://github.com/couchbaselabs/iOS-Couchbase/raw/master/doc/resources/001.png" width=400/>

* If you like, you may copy the files into the destination group's folder, or create references to the added files make sure the files are added to your target

<img src="https://github.com/couchbaselabs/iOS-Couchbase/raw/master/doc/resources/001a.png" width=400/>

* Drag the `libcrypto_arm.a` and `libMobileCouchbase.a` files to the `Frameworks` group in your project and add them to your target

<img src="https://github.com/couchbaselabs/iOS-Couchbase/raw/master/doc/resources/002.png" width=400/>
<img src="https://github.com/couchbaselabs/iOS-Couchbase/raw/master/doc/resources/002a.png" width=400/>

* Drag the `MobileCouchbase.bundle` to the `Resources` group and add it to your target, this ensures that all Mobile Couchbase runtime files are embedded into your application

<img src="https://github.com/couchbaselabs/iOS-Couchbase/raw/master/doc/resources/003.png" width=400/>
<img src="https://github.com/couchbaselabs/iOS-Couchbase/raw/master/doc/resources/003a.png" width=400/>

* Press `⌥ ⌘ E` or select your active target and click the `Get Info` from the context menu

<img src="https://github.com/couchbaselabs/iOS-Couchbase/raw/master/doc/resources/004.png" width=400/>

* Click the `+` button below the `Linked Libraries` section

<img src="https://github.com/couchbaselabs/iOS-Couchbase/raw/master/doc/resources/005.png" width=400/>

* Add `libicucore.dylib` and `libstdc++.dylib` from the list of Apple supplied iOS libraries. You can select Dylibs from the drop down to make them easier to find.

<img src="https://github.com/couchbaselabs/iOS-Couchbase/raw/master/doc/resources/006.png" width=400/>

* Make your App Delegate conform to the `CouchbaseDelegate` protocol by adding `#import "Couchbase.h"` to your app delegate's header file in the "Classes" section of your Xcode sidebar.
[[resources/007.png|frame|width=300px]][⃚](resources/007.png)

<img src="https://github.com/couchbaselabs/iOS-Couchbase/raw/master/doc/resources/007.png" width=400/>

* Implement the required `couchbaseDidStart` delegate callback method.
 
Do this by adding some code to your app delegate's `.m` file:

    -(void)couchbaseDidStart:(NSURL *)serverURL {
          NSLog(@"Couch is ready!");
    }

* Start Mobile Couchbase in your `application:didFinishLaunchingWithOptions:` by adding `[Couchbase startCouchbase:self];`

<img src="https://github.com/couchbaselabs/iOS-Couchbase/raw/master/doc/resources/008.png" width=400/>

* Press `⌘ R` or choose `Build and Run` form the `Build` menu and watch Mobile Couchbase start up in the Console `⇧ ⌘ R` -- be sure that you are doing a `Device` build.

<img src="https://github.com/couchbaselabs/iOS-Couchbase/raw/master/doc/resources/009.png" width=400/>

Thank you for trying Mobile Couchbase. Let us know what you're doing with it by emailing `mobile@couchbase.com` -- nothing makes us happier than seeing Couch solve real problems.
