//
//  ___FILENAME___.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPERProtocols.h"

@interface VIPERViewController : UIViewController <VIPERViewProtocol>

@property (nonatomic, strong) id <VIPERPresenterProtocol> presenter;

@end
