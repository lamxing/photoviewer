//
//  MediaDataManager.m
//  PhotoViewer
//
//  Created by Chris on 10/4/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#import "MediaDataManager.h"
#import "InstagramEngine.h"
#import "InstagramMedia.h"
#import "PhotoViewMediaObject.h"
#import "MediaResultsPager.h"
#import "InstagramComment.h"
#import "InstagramPaginationInfo.h"
#import "FlickrPhotoObject.h"
#import "FlickrResponseData.h"
#import "FlickrMediaManager.h"

@implementation MediaDataManager

+(void) loadMediaFromSource:(MediaSource)source pageIndex:(NSInteger)pageIndex withBlock:(MediaResultsBlock)resultsBlock
{
    if (MediaSourceInstagram == source) {
        [[InstagramEngine sharedEngine] getPopularMediaWithSuccess:^(NSArray *media, InstagramPaginationInfo *paginationInfo) {
            
            //no media available
            if (!media || [media count] == 0) {
                resultsBlock(nil, nil, nil);
                return ;
            }
            
            NSMutableArray* medias = @[].mutableCopy;
            for (InstagramMedia* mediaObj in media) {
                PhotoViewMediaObject* obj = [PhotoViewMediaObject new];
                obj.type = mediaObj.isVideo ? MediaObjectTypeVideo : MediaObjectTypePhoto;
                obj.thumbnailUrl = [mediaObj.thumbnailURL absoluteString];
                if (mediaObj.isVideo) {
                    obj.mediaUrl = [mediaObj.standardResolutionVideoURL absoluteString];
                }else
                {
                    //use full size image instead of thumbnail to increase quality
                    obj.mediaUrl = [mediaObj.standardResolutionImageURL absoluteString];
                    obj.thumbnailUrl = [mediaObj.standardResolutionImageURL absoluteString];
                }
                obj.mediaCaption = mediaObj.caption.text;
                
                [medias addObject:obj];
                NSLog(@"got media %@", obj.mediaUrl);
            }
            
            /**
             * since Instagram's popular media API doens't support paging, to satisfy the original spec for 'app should contain pagination',
             * fake the paging from data returned.  Note - this is for testing only, since in reality, every time the instagram's 'popular media' endpoint is called, 
             * instagram returns a different set of media, so the paging is not really paging through the original set of media.
             */
            NSArray* mediaToReturn = nil;
            NSInteger imageStartIndex = kMediaPageSize * pageIndex;
            if (medias.count > imageStartIndex) {
                
                NSRange range = {kMediaPageSize * pageIndex, MIN(kMediaPageSize, medias.count - imageStartIndex)};
                mediaToReturn = [medias subarrayWithRange:range];
                
            }else if(pageIndex == 0)
            {
                mediaToReturn = medias;
            }
            
            //only return pager object when the media result count is >= page size, otherwise there won't be a next page
            MediaResultsPager* pager = nil;
            
            if ([mediaToReturn count] >= kMediaPageSize) {
                
                NSInteger nextPage = pageIndex + 1;
                DataRequestBlock dataBlock = ^(NSInteger page, MediaResultsBlock resultsBlock) {
                    
                    [MediaDataManager loadMediaFromSource:source pageIndex:nextPage withBlock:resultsBlock];
                    
                };
                
                pager = [MediaResultsPager dataPagerWithDataRequestBlock:dataBlock startPage:nextPage];
                
            }
            
            resultsBlock(mediaToReturn, pager, nil);
            
        } failure:^(NSError *error, NSInteger serverStatusCode) {
            NSLog(@"error download media from instagram %@", error);
            resultsBlock(nil, nil, error);
        }];
        
        return;
    }
    
    if (MediaSourceFlickr == source) {
        
        [FlickrMediaManager loadPopularFlickrImageStartingFromPage:pageIndex resultsBlock:^(FlickrResponseData *data, NSError *error) {
            
            if (error) {
                resultsBlock(nil, nil, error);
                return ;
            }
            
            if ([data.photos count] == 0) {
                resultsBlock(nil, nil, nil);
                return;
            }
            
            NSMutableArray* objs = @[].mutableCopy;
            
            for (FlickrPhotoObject* flickrObj in data.photos) {
                
                PhotoViewMediaObject* obj = [PhotoViewMediaObject new];
                obj.type = MediaObjectTypePhoto;
                obj.thumbnailUrl = flickrObj.thumbnailUrl;
                obj.mediaUrl = flickrObj.imageUrl;
                obj.mediaCaption = flickrObj.title;
                
                [objs addObject:obj];
            }
            
            MediaResultsPager* pager = nil;
            if (data.page < data.totalPages) {
                NSInteger nextPage = pageIndex + 1;
                DataRequestBlock dataBlock = ^(NSInteger page, MediaResultsBlock resultsBlock) {
                    
                    [MediaDataManager loadMediaFromSource:source pageIndex:nextPage withBlock:resultsBlock];
                    
                };
                
                pager = [MediaResultsPager dataPagerWithDataRequestBlock:dataBlock startPage:nextPage];

            }
            
            resultsBlock(objs, pager, nil);
            
        }];
        
        return;
    }
    
    
}

@end
