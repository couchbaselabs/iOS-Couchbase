
At [Couchbase](http://www.couchbase.com) (that's right) we've been working on the mobile stuff for a long time. Apache CouchDB has been [available on Android](https://github.com/couchone/couch-android-launcher) since last July.


## We're announcing Mobile Couchbase

Mobile Couchbase is a package of Apache CouchDB for iOS applications. We've been working on it for a while, but we did not want to share any code until our test application made it through the approval process.

Today is the day we've been waiting for.

It's not a big deal. Our app that got approved, we're not even gonna release it yet. It just warms our heart to know that Apple welcomes our technology into their glossy embrace.

What this means for you:

* You can embed the rock solid distributed database, Mobile Couchbase, on your iOS device.
* Your iOS apps can use Apache CouchDB's well-proven synchronization technology.
* If you <3 CouchApps, you can deploy them as iOS apps.

This is a developer preview. We aim for a beta release in a matter of weeks, which will include more documentation and perhaps some other goodies.

## Here's how to be a hacker on it

The first thing you'll probably do is a git clone, and then want to build the thing. The Github URL is <https://github.com/couchbaselabs/iOS-Couchbase> and the documentation is decent, so you should be able to get started.

What we need is a few good iOS developers who are willing to lend a hand. We are grateful to Alexis Hildebrandt, who did a lot of the initial build packaging for XCode.

The biggest thing we need help with is size optimization - currently the build adds 15 MB to your application. We are targeting 5 MB for our initial round of optimizations. It can definitely go lower but that work might take longer.

We have a vision for Mobile Couchbase, and we'll make that clear over time -- this is just a first shot at making the power of Apache CouchDB available to mobile applications.

So please, communicate with what you would like to see. You can email <mobile@couchbase.com> with your ideas and questions.

It looks maybe possible to embed Couch directly as a storage layer for Core Data. We've haven't started work here yet but here's starter documentation:

<http://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/AtomicStore_Concepts/Introduction/Introduction.html#//apple_ref/doc/uid/TP40004521>

## Join us

There is a [Google Group here for Mobile Couchbase](https://groups.google.com/group/mobile-couchbase). Let's talk about how to optimize the Erlang build, what the best Cocoa APIs are for CouchDB, how to take advantage of replication on mobile devices. It'll be fun.

## Drinkup Tonight

We are having a meetup at 6pm tonight (Thursday) at the Irish Bank in San Francisco.

Jan and I will be there, and hopefully friends and folks interested in iOS Couch.

The Irish Bank: <http://theirishbank.com/> It's just a few blocks from the Montgomery BART station.

Hope to see you there!
