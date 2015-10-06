//
//  FlickrPhotoObject.h
//  PhotoViewer
//
//  Created by Chris on 10/6/15.
//  Copyright © 2015 Chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhotoObject : NSObject

@property (nonatomic, readonly) NSInteger photoId;
@property (nonatomic, readonly) NSInteger ownerId;
@property (nonatomic, readonly) NSString* secret;
@property (nonatomic, readonly) NSInteger serverId;
@property (nonatomic, readonly) NSInteger farmId;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) BOOL isPublic;
@property (nonatomic, readonly) BOOL isFriend;
@property (nonatomic, readonly) BOOL isFamily;
@property (nonatomic, readonly) NSString* thumbnailUrl;
@property (nonatomic, readonly) NSString* imageUrl;

+(instancetype) photoObjectWithId:(NSInteger) photoId
                          ownerId:(NSInteger) ownerId
                           secret:(NSString*) secret
                         serverId:(NSInteger) serverId
                           farmId:(NSInteger) farmId
                            title:(NSString*) title
                         isPublic:(BOOL) isPublic
                         isFriend:(BOOL) isFriend
                         isFamily:(BOOL) isFamily;

@end
