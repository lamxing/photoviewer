//
//  ViewController.m
//  PhotoViewer
//
//  Created by Chris on 10/4/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#import "ViewController.h"
#import "PhotoViewMediaObject.h"
#import "MediaDataManager.h"
#import "MediaResultsPager.h"
#import "PhotoViewObjectTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableViewInstagram;
@property (nonatomic, weak) IBOutlet UITableView* tableViewFlickr;
@property (nonatomic, weak) IBOutlet UISegmentedControl* segmentedControl;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* constraintInstagramTableViewLeadingSpace;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* constraintDetailViewHeight;
@property (nonatomic, weak) IBOutlet UIImageView* imageViewDetail;

@property (nonatomic, strong) NSMutableArray* mediasInstagram;
@property (nonatomic, strong) NSMutableArray* mediasFlickr;
@property (nonatomic, strong) MediaResultsPager* pagerForInstagram;
@property (nonatomic, strong) MediaResultsPager* pagerForFlickr;
@property (nonatomic, strong) UIRefreshControl* refreshControlInstagram;
@property (nonatomic, strong) UIRefreshControl* refreshControlFlickr;

@end

@implementation ViewController

#pragma mark - View Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //setup pull to refresh
    self.refreshControlInstagram = [[UIRefreshControl alloc] init];
    [self.refreshControlInstagram addTarget:self action:@selector(reloadInstagramTable) forControlEvents:UIControlEventValueChanged];
    [self.tableViewInstagram addSubview:self.refreshControlInstagram];
    
    self.refreshControlFlickr = [[UIRefreshControl alloc] init];
    [self.refreshControlFlickr addTarget:self action:@selector(reloadFlickrTable) forControlEvents:UIControlEventValueChanged];
    [self.tableViewFlickr addSubview:self.refreshControlFlickr];
    
    [self reloadInstagramTable];
    [self reloadFlickrTable];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Loading

-(void) reloadInstagramTable
{
    [MediaDataManager loadMediaFromSource:MediaSourceInstagram pageIndex:0 withBlock:^(NSArray *mediaObjects, MediaResultsPager *pager, NSError *error) {
        
        if (error || !mediaObjects) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Unable to load media from Instagram" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return ;
        }
        
        self.pagerForInstagram = pager;
        self.mediasInstagram = mediaObjects.mutableCopy;
        [self.tableViewInstagram reloadData];
        [self.refreshControlInstagram endRefreshing];
        
    }];

}

-(void) reloadFlickrTable
{
    [MediaDataManager loadMediaFromSource:MediaSourceFlickr pageIndex:0 withBlock:^(NSArray *mediaObjects, MediaResultsPager *pager, NSError *error) {
        
        if (error || !mediaObjects) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Unable to load media from Flickr" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return ;
        }
        
        self.pagerForFlickr = pager;
        self.mediasFlickr = mediaObjects.mutableCopy;
        [self.tableViewFlickr reloadData];
        [self.refreshControlFlickr endRefreshing];
        
    }];
}

#pragma mark - SegmentedControl Action

/**
 *  Switch between Instagram and Flickr media list
 *
 *
 */
-(IBAction) segmentedControlDidChange:(id)sender
{
    if (self.segmentedControl.selectedSegmentIndex == 0 && self.constraintInstagramTableViewLeadingSpace.constant < 0) {
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.constraintInstagramTableViewLeadingSpace.constant = 0;
            [self.view layoutIfNeeded];
            
        } completion:nil];
        
        
    }else if(self.constraintInstagramTableViewLeadingSpace.constant == 0)
    {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.constraintInstagramTableViewLeadingSpace.constant = -self.tableViewInstagram.frame.size.width;
            [self.view layoutIfNeeded];

        } completion:nil];
    }
}

/**
 *  Hides the zoomed in image detail view and show the media list table again
 *
 *
 */
-(IBAction) hideDetailView:(id)sender
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.constraintDetailViewHeight.constant = 0;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        self.imageViewDetail.image = nil;
        
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MediaResultsPager* pager = tableView == self.tableViewInstagram ? self.pagerForInstagram : self.pagerForFlickr;
    NSArray* objects = tableView == self.tableViewInstagram ? self.mediasInstagram : self.mediasFlickr;
    
    //if pager object exist, return object count + 1 to include loading cell
    NSInteger count = pager == nil ? [objects count ]: [objects  count] + 1;
    return count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1. determine which table is calling and choose the correct data source to retrieve from
    NSArray* data = nil;
    MediaResultsPager* pager = nil;
    if (tableView == self.tableViewInstagram) {
        data = self.mediasInstagram;
        pager = self.pagerForInstagram;
    }else
    {
        data = self.mediasFlickr;
        pager = self.pagerForFlickr;
    }
    
    //2. loading cell is requested, load next page and return loading cell
    if (indexPath.row >= [data count]) {
        if (!pager.loadingNextPage) {
            __weak typeof (self) weakSelf = self;
            [pager loadNextPageData:^(NSArray *mediaObjects, MediaResultsPager *pager, NSError *error) {
                __strong typeof (self) strongSelf = weakSelf;
                
                NSMutableArray* targetArray = nil;
                if (tableView == self.tableViewInstagram) {
                    
                    strongSelf.pagerForInstagram = pager;
                    targetArray = self.mediasInstagram;
                    
                }else
                {
                    strongSelf.pagerForFlickr = pager;
                    targetArray = self.mediasFlickr;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!mediaObjects || error) {
                        [tableView beginUpdates];
                        [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:targetArray.count inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [tableView endUpdates];
                        return ;
                    }
                    
                    [targetArray addObjectsFromArray:mediaObjects];
                    [tableView reloadData];
                    
                });
                
            }];
        }
        
        return [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
    }
    
    //3. normal cell is requested, return configured cell
    PhotoViewMediaObject* obj = data[indexPath.row];
    PhotoViewObjectTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PhotoViewObjectTableViewCell class]) forIndexPath:indexPath];
    cell.mediaObject = obj;
    return cell;
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![cell isKindOfClass:[PhotoViewObjectTableViewCell class]]) {
        return;
    }
    
    //if the media is picture, show zoomed in picture
    PhotoViewMediaObject* obj = [((PhotoViewObjectTableViewCell*) cell) mediaObject];
    if (obj.type == MediaObjectTypePhoto) {
        [self.imageViewDetail setImageWithURL:[NSURL URLWithString:obj.mediaUrl]];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.constraintDetailViewHeight.constant = self.view.frame.size.height;
            [self.view layoutIfNeeded];
            
        } completion:nil];
        
    }else
    {
        //otherwise play video
        AVPlayer* avplayer = [AVPlayer playerWithURL:[NSURL URLWithString:obj.mediaUrl]];
        AVPlayerViewController* avplayerVC = [AVPlayerViewController new];
        avplayerVC.player = avplayer;
        [self presentViewController:avplayerVC animated:YES completion:^{
            [avplayer play];
        }];
    }
}

@end
