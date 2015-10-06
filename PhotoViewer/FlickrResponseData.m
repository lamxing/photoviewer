//
//  FlickrResponseData.m
//  PhotoViewer
//
//  Created by Chris on 10/6/15.
//  Copyright © 2015 Chris. All rights reserved.
//

#import "FlickrResponseData.h"
#import "FlickrPhotoObject.h"

@interface FlickrResponseData()

@property (nonatomic, readwrite) NSInteger page;
@property (nonatomic, readwrite) NSInteger totalPages;
@property (nonatomic, readwrite) NSInteger pageSize;
@property (nonatomic, readwrite) NSArray* photos;

@end

@implementation FlickrResponseData

+(instancetype) responseDataFromDictionary:(NSDictionary*) flickrResponse
{
    FlickrResponseData* response = [FlickrResponseData new];
    response.page = [flickrResponse[@"photos"][@"page"] intValue];
    response.totalPages = [flickrResponse[@"photos"][@"pages"] intValue];
    response.pageSize = [flickrResponse[@"photos"][@"perpage"] intValue];

    NSMutableArray* parsedPhotos = @[].mutableCopy;
    for (NSDictionary* photoDict in flickrResponse[@"photos"][@"photo"]) {
        
        NSInteger photoId = [photoDict[@"id"] integerValue];
        NSInteger owner   = [photoDict[@"owner"] integerValue];
        NSString* secret  = photoDict[@"secret"];
        NSInteger farm    = [photoDict[@"farm"] integerValue];
        NSInteger server  = [photoDict[@"server"] integerValue];
        NSString* title   = photoDict[@"title"];
        BOOL isPublic     = [photoDict[@"ispublic"] boolValue];
        BOOL isFriend     = [photoDict[@"isfriend"] boolValue];
        BOOL isFamily     = [photoDict[@"isfamily"] boolValue];
        
        FlickrPhotoObject* obj = [FlickrPhotoObject photoObjectWithId:photoId
                                                              ownerId:owner
                                                               secret:secret
                                                             serverId:server
                                                               farmId:farm title:title
                                                             isPublic:isPublic
                                                             isFriend:isFriend
                                                             isFamily:isFamily];
        [parsedPhotos addObject:obj];
    }
    
    response.photos = parsedPhotos;
    return response;
}

@end
