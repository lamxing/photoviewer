//
//  PhotoViewObjectTableViewCell.m
//  PhotoViewer
//
//  Created by Chris on 10/5/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#import "PhotoViewObjectTableViewCell.h"
#import "PhotoViewMediaObject.h"
#import "UIImageView+AFNetworking.h"

@interface PhotoViewObjectTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView* imageViewBackground;
@property (nonatomic, weak) IBOutlet UIImageView* imageViewTypeIcon;
@property (nonatomic, weak) IBOutlet UILabel* labelCaption;

@end

@implementation PhotoViewObjectTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    if (self.mediaObject) {
        [self configCell];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setMediaObject:(PhotoViewMediaObject *)mediaObject
{
    _mediaObject = mediaObject;
    [self configCell];
    
}

-(void) configCell
{
    [self.imageViewBackground setImageWithURL:[NSURL URLWithString:self.mediaObject.thumbnailUrl]];
    self.labelCaption.text = self.mediaObject.mediaCaption;
    self.imageViewTypeIcon.image = self.mediaObject.type == MediaObjectTypePhoto ? [UIImage imageNamed:@"icon_image"] : [UIImage imageNamed:@"icon_video"];
}


-(void) prepareForReuse
{
    [super prepareForReuse];
    self.imageViewBackground.image = nil;
    self.labelCaption.text = nil;
    self.imageViewTypeIcon.image = nil;
}

@end
