//
//  FlickrMediaManager.h
//  PhotoViewer
//
//  Created by Chris on 10/6/15.
//  Copyright © 2015 Chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlickrResponseData;

@interface FlickrMediaManager : NSObject

+(void) loadPopularFlickrImageStartingFromPage:(NSInteger) page resultsBlock:(void(^)(FlickrResponseData* data, NSError* error)) results;

@end
