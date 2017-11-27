# kinvey-carekit
An iOS CareKit wrapper that uses Kinvey as the backend.

The kinvey-carekit package can be used to develop [CareKit](http://carekit.org/) applications on the Kinvey platform. It wraps the [Kinvey iOS SDK](devcenter.kinvey.com/ios) with classes that allow easy mapping of CareKit objects to a Kinvey backend.

Please refer to the Kinvey [DevCenter](http://devcenter.kinvey.com/) for documentation on using Kinvey.

## Prerequisites
* iOS 9 or later
* XCode 9 or above, Swift 4
* Kinvey app ID and secret. If you have not created a Kinvey app yet, create one [here](https://console.kinvey.com).

## Getting Started

* Open `KinveyCareKit.workspace`. The workspace contains two projects:
    * `KinveyCareKit` - is a wrapper SDK that exposes classes to back CareKit objects with a Kinvey backend.
    * `OCKSample` - is a fork of the CareKit [sample](https://github.com/carekit-apple/CareKit/tree/master/Sample), that shows how to use `KinveyCareKit` in your app.

* Replace `myAppKey` and `myAppSecret` in the `AppDelegate` of `OCKSample` with values you obtain from [Kinvey](https://console.kinvey.com).

* Run `OCKSample`.

## License
See [LICENSE](LICENSE) for details.

## Contributing
We like to see contributions from the community! If you see a bug, want to add a new capability, or just want to give us feedback, we'd love to hear from you.
See [CONTRIBUTING.md](CONTRIBUTING.md) for details on reporting bugs and making contributions.
