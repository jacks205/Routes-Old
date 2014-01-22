//
//  CustomSwipeCell.m
//  NavTrac
//
//  Created by Mark Jackson on 1/21/14.
//  Copyright (c) 2014 Mark Jackson. All rights reserved.
//


#import "CustomSwipeCell.h"


NSString *const CustomSwipeCellEnclosingTableViewDidBeginScrollingNotification = @"CustomSwipeCellEnclosingTableViewDidScrollNotification";

#define kCatchWidth 180

@interface CustomSwipeCell () <UIScrollViewDelegate>

@end

@implementation CustomSwipeCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup {
    // Set up our contentView hierarchy
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kCatchWidth, CGRectGetHeight(self.bounds));
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIView *scrollViewButtonView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kCatchWidth, 0, kCatchWidth, CGRectGetHeight(self.bounds))];
    self.scrollViewButtonView = scrollViewButtonView;
    [self.scrollView addSubview:scrollViewButtonView];
    
    // Set up our two buttons
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f];
    moreButton.frame = CGRectMake(0, 0, kCatchWidth / 2.0f, CGRectGetHeight(self.bounds));
    [moreButton setTitle:@"More" forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(userPressedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewButtonView addSubview:moreButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
    deleteButton.frame = CGRectMake(kCatchWidth / 2.0f, 0, kCatchWidth / 2.0f, CGRectGetHeight(self.bounds));
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(userPressedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewButtonView addSubview:deleteButton];
    
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    scrollViewContentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    // Address Label
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake( 20, 20, 122, 21), 0, 0)];
    [addressLabel setFont:[UIFont systemFontOfSize:14]];
    self.addressLabel = addressLabel;
    [self.scrollViewContentView addSubview:addressLabel];
    
    // Address Label
    UILabel *cityStateLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake( 20, 37, 122, 21), 0, 0)];
    [cityStateLabel setFont:[UIFont systemFontOfSize:14]];
    self.cityStateLabel = cityStateLabel;
    [self.scrollViewContentView addSubview:cityStateLabel];
    
    // Address Label
    UILabel *zipcodeLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake( 20, 54, 122, 21), 0, 0)];
    [zipcodeLabel setFont:[UIFont systemFontOfSize:14]];
    self.zipcodeLabel = zipcodeLabel;
    [self.scrollViewContentView addSubview:zipcodeLabel];
    
    
    
    // Fixed Labels
    UILabel *distanceConst = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake( 168, 20, 57, 21), 0, 0)];
    distanceConst.text = @"Distance:";
    [distanceConst setFont:[UIFont systemFontOfSize:13]];
    [self.scrollViewContentView addSubview:distanceConst];
    UILabel *timeConst = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake( 150, 54, 75, 21), 0, 0)];
    timeConst.text = @"Travel Time:";
    [timeConst setFont:[UIFont systemFontOfSize:13]];
    [self.scrollViewContentView addSubview:timeConst];
    
    // Distance Label
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake( 233, 20, 87, 21), 0, 0)];
    [distanceLabel setFont:[UIFont systemFontOfSize:17]];
    self.distanceLabel = distanceLabel;
    [self.scrollViewContentView addSubview:distanceLabel];
    
    // Travel Time Label
    UILabel *travelTimeLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake( 233, 54, 87, 21), 0, 0)];
    [travelTimeLabel setFont:[UIFont systemFontOfSize:17]];
    self.travelTimeLabel = travelTimeLabel;
    [self.scrollViewContentView addSubview:travelTimeLabel];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enclosingTableViewDidScroll) name:CustomSwipeCellEnclosingTableViewDidBeginScrollingNotification  object:nil];
}

-(void)enclosingTableViewDidScroll {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - Private Methods

-(void)userPressedDeleteButton:(id)sender {
    [self.delegate cellDidSelectDelete:self];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

-(void)userPressedMoreButton:(id)sender {
    [self.delegate cellDidSelectMore:self];
}

#pragma mark - Overridden Methods

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kCatchWidth, CGRectGetHeight(self.bounds));
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.scrollViewButtonView.frame = CGRectMake(CGRectGetWidth(self.bounds) - kCatchWidth, 0, kCatchWidth, CGRectGetHeight(self.bounds));
    self.scrollViewContentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    [self.scrollView setContentOffset:CGPointZero animated:NO];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.scrollView.scrollEnabled = !self.editing;
    
    // Corrects effect of showing the button labels while selected on editing mode (comment line, build, run, add new items to table, enter edit mode and select an entry)
    self.scrollViewButtonView.hidden = editing;
    
    NSLog(@"%d", editing);
}

-(UILabel *)textLabel {
    // Kind of a cheat to reduce our external dependencies
    return self.addressLabel;
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (scrollView.contentOffset.x > kCatchWidth) {
        targetContentOffset->x = kCatchWidth;
    }
    else {
        *targetContentOffset = CGPointZero;
        
        // Need to call this subsequently to remove flickering. Strange.
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointZero animated:YES];
        });
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < 0) {
        scrollView.contentOffset = CGPointZero;
    }
    
    self.scrollViewButtonView.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - kCatchWidth), 0.0f, kCatchWidth, CGRectGetHeight(self.bounds));
}

@end

#undef kCatchWidth
