//
//  ___FILENAME___.h
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol VIPERInteractorOutputProtocol;
@protocol VIPERInteractorInputProtocol;
@protocol VIPERViewProtocol;
@protocol VIPERPresenterProtocol;
@protocol VIPERLocalDataManagerInputProtocol;
@protocol VIPERAPIDataManagerInputProtocol;

@class VIPERWireframe;

@protocol VIPERViewProtocol
@required
@property (nonatomic, strong) id <VIPERPresenterProtocol> presenter;
/**
 * Add here your methods for communication PRESENTER -> VIEWCONTROLLER
 */
@end

@protocol VIPERWireframeProtocol
@required
+ (void)presentVIPERModuleFrom:(id)fromView;
/**
 * Add here your methods for communication PRESENTER -> WIREFRAME
 */
@end

@protocol VIPERPresenterProtocol
@required
@property (nonatomic, weak) id <VIPERViewProtocol> view;
@property (nonatomic, strong) id <VIPERInteractorInputProtocol> interactor;
@property (nonatomic, strong) id <VIPERWireframeProtocol> wireframe;
/**
 * Add here your methods for communication VIEWCONTROLLER -> PRESENTER
 */
@end

@protocol VIPERInteractorOutputProtocol
/**
 * Add here your methods for communication INTERACTOR -> PRESENTER
 */
@end

@protocol VIPERInteractorInputProtocol
@required
@property (nonatomic, weak) id <VIPERInteractorOutputProtocol> presenter;
@property (nonatomic, strong) id <VIPERAPIDataManagerInputProtocol> APIDataManager;
@property (nonatomic, strong) id <VIPERLocalDataManagerInputProtocol> localDataManager;
/**
 * Add here your methods for communication PRESENTER -> INTERACTOR
 */
@end


@protocol VIPERDataManagerInputProtocol
/**
 * Add here your methods for communication INTERACTOR -> DATAMANAGER
 */
@end

@protocol VIPERAPIDataManagerInputProtocol <VIPERDataManagerInputProtocol>
/**
 * Add here your methods for communication INTERACTOR -> APIDATAMANAGER
 */
@end

@protocol VIPERLocalDataManagerInputProtocol <VIPERDataManagerInputProtocol>
/**
 * Add here your methods for communication INTERACTOR -> LOCLDATAMANAGER
 */
@end
