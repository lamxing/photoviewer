//
//  FlickrPhotoObject.m
//  PhotoViewer
//
//  Created by Chris on 10/6/15.
//  Copyright © 2015 Chris. All rights reserved.
//

#import "FlickrPhotoObject.h"

@interface FlickrPhotoObject ()

@property (nonatomic, readwrite) NSInteger photoId;
@property (nonatomic, readwrite) NSInteger ownerId;
@property (nonatomic, readwrite) NSString* secret;
@property (nonatomic, readwrite) NSInteger serverId;
@property (nonatomic, readwrite) NSInteger farmId;
@property (nonatomic, readwrite) NSString* title;
@property (nonatomic, readwrite) BOOL isPublic;
@property (nonatomic, readwrite) BOOL isFriend;
@property (nonatomic, readwrite) BOOL isFamily;

@end

@implementation FlickrPhotoObject

+(instancetype) photoObjectWithId:(NSInteger) photoId
                          ownerId:(NSInteger) ownerId
                           secret:(NSString*) secret
                         serverId:(NSInteger) serverId
                           farmId:(NSInteger) farmId
                            title:(NSString*) title
                         isPublic:(BOOL) isPublic
                         isFriend:(BOOL) isFriend
                         isFamily:(BOOL) isFamily
{
    FlickrPhotoObject* obj = [FlickrPhotoObject new];
    obj.photoId = photoId;
    obj.ownerId = ownerId;
    obj.secret = secret;
    obj.serverId = serverId;
    obj.farmId = farmId;
    obj.title = title;
    obj.isPublic = isPublic;
    obj.isFamily = isFamily;
    obj.isFamily = isFriend;
    return obj;
    
}

-(NSString*) thumbnailUrl
{
    return [self photoURLForPhotoID:[@(self.photoId) stringValue] server:[@(self.serverId) stringValue] secret:self.secret farm:[@(self.farmId) stringValue] isThumbnail:YES];
}

-(NSString*) imageUrl
{
    return [self photoURLForPhotoID:[@(self.photoId) stringValue] server:[@(self.serverId) stringValue] secret:self.secret farm:[@(self.farmId) stringValue] isThumbnail:NO];
}

/**
 *  Generate Flickr MediaURL - https://github.com/devedup/FlickrKit/blob/1bbfbf531a518307311e7919c2cbb37453b9c028/Classes/FlickrKit/FlickrKit.m
 *
 *  @param photoID     photoId of the media
 *  @param server      serverId of the media
 *  @param secret      secret of the media
 *  @param farm        farmId of the media
 *  @param isThumbnail YES to return thumbnailURL, else return original image
 *
 *  @return URL (string) of the media
 */
- (NSString *) photoURLForPhotoID:(NSString *)photoID server:(NSString *)server secret:(NSString *)secret farm:(NSString *)farm  isThumbnail:(BOOL)isThumbnail {
    // https://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
    // https://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
    
    static NSString *photoSource = @"https://static.flickr.com/";
    
    NSMutableString *URLString = [NSMutableString stringWithString:@"https://"];
    if ([farm length]) {
        [URLString appendFormat:@"farm%@.", farm];
    }
    
    [URLString appendString:[photoSource substringFromIndex:8]];
    [URLString appendFormat:@"%@/%@_%@", server, photoID, secret];
    
    if (isThumbnail) {
        [URLString appendString:@"_z.jpg"];
    }else
    {
        [URLString appendString:@"_h.jpg"];
    }
    
    
    return URLString;
}

@end
