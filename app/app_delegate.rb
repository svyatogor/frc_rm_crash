class Record < CDQManagedObject
end

class AppDelegate
  include CDQ
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rootViewController = UIViewController.alloc.init
    rootViewController.title = 'frc_crash'
    rootViewController.view.backgroundColor = UIColor.whiteColor

    navigationController = UINavigationController.alloc.initWithRootViewController(rootViewController)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.makeKeyAndVisible
    r = Record.sort_by(:label, order: :descending).fetch_request
    @controller          = NSFetchedResultsController.alloc.initWithFetchRequest(r,
                                                                                 managedObjectContext: cdq.contexts.current,
                                                                                 sectionNameKeyPath:   nil,
                                                                                 cacheName:            nil)

    @controller.delegate = self
    errorPtr             = Pointer.new(:object)
    unless @controller.performFetch(errorPtr)
      raise "Error fetching data"
    end
    
    Record.new label: '1'
    cdq.save
    true
  end
  
  def controller(_, didChangeObject: object, atIndexPath: indexPath, forChangeType: type, newIndexPath: newPath)
    NSLog "Good!"
  end
end
