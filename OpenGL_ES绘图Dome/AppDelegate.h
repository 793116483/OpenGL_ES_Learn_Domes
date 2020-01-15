//
//  AppDelegate.h
//  OpenGL_ES绘图Dome
//
//  Created by 瞿杰 on 2020/1/15.
//  Copyright © 2020 yiniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic , strong) UIWindow * window ;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

