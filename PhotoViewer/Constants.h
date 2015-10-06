//
//  Constants.h
//  PhotoViewer
//
//  Created by Chris on 10/4/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#ifndef PhotoViewer_Constants_h
#define PhotoViewer_Constants_h

#import <Foundation/Foundation.h>

@class MediaResultsPager;

typedef void(^MediaResultsBlock)(NSArray* mediaObjects, MediaResultsPager* pager, NSError* error);

static const NSInteger kMediaPageSize = 10;

FOUNDATION_EXPORT NSString* const PhotoViewErrorDomain;
FOUNDATION_EXPORT NSInteger const ERROR_CODE_INVALID_RESPONSE;

#endif
