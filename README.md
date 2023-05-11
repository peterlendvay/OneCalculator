# OneCalculator

The command line tool was created using Apple's Swift Argument Parser as it's only dependency.

To build the tool either open and build in XCode or use the `swift build -c release` command in the root folder.
To use the the tool either edit the lauch parameters under the edit target in XCode and run, or access it from `.build/release/OneCalculator` in the root folder.

example usage:

`.build/release/OneCalculator "1 + 2&1/2"`
`= 3&1/2`

