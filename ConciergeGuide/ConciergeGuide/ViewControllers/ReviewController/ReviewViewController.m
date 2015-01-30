//
//  ReviewViewController.m
//  StoreFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "ReviewViewController.h"
#import "ZoomAnimationController.h"
#import "NewReviewViewController.h"

#define kReviewCell @"ReviewCell"
#define kReviewLoadMoreCell @"ReviewLoadMoreCell"

@interface ReviewViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate, ReviewDelegate> {
    
    NSMutableArray* _arrayData;
    int _reviewCount;
    int _requestCount;
    int _returnCount;
    int _totalRowCount;
    UIRefreshControl* _refreshControl;
}

@property (nonatomic, strong) id<MGAnimationController> animationController;

@end

@implementation ReviewViewController

@synthesize listViewMain;
@synthesize store;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [MGUIAppearance createLogo:HEADER_LOGO];
    self.view.backgroundColor = BG_VIEW_COLOR;
    
    [MGUIAppearance enhanceNavBarController:self.navigationController
                               barTintColor:WHITE_TEXT_COLOR
                                  tintColor:WHITE_TEXT_COLOR
                             titleTextColor:WHITE_TEXT_COLOR];
    
    listViewMain.delegate = self;
    listViewMain.dataSource = self;
    
    [listViewMain registerNib:[UINib nibWithNibName:kReviewCell bundle:nil]
       forCellReuseIdentifier:kReviewCell];
    
    [listViewMain registerNib:[UINib nibWithNibName:kReviewLoadMoreCell bundle:nil]
       forCellReuseIdentifier:kReviewLoadMoreCell];
    
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = THEME_BLACK_TINT_COLOR;
    
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [listViewMain addSubview:_refreshControl];
    
    
    UIBarButtonItem* itemMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_NEW_REVIEW]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(didClickNewMsg:)];
    self.navigationItem.rightBarButtonItem = itemMenu;
    
    
    
    _reviewCount = MAX_REVIEW_COUNT_PER_LISTING;
    if(![MGUtilities hasInternetConnection]) {
        
        [MGUtilities showAlertTitle:LOCALIZED(@"NETWORK_ERROR")
                            message:LOCALIZED(@"NETWORK_ERROR_DETAILS")];
    }
    else {
        [self beginParsing];
    }
}

-(IBAction)didClickButtonClose:(id)sender {
    [self.slidingViewController resetTopViewAnimated:NO];
}


-(void)beginParsing {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"LOADING");
    
    [self.view addSubview:hud];
	
    [self.view setUserInteractionEnabled:NO];
	[hud showAnimated:YES whileExecutingBlock:^{
        
		[self downloadReviews];
        
	} completionBlock:^{
        
		[hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        [listViewMain reloadData];
        
        if(_arrayData == nil || _arrayData.count == 0) {
            
            UIColor* color = [THEME_ORANGE_COLOR colorWithAlphaComponent:0.70];
            [MGUtilities showStatusNotifier:LOCALIZED(@"NO_RESULTS")
                                  textColor:[UIColor whiteColor]
                             viewController:self
                                   duration:0.5f
                                    bgColor:color
                                        atY:64];
        }
	}];
    
}

