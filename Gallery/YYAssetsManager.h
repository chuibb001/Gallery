//
//  YYAssetsManager.h
//  Gallery
//
//  Created by yan simon on 13-11-15.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^YYAssetsManagerAllAssetsGroupsHandler)(NSArray *allGroups);
typedef void(^YYAssetsManagerAllAssetsHandler)(NSArray *allAssets);
typedef void(^YYAssetsManagerAssetWithURLHandler)(ALAsset *asset);

@interface YYAssetsManager : NSObject

+ (instancetype)sharedInstance;

// get all assets groups
- (void)allAssetsGroupsWithCompletionHandler:(YYAssetsManagerAllAssetsGroupsHandler)handler;

// get all assets in specified group
- (void)allAssetsWithGroup:(ALAssetsGroup *)group completionHandler:(YYAssetsManagerAllAssetsHandler)handler;

// get a asset with url
- (void)assetWithURL:(NSURL *)url completionHandler:(YYAssetsManagerAssetWithURLHandler)handler;

// get all assets groups
- (NSArray *)allAssetsGroups;

// get all assets in specified group
- (NSArray *)allAssetsWithGroup:(ALAssetsGroup *)group;

// get a asset with url
- (ALAsset *)assetWithURL:(NSURL *)url;

@end                            
