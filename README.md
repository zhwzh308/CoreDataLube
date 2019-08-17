
# CDLube

CoreData is great, it is very powerful but difficult to setup. CDLube is a short wrapper to get you started with CoreData. In this example, you can build, run the app in just a few seconds. In the main view controller `ViewController`, tap Browse button, then try add a few new records by tapping `+` on the navigation bar, use swipe gesture on a table cell to delete it, or use the `editButtonItem` next to `+` to delete records the old fashioned way. The `tableView` is dynamically driven by a subclass of `StandardTableViewFetchedResultsController`, so in your code there is no need to do any `performBatchUpdates`.

Steps for setting up your own project

1. Create subclass for StandardTableViewFetchedResultsController, so you can initialize in storyboard (optional).
2. Make sure you create your `xcdatamodeld` file, in that file, you have created models.
3. Subclass `CoreDataController`, so you can customize resource installation (be it from json or csv). Optional
4. For each subclass that connects to a real backing store, it is recommended that you make this subclass singleton. You should also make sure class var `containerName` matches the filename for your `xcdatamodeld` file. (look at example implementation for `CDLubeCoreDataController`)
5. Be sure to make your entity conform to CoreDataFetchable, this will save you a lot of typing in the long run.
6. Do some test.

Known caveats

1. import statement for static library does not autocomplete, although once you import, your code starts to autocomplete.
2. At any point you edit the code from static lib, sometimes error does not appear in the buildtime issue viewer and compilation simply fails. Select build target to the static lib, compile, and issues will appear in the viewer. 
3. FadeSections is not well structured. It only has one animation style, `.fade`.
4. Naming could be better (`TableViewPerformable`, `Performable`, etc...)
5. `removeStore()` is used to remove the file from filesystem, so you can reinitialize the store. It is designed to be a convenience method during development. If your subclass is a singleton, and have been initialized, it is still trying to read the old store. Any subsequent operation will fail. You need to close the app and reopen.
6. `saveContext()` is called on any change to persist the modification right away, you can definitely modify the code to call it less frequently.
