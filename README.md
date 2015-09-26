# Leak Finder

It is very easy to build retain cycles when working with UIKit's views and view controllers in iOS. You often have
dependencies between different views and controllers and the corresponding delegates. These memory leaks often remain
undiscovered, especially when they don't consume lots of memory or happen in not-so-well-tested edge cases. Leak Finder
is a small tool which you can integrate easily into your application. It automatically discovers possible memory leaks
in view controllers and prints a warning. Hence you don't need to add debug messages to see if a view controller of view
gets deallocated.


## Getting started

Leak Finder is available on [CocoaPods](http://cocoapods.org) and has a one-line integration. First of all, you need to
add the pod to your project. Add the following to your Podfile and run `pod install`:

```ruby
pod 'LeakFinder'
```

You can learn more about CocoaPods if you have never worked with CocoaPods [in the Guide at NSHipster](http://nshipster.com/cocoapods/)
or in the [official guide](https://guides.cocoapods.org/using/using-cocoapods.html).

To use the leak finder after you have added the pod, import the header, or create an [Objective-C bridging
header](https://developer.apple.com/library/ios/documentation/swift/conceptual/buildingcocoaapps/MixandMatch.html)
if you're using Swift:

```objective-c
#import <LeakFinder/ViewControllerObserver.h>
```
After that, all you need to do is to instantiate the singleton of the view controller observer. A good place to do this
is in the `application:didFinishLaunchingWithOptions:` method of your app delegate.

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /// Instantiate the view controller observer which detects memory leaks.
    [ViewControllerObserver sharedInstance];

    return YES;
}
```

And that's it! If you now run your app and you have an actual memory leak in your application, you will see a message
similar to this in the console (or the system log to be precise):

```
2015-09-19 23:16:28.838 LeakFinder[8262:79575] Possible memory leak: ViewController <MyViewController: 0x7fa941765f90> (MyViewController)
```

This means that you have a possible memory leak in the view controller class `MyViewController`. If you want to get
more or better information on the leaking object, you can write your own reporter to have full control about the
reporting.

If you want to see some examples how it works without the need to integrate it into your app, you can run

```bash
pod try LeakFinder
```

to open an example application which uses LeakFinder to find some memory leaks.

## Using a custom reporter

All detected memory leaks are reported using the reporter of the view controller observer. You can exchange the
reporter by setting the `reporter` property on the view controller observer:

```objective-c
MyCustomReporter myReporter = [MyCustomReporter new];
[ViewControllerObserver sharedInstance].reporter = myReporter;
```

For example, you could implement a reporter which throws an error every time a memory leak is detected. The reporter
also gets passed an instance of the leaking object, so you can set breakpoints in the reporter to further inspect the
leaking object.

Any object which implements the `ViewControllerObserverReporter` protocol can be a reporter.

By default, the `ViewControllerObserverSystemOutReporter` is used to report memory leaks. It reports all leaks to the
system log.

## How it works

The general idea is that a view controller and its view (including all subviews) will be deallocated soon after the view
controller has been dismissed. This little tool hooks into the dismissing of view controllers. After a view controller
has been dismissed, it waits for a configurable time interval. After the time interval has been expired, it checks if the
view controller and all of it views has been deallocated. If not, a warning is shown on the console.

You can look into the example application in this repository to see some examples.

Technically, it works by swizzling the methods on `UIViewController` and `UINavigationController` to detect when a view
controller is being dismissed.


## License

Leak finder is MIT/Expat-licensed. See `[LICENSE](https://github.com/Lukas-Stuehrk/LeakFinder/blob/master/LICENSE)` for
details.

## Feedback

I am happy for every feedback regarding usage, improvements and of course bugs. Please report all bugs and feedback at
the [issue tracker at Github](https://github.com/Lukas-Stuehrk/LeakFinder/issues).


## Similar projects

There are at least two similar projects with related approaches. Unfortunately I discovered those projects after I had
finished my implementation of the leak detection. However, both projects do not implement leak detection in views (which
this project does).

* [BTFLeakDetect](https://github.com/grav/leakdetect) Same approach of detecting the leaks, but unfortunately it does
   not handle all cases how a view controller can be dismissed from a navigation controller. Also, it lacks the leak
   detection in views.
* [MSVCLeakHunter](https://github.com/mindsnacks/MSVCLeakHunter) Different approach for detecting the leaks (via
   `viewDidDisappear:`). This approach causes a lot of false positives in the leak detection. Also, it lacks the leak
   detection in views.
