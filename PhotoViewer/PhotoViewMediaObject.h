//
//  PhotoViewMediaObject.h
//  PhotoViewer
//
//  Created by Chris on 10/4/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MediaObjectType) {
    MediaObjectTypePhoto,
    MediaObjectTypeVideo
};

@interface PhotoViewMediaObject : NSObject

@property (nonatomic) MediaObjectType type;
@property (nonatomic) NSString* mediaUrl;
@property (nonatomic) NSString* thumbnailUrl;
@property (nonatomic) NSString* mediaCaption;

@end
