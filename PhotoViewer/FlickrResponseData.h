//
//  FlickrResponseData.h
//  PhotoViewer
//
//  Created by Chris on 10/6/15.
//  Copyright © 2015 Chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrResponseData : NSObject

@property (nonatomic, readonly) NSInteger page;
@property (nonatomic, readonly) NSInteger totalPages;
@property (nonatomic, readonly) NSInteger pageSize;
@property (nonatomic, readonly) NSArray* photos;

+(instancetype) responseDataFromDictionary:(NSDictionary*) flickrResponse;

@end