-(void)downloadReviews {
    
    NSString* reviewUrl = [NSString stringWithFormat:@"%@?count=%d&store_id=%@", REVIEWS_URL, _reviewCount, store.store_id];
    NSDictionary* dict = [MGParser getJSONAtURL:reviewUrl];
    
    if(_arrayData == nil)
        _arrayData = [NSMutableArray new];
    
    [_arrayData removeAllObjects];
    
    if(dict != nil) {
        
        _requestCount = [[dict valueForKey:@"request_count"] intValue];
        _returnCount = [[dict valueForKey:@"return_count"] intValue];
        _totalRowCount = [[dict valueForKey:@"total_row_count"] intValue];
        
        NSDictionary* dictEntry = [dict objectForKey:@"reviews"];
        
        if(dictEntry != nil && dictEntry.count > 0) {
            for(NSDictionary* dict in dictEntry) {
                [_arrayData addObject:dict];
            }
        }
    }
    
    if(_returnCount < _totalRowCount) {
        [_arrayData insertObject:@"" atIndex:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _arrayData.count;
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0 && _returnCount < _totalRowCount) {
        _reviewCount += MAX_REVIEW_COUNT_PER_LISTING;
        [self beginParsing];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGListCell* cell;
    
    if(indexPath.row == 0 && _returnCount < _totalRowCount) {
        cell = [tableView dequeueReusableCellWithIdentifier:kReviewLoadMoreCell];
        
        if(cell != nil) {
            
            int remaining = _totalRowCount - _returnCount;
            NSString* strRemaining = [NSString stringWithFormat:@"%@ %d %@",
                                      LOCALIZED(@"REVIEW_VIEW"),
                                      remaining,
                                      LOCALIZED(@"REVIEW_COMMENTS")];
            
            cell.labelInfo.text = strRemaining;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.labelTitle.textColor = THEME_BLACK_TINT_COLOR;
        }
        
    }
    
    else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:kReviewCell];
        
        if(cell != nil) {
            NSDictionary* dict = [_arrayData objectAtIndex:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            [cell.labelTitle setText:dict[@"full_name"]];
            cell.labelTitle.textColor = THEME_BLACK_TINT_COLOR;
            
            double createdAt = [dict[@"created_at"] doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
            NSString *formattedDateString = [dateFormatter stringFromDate:date];
            [cell.labelSubtitle setText:formattedDateString];
            cell.labelSubtitle.textColor = REVIEW_DATE_TEXT_COLOR;
            
            
//            NSString* review = [dict[@"review"] stringByDecodingHTMLEntities];
//            
//            NSArray* arr = @[
//                             @{@"ascii" : @"&amp;", @"val" : @"&"},
//                             @{@"ascii" : @"&quot;", @"val" : @"\""},
//                             @{@"ascii" : @"&apos;", @"val" : @"`"},
//                             @{@"ascii" : @"&lt;", @"val" : @"<"},
//                             @{@"ascii" : @"&gt;", @"val" : @">"},
//                             ];
//            
//            for(NSDictionary* dict in arr) {
//                
//                review = [review stringByReplacingOccurrencesOfString:dict[@"ascii"]
//                                                           withString:dict[@"val"]];
//            }
            
            NSString* review1 = [dict[@"review"] stringByDecodingHTMLEntities];
            NSString* review2 = [review1 stringByDecodingHTMLEntities];
            
//            review1 = [review2 decodeFromPercentEscapeString:review2];
            
            [cell.labelDescription setText:review2];
            
            
            CGSize size = [cell.labelDescription sizeOfMultiLineLabel];
            CGRect frame = cell.labelDescription.frame;
            cell.labelDescription.frame = frame;
            
            float totalHeightLabel = size.height + frame.origin.y + (18);
            
            if(totalHeightLabel > cell.frame.size.height) {
                frame.size.height = size.height;
                cell.labelDescription.frame = frame;
                
                CGRect cellFrame = cell.frame;
                cellFrame.size.height = totalHeightLabel + cell.frame.size.height;
                cell.frame = cellFrame;
            }
            else {
                
                frame.size.height = size.height;
                cell.labelDescription.frame = frame;
            }
            
            
            
            [self setImage:dict[@"thumb_url"] imageView:cell.imgViewThumb];
        }
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    float height = 40;
    
    if(indexPath.row == 0 && _returnCount < _totalRowCount) {
        return height;
    }
    
    else {
        MGListCell* cell = [tableView dequeueReusableCellWithIdentifier:kReviewCell];
        
        NSDictionary* dict = [_arrayData objectAtIndex:indexPath.row];
        
        NSString* review1 = [dict[@"review"] stringByConvertingHTMLToPlainText];
        NSString* review2 = [review1 stringByConvertingHTMLToPlainText];
        
        [cell.labelDescription setText:review2];
        cell.backgroundColor = [UIColor clearColor];
        
        CGSize size = [cell.labelDescription sizeOfMultiLineLabel];
        CGRect frame = cell.labelDescription.frame;
        CGRect cellFrame = cell.frame;
        
        float totalHeightLabel = size.height + frame.origin.y + (18);
        
        if(totalHeightLabel > cell.frame.size.height) {
            frame.size = size;
            cell.labelDescription.frame = frame;
            
            float heightDiff = totalHeightLabel - cell.frame.size.height;
            
            cellFrame.size.height += heightDiff;
            cell.frame = cellFrame;
        }
        
        height =  cell.frame.size.height;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MGListCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:REVIEW_THUMB_PLACEHOLDER_IMAGE];
    
    [MGUtilities createBorders:weakImgRef
                   borderColor:THEME_BLACK_TINT_COLOR
                   shadowColor:[UIColor clearColor]
                   borderWidth:4.0f
                  borderRadius:35.0f];
    
    [imgView setImageWithURLRequest:urlRequest
                   placeholderImage:imgPlaceholder
                            success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                
                                CGSize size = weakImgRef.frame.size;
                                
                                if([MGUtilities isRetinaDisplay]) {
                                    size.height *= 2;
                                    size.width *= 2;
                                }
                                
                                UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
                                weakImgRef.image = croppedImage;
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                                
                            }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.animationController.isPresenting = YES;
    
    return self.animationController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animationController.isPresenting = NO;
    
    return self.animationController;
}

-(void)didClickNewMsg:(id)sender {
    
    UserSession* userSession = [UserAccessSession getUserSession];
    if(userSession == nil) {
        [MGUtilities showAlertTitle:LOCALIZED(@"LOGIN_ERROR")
                            message:LOCALIZED(@"LOGIN_ERROR_USER_NOT_SIGNED_RATING_DETAILS")];
        
        return;
    }
    
    NewReviewViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardNewReview"];
    controller.reviewDelegate = self;
    controller.store = store;
    
    self.animationController = [[ZoomAnimationController alloc] init];
    controller.transitioningDelegate  = self;
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)didReceiveNewReview:(NSDictionary *)dict {
    
    [self beginParsing];
    
}

-(void)refresh:(id)sender {
    
    [_refreshControl endRefreshing];
    _reviewCount = MAX_REVIEW_COUNT_PER_LISTING;
    [self beginParsing];
}

@end
