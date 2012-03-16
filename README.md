# maestro-sms-plugin
Maestro plugin providing a "task" to send SMS messages through the SMSified gateway. This
plugin is a Ruby-based deployable that gets delivered as a Zip file.

<http://smsified.com/>

Manifest:

* src/smsified_worker.rb
* manifest.json
* README.md (this file)

## The Task
This SMS plugin requires a few inputs:

* **username** (for the SMSified account)
* **password** (for the SMSified account)
* **number** (the 'from' SMSified number)
* **to** (the destination number)
* **body** (the 140 or less chars to send)

The plugin architecture will provide "output" via an internal task handling mechanism, making it available to subsequent composition tasks.

Logging is available to plugins in the form of a "write_output" method that streams to both logs and the Maestro UI's task execution console.

## The Code
Just need to inherit Maestro::MaestroWorker and ensure that you have a method that matches the ```command``` specified in the manifest.json.  Use ```write_output()``` to get stuff sent to the task execution console.  ```Use Maestro.log.INFO/DEBUG/ERROR()``` to get stuff to the agent log.

## The Manifest
Everything should be pretty obvious in the manifest.  It's JSON.  And, everthing in this one is required.

The ```tool_name``` is used by Maestro to drop the task into a specific Tool Type.  The ```command``` is just used by Maestro to get the work from a composition to the task for execution.

Obviously, ```class``` is the name of the class that exists in the ```src/``` subdirectory.

## Requirements
Currently we require the plugin to be development/built under JRuby (and within a RVM-managed setup is just fine :)).  The reason is the dependent maestro-agent gem is currently also the runtime.

This plugin uses SMSified's own gem, which is a simple Httparty wrapper.

## Building
It's really straigtforward. To start, let's fetch the dependencies:

```
$ bundle
```
Next, we'll run the tests:

```
$ bundle exec rake spec
```
Then, we need to package up the plugin for deployment:

```
$ bundle package
$ bundle exec rake package
```

You'll get a ```maestro-sms-plugin-${version}.zip``` file.

## Deploying
Deploying a Maestro plugin is super simple.  Just drop it in Maestro's configured plugins subdirectory (which is specified in the maestro_lucee.json configuration file).  By default it would be ```/etc/maestro/plugins/```.

## HelloWorld!
This plugin is a great starting point for those needing to extend Maestro capability via a plugin (with Ruby).  It's one file (sans tests) and a manifest, shoved into a zip file.

## License
Apache 2.0 License: <http://www.apache.org/licenses/LICENSE-2.0.html>

