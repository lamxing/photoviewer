//
//  MediaDataManager.h
//  PhotoViewer
//
//  Created by Chris on 10/4/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

typedef NS_ENUM(NSUInteger, MediaSource) {
    MediaSourceInstagram,
    MediaSourceFlickr
};

@interface MediaDataManager : NSObject

/**
 *  Get a list of medias from a specific source
 *
 *  @param source       MediaSource
 *  @param pageIndex    Which page of the record to return
 *  @param resultsBlock Callback for when the media query is finished
 */
+(void) loadMediaFromSource:(MediaSource) source pageIndex:(NSInteger) pageIndex withBlock:(MediaResultsBlock) resultsBlock;

@end
