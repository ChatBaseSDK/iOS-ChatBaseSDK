//
//  CBWelcomeViewController.h
//  
//
//  Created by Diego Jimenez Martinez on 22/9/17.
//

#import <UIKit/UIKit.h>

@interface CBWelcomeViewController : UIViewController

@property (nonatomic, copy) NSMutableDictionary *userLSDetails;
@property (nonatomic, assign) NSInteger style;

- (void)CBWelcomeViewControllerInitialization:(NSInteger)style;

@end
