//
//  ___FILENAME___.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import "VIPERWireframe.h"

@implementation VIPERWireframe

+ (void)presentVIPERModuleFrom:(id)fromView {
	
	// Generating module components
	id <VIPERViewProtocol> view = [[VIPERViewController alloc] init];
	id <VIPERPresenterProtocol, VIPERInteractorOutputProtocol> presenter = [[VIPERPresenter alloc] init];
	id <VIPERInteractorInputProtocol> interactor = [[VIPERInteractor alloc] init];
	id <VIPERAPIDataManagerInputProtocol> APIDataManager = [[VIPERAPIDataManager alloc] init];
	id <VIPERLocalDataManagerInputProtocol> localDataManager = [[VIPERLocalDataManager alloc] init];
	id <VIPERWireframeProtocol> wireframe= [[VIPERWireframe alloc] init];
	
	// Connecting
	view.presenter = presenter;
	presenter.view = view;
	presenter.wireframe = wireframe;
	presenter.interactor = interactor;
	interactor.presenter = presenter;
	interactor.APIDataManager = APIDataManager;
	interactor.localDataManager = localDataManager;
	
	//TODO: - Present interface(present, push)
}

@end
