//
//  PhotoViewerTests.m
//  PhotoViewerTests
//
//  Created by Chris on 10/4/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Constants.h"
#import "MediaDataManager.h"
#import "PhotoViewMediaObject.h"
#import "MediaResultsPager.h"

@interface PhotoViewerTests : XCTestCase

@end

@implementation PhotoViewerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testRetriveInstagramMedia
{
    XCTestExpectation* expect = [self expectationWithDescription:@"Retrieve Instagram Media"];
    [MediaDataManager loadMediaFromSource:MediaSourceInstagram pageIndex:0 withBlock:^(NSArray *mediaObjects, MediaResultsPager* pager, NSError *error) {
        
        XCTAssertNil(error, @"Error occurred retriving instagram media %@", error);
        XCTAssertTrue([mediaObjects isKindOfClass:[NSArray class]], @"invalid media objects array returned %@", mediaObjects);
        for (PhotoViewMediaObject* obj in mediaObjects) {
            XCTAssertTrue([obj isKindOfClass:[PhotoViewMediaObject class]], @"invalid media object returned %@", obj);
        }
        
        [expect fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"test timed out %@", error);
        }
    }];
    
}

-(void) testInstagramMediaPagination
{
    XCTestExpectation* expect = [self expectationWithDescription:@"Retrieve Instagram Media Pagination"];
    [MediaDataManager loadMediaFromSource:MediaSourceInstagram pageIndex:0 withBlock:^(NSArray *mediaObjects, MediaResultsPager* pager1, NSError *error) {
        
        XCTAssertNil(error, @"Error occurred retriving instagram media %@", error);
        XCTAssertTrue([mediaObjects isKindOfClass:[NSArray class]], @"invalid media objects array returned %@", mediaObjects);
        for (PhotoViewMediaObject* obj in mediaObjects) {
            XCTAssertTrue([obj isKindOfClass:[PhotoViewMediaObject class]], @"invalid media object returned %@", obj);
        }
        
        XCTAssertNotNil(pager1, @"no pagination object returned");
        XCTAssertTrue([pager1 isKindOfClass:[MediaResultsPager class]], @"invalid pagination object returned");
        XCTAssertEqual([mediaObjects count], kMediaPageSize, @"media count mismatch");

        NSArray* batch1Objects = mediaObjects;
        
        [pager1 loadNextPageData:^(NSArray *mediaObjects, MediaResultsPager *pager, NSError *error) {
            
            XCTAssertNil(error, @"Error occurred retriving instagram media %@", error);
            XCTAssertTrue([mediaObjects isKindOfClass:[NSArray class]], @"invalid media objects array returned %@", mediaObjects);
            for (PhotoViewMediaObject* obj in mediaObjects) {
                XCTAssertTrue([obj isKindOfClass:[PhotoViewMediaObject class]], @"invalid media object returned %@", obj);
                
                //in reality, every time you call the instagram popular image API, it returns a different set of medias, so the test below is only for demostration purpose
                for (PhotoViewMediaObject* batch1Obj in batch1Objects) {
                    XCTAssertFalse([batch1Obj.mediaUrl isEqualToString:obj.mediaUrl], @"duplicate objects returned from paging: %@ => %@", batch1Obj.mediaUrl, obj.mediaUrl);
                }
            }

            [expect fulfill];
            
        }];
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"test timed out %@", error);
        }
    }];
}

-(void) testRetriveFlickrMedia
{
    XCTestExpectation* expect = [self expectationWithDescription:@"Retrieve Instagram Media"];
    [MediaDataManager loadMediaFromSource:MediaSourceFlickr pageIndex:0 withBlock:^(NSArray *mediaObjects, MediaResultsPager* pager, NSError *error) {
        
        XCTAssertNil(error, @"Error occurred retriving flickr media %@", error);
        XCTAssertTrue([mediaObjects isKindOfClass:[NSArray class]], @"invalid media objects array returned %@", mediaObjects);
        for (PhotoViewMediaObject* obj in mediaObjects) {
            XCTAssertTrue([obj isKindOfClass:[PhotoViewMediaObject class]], @"invalid media object returned %@", obj);
        }
        
        [expect fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"test timed out %@", error);
        }
    }];
    
}

-(void) testFlickrMediaPagination
{
    XCTestExpectation* expect = [self expectationWithDescription:@"Retrieve Instagram Media Pagination"];
    [MediaDataManager loadMediaFromSource:MediaSourceFlickr pageIndex:0 withBlock:^(NSArray *mediaObjects, MediaResultsPager* pager1, NSError *error) {
        
        XCTAssertNil(error, @"Error occurred retriving flickr media %@", error);
        XCTAssertTrue([mediaObjects isKindOfClass:[NSArray class]], @"invalid media objects array returned %@", mediaObjects);
        for (PhotoViewMediaObject* obj in mediaObjects) {
            XCTAssertTrue([obj isKindOfClass:[PhotoViewMediaObject class]], @"invalid media object returned %@", obj);
        }
        
        XCTAssertNotNil(pager1, @"no pagination object returned");
        XCTAssertTrue([pager1 isKindOfClass:[MediaResultsPager class]], @"invalid pagination object returned");
        XCTAssertEqual([mediaObjects count], kMediaPageSize, @"media count mismatch");
        
        NSArray* batch1Objects = mediaObjects;
        
        [pager1 loadNextPageData:^(NSArray *mediaObjects, MediaResultsPager *pager, NSError *error) {
            
            XCTAssertNil(error, @"Error occurred retriving flickr media %@", error);
            XCTAssertTrue([mediaObjects isKindOfClass:[NSArray class]], @"invalid media objects array returned %@", mediaObjects);
            for (PhotoViewMediaObject* obj in mediaObjects) {
                XCTAssertTrue([obj isKindOfClass:[PhotoViewMediaObject class]], @"invalid media object returned %@", obj);
                
                for (PhotoViewMediaObject* batch1Obj in batch1Objects) {
                    XCTAssertFalse([batch1Obj.mediaUrl isEqualToString:obj.mediaUrl], @"duplicate objects returned from paging: %@ => %@", batch1Obj.mediaUrl, obj.mediaUrl);
                }
            }
            
            [expect fulfill];
            
        }];
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if (error) {
            XCTFail(@"test timed out %@", error);
        }
    }];
}


@end
