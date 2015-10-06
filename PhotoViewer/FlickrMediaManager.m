//
//  FlickrMediaManager.m
//  PhotoViewer
//
//  Created by Chris on 10/6/15.
//  Copyright © 2015 Chris. All rights reserved.
//

#import "FlickrMediaManager.h"
#import "AFNetworking.h"
#import "FlickrResponseData.h"
#import "Constants.h"

/**
 *  Hardcoding Flickr API Endpoint with APIKey for simplicity
 */
static NSString* const kFlickrAPIEndPoint = @"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=78d50fdb1a8d8b061ad033d7bdf83bbb";

@implementation FlickrMediaManager

+(void) loadPopularFlickrImageStartingFromPage:(NSInteger) page resultsBlock:(void(^)(FlickrResponseData* data, NSError* error)) results
{
    //flickr paging starts at 1
    page += 1;
    NSString* requestEndPoint = [NSString stringWithFormat:@"%@&page=%ld&per_page=%ld&format=json&nojsoncallback=1", kFlickrAPIEndPoint, page,  kMediaPageSize];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestEndPoint]];
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFHTTPRequestOperation* op = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"flickr response: %@", responseObject);
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            results(nil, [NSError errorWithDomain:PhotoViewErrorDomain code:ERROR_CODE_INVALID_RESPONSE userInfo:@{NSLocalizedDescriptionKey : @"Invalid response from Flickr"}]);
            return ;
        }
        
        if (![[responseObject[@"stat"] lowercaseString] isEqualToString:@"ok"] ) {
            results(nil, [NSError errorWithDomain:PhotoViewErrorDomain code:ERROR_CODE_INVALID_RESPONSE userInfo:@{NSLocalizedDescriptionKey : @"Invalid response from Flickr"}]);
            return ;
        }
        
        FlickrResponseData* response = [FlickrResponseData responseDataFromDictionary:responseObject];
        results(response, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error occurred getting flickr media %@", error);
        results(nil, error);
        
    }];

    [op start];
    
}

@end
