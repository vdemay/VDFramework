
# VDFramework

## Description

VDFramework aims to give open source component to make easier iOs dev. 

For now there is only a VDTabBarController which can be customized to display custom decoration on images in it.

## VDTabBarController

A Controller allowing you to choose the style of the items based on the standard UITabBarController (all its features are also available)

You can customize items specifying gradient or reflexive color.


See Classes/VDFrameworkAppDelegate.m to understand how to use VDTabBarController : 

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    		// Override point for customization after application launch.

    		// Add the tab bar controller's view to the window and display.
    		[self.window addSubview:tabBarController.view];
    		[self.window makeKeyAndVisible];

		// ******************************************************************************
		//You can choose style from HERE
		//[tabBarController gradientColorFrom:[UIColor blueColor] to:[UIColor redColor]];
		//[tabBarController reflexiveColor:[UIColor greenColor]];
		// ******************************************************************************

   		return YES;
	}

### Limitations

* Does not work with SystemTabBarItem
* Images in items have to be 30x30  


## Sample

### Default / Gradient / Reflexive
[![](https://github.com/vdemay/VDFramework/raw/master/Documents/default.png)](https://github.com/vdemay/VDFramework/raw/master/Documents/default.png)
[![](https://github.com/vdemay/VDFramework/raw/master/Documents/gradient.png)](https://github.com/vdemay/VDFramework/raw/master/Documents/gradient.png)
[![](https://github.com/vdemay/VDFramework/raw/master/Documents/reflexive.png)](https://github.com/vdemay/VDFramework/raw/master/Documents/reflexive.png)

## License and Copyright

Apache 2 
