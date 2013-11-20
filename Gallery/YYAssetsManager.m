//
//  YYAssetsManager.m
//  Gallery
//
//  Created by yan simon on 13-11-15.
//  Copyright (c) 2013年 yan simon. All rights reserved.
//

#import "YYAssetsManager.h"

static YYAssetsManager *instance = nil;

@interface YYAssetsManager ()

@property (nonatomic,strong) ALAssetsLibrary *library;

@end

@implementation YYAssetsManager

+ (instancetype)sharedInstance
{
    if (instance == nil) {
        instance = [[YYAssetsManager alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.library = [[ALAssetsLibrary alloc] init];
    }
    return self;
}

- (void)allAssetsGroupsWithCompletionHandler:(YYAssetsManagerAllAssetsGroupsHandler)handler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        ALAssetsLibraryGroupsEnumerationResultsBlock groupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            if (group != nil) {
                [groups addObject:group];
            } else if (group == nil) {
                // which means completion
                dispatch_async(dispatch_get_main_queue(),^{
                    handler(groups);
                });
                
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error){
            // 相册访问失败的回调，可以打印一下失败原因
            NSLog(@"相册访问失败，ERROR:%@", [error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(),^{
                handler(groups);
            });
        };
    
        [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:groupsEnumeration
                             failureBlock:failureblock];
    
    });

}

- (void)allAssetsWithGroup:(ALAssetsGroup *)group completionHandler:(YYAssetsManagerAllAssetsHandler)handler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *allAssets = [[NSMutableArray alloc] init];
        ALAssetsGroupEnumerationResultsBlock groupEnumeration = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result != nil) {
                // only for photoes
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    [allAssets addObject:result];
                }
            } else if (result == nil) {
                dispatch_async(dispatch_get_main_queue(),^{
                    handler(allAssets);
                });
            }
        };
        
        [group enumerateAssetsUsingBlock:groupEnumeration];
    });
    
}

- (void)assetWithURL:(NSURL *)url completionHandler:(YYAssetsManagerAssetWithURLHandler)handler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ALAssetsLibraryAssetForURLResultBlock urlBlock = ^(ALAsset *asset){
            dispatch_async(dispatch_get_main_queue(),^{
                handler(asset);
            });
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error){
            // 相册访问失败的回调，可以打印一下失败原因
            NSLog(@"相册访问失败，ERROR:%@", [error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(),^{
                handler(nil);
            });
        };
        
        [self.library assetForURL:url resultBlock:urlBlock failureBlock:failureblock];
        
    });
    
}

@end
