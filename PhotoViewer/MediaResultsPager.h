//
//  MediaResultsPager.h
//  PhotoViewer
//
//  Created by Chris on 10/4/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

typedef void (^DataRequestBlock) (NSInteger page, MediaResultsBlock resultsBlock);

@interface MediaResultsPager : NSObject

+(instancetype) dataPagerWithDataRequestBlock:(DataRequestBlock)dataRequestBlock startPage:(NSInteger) startPage;

-(void) loadNextPageData:(MediaResultsBlock) resultsBlock;

@property (nonatomic, readonly) BOOL loadingNextPage;


@end
