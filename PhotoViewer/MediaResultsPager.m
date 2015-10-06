//
//  MediaResultsPager.m
//  PhotoViewer
//
//  Created by Chris on 10/4/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#import "MediaResultsPager.h"

@interface MediaResultsPager()

@property (nonatomic, readwrite) BOOL loadingNextPage;
@property (nonatomic, copy) DataRequestBlock requestBlock;
@property (nonatomic) NSInteger currentPage;

@end

@implementation MediaResultsPager

+(instancetype) dataPagerWithDataRequestBlock:(DataRequestBlock)dataRequestBlock startPage:(NSInteger)startPage
{
    MediaResultsPager* pager = [MediaResultsPager new];
    pager.requestBlock = dataRequestBlock;
    pager.currentPage = startPage;
    return pager;
}

-(void)loadNextPageData:(MediaResultsBlock)resultsBlock
{
    self.loadingNextPage = YES;
    if (self.requestBlock) {
        __weak typeof (self) weakSelf = self;
        self.requestBlock(self.currentPage++, ^(NSArray* mediaObjects, MediaResultsPager* pager, NSError* error){
            weakSelf.loadingNextPage = NO;
            resultsBlock(mediaObjects, pager, error);
        });
        return;
    }
    
    resultsBlock(nil, nil, nil);
}

@end
