//
//  MGInstagram.m
//  MGInstagramDemo
//
//  Created by Mark Glagola on 10/20/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGInstagram.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <Photos/Photos.h>
@interface MGInstagram ()<UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

@implementation MGInstagram

NSString* const kInstagramAppURLString = @"instagram://app";
NSString* const kInstagramOnlyPhotoFileName = @"tempinstgramphoto.igo";

- (instancetype)init {
    if (self = [super init]) {
        self.photoFileName = kInstagramOnlyPhotoFileName;
    }
    return self;
}

+ (BOOL)isAppInstalled {
    NSURL *appURL = [NSURL URLWithString:kInstagramAppURLString];
    return [[UIApplication sharedApplication] canOpenURL:appURL];
}

//Technically the instagram allows for photos to be published under the size of 612x612
//BUT if you want nice quality pictures, I recommend checking the image size.
+ (BOOL)isImageCorrectSize:(UIImage*)image {
    CGImageRef cgImage = [image CGImage];
    return (CGImageGetWidth(cgImage) >= 612 && CGImageGetHeight(cgImage) >= 612);
}

- (NSString*)photoFilePath {
    NSString *imgURL = [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],self.photoFileName];
    NSLog(@"Save Image URL = %@",imgURL);
    return imgURL;
}

- (void)postImage:(UIImage*)image inView:(UIView*)view {
    [self postImage:image withCaption:nil inView:view];
}
- (void)postImage:(UIImage*)image withCaption:(NSString*)caption inView:(UIView*)view {
    [self postImage:image withCaption:caption inView:view delegate:nil];
}

- (void)postImage:(UIImage*)image withCaption:(NSString*)caption inView:(UIView*)view delegate:(id<UIDocumentInteractionControllerDelegate>)delegate {
    NSParameterAssert(image);
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:[self photoFilePath] atomically:YES];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(postimage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
    
//    NSURL *fileURL = [NSURL fileURLWithPath:[self photoFilePath]];
//    NSData* pngData =  [NSData dataWithContentsOfURL:fileURL];
//    
//    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)pngData, NULL);
//    NSDictionary *metadata = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, 0, NULL));
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeImageToSavedPhotosAlbum:image.CGImage
//                                 metadata:metadata
//                          completionBlock:^(NSURL *assetURL, NSError *error) {
//                              NSLog(@"assetURL %@", assetURL);
//                              
//                              NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://LocalIdentifier?AssetPath=%@",assetURL.absoluteString]];
//                              if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
//                                  [[UIApplication sharedApplication] openURL:instagramURL];
//                              }
//    }];
//    __block PHFetchResult *photosAsset;
//    __block PHAssetCollection *collection;
//    __block PHObjectPlaceholder *placeholder;
//    
//    // Find the album
//    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
//    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", @"YOUR_ALBUM_TITLE"];
//    collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
//                                                          subtype:PHAssetCollectionSubtypeAny
//                                                          options:fetchOptions].firstObject;
//    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:[UIImage imageWithData:pngData]];
//        PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
//        NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?LocalIdentifier=%@",placeholder.localIdentifier]];
//        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
//            [[UIApplication sharedApplication] openURL:instagramURL];
//        }
//        PHAsset *photosAsset = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
//        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection
//                                                                                                                      assets:photosAsset];
//        [albumChangeRequest addAssets:@[placeholder]];
//    } completionHandler:^(BOOL success, NSError *error) {
//        if (success)
//        {
//
//
//
//        }
//        else
//        {
//            NSLog(@"%@", error);
//        }
//    }];
//    
    
//    if (!image) {
//        return;
//    }
//    
//    [UIImageJPEGRepresentation(image, 1.0) writeToFile:[self photoFilePath] atomically:YES];
//    
//    NSURL *fileURL = [NSURL fileURLWithPath:[self photoFilePath]];
//    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
//    self.documentInteractionController.UTI = @"com.instagram.exclusivegram";
//    self.documentInteractionController.delegate = delegate;
//    if (caption) {
//        self.documentInteractionController.annotation = @{@"InstagramCaption" : caption};
//    }
//    [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:view animated:YES];
//    NSLog(@"%@",self.documentInteractionController.URL);

}
- (void) postimage:(UIImage *)iamge hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)contextInfo{
    if(error == nil)
    {
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
//        [fetchOptions setSortDescriptors:[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
        if (fetchResult.lastObject) {
            PHAsset *lastAsset = fetchResult.lastObject;
            NSString *localIdentifier = lastAsset.localIdentifier;
            NSLog(@"LocalIndetifier = %@",localIdentifier);
            NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?LocalIdentifier=%@",localIdentifier]];
            if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                        [[UIApplication sharedApplication] openURL:instagramURL];
            }
        }
        
        
    }else{
        NSLog(@"Error = %@",error.localizedDescription);
    }
}
- (void)documentInteractionControllerWillPresentOptionsMenu:(UIDocumentInteractionController *)controller
{
    NSLog(@"%@",controller.URL);
}

@end
