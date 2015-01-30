//
//  ContentViewController.m
//  ItemFinder
//
//
//  Copyright (c) 2014 Mangasaur Games. All rights reserved.
//

#import "ContentViewController.h"
#import "AppDelegate.h"
#import "NewsDetailViewController.h"
#import "DetailViewController.h"

@interface ContentViewController () <MGSliderDelegate, MGListViewDelegate>

@property (nonatomic, retain) NSArray* arrayFeatured;

@end

@implementation ContentViewController

@synthesize slider;
@synthesize listViewNews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if(slider != nil)
        [slider resumeAnimation];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if(slider != nil)
        [slider stopAnimation];
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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    slider.nibName = @"SliderView";
    slider.delegate = self;
    
    BOOL screen = IS_IPHONE_6_PLUS_AND_ABOVE;
    
    if(screen) {
        CGRect frame = slider.frame;
        frame.size.width = self.view.frame.size.width;
        frame.size.height = 230;
        slider.frame = frame;
        
        frame = listViewNews.frame;
        frame.origin.y = slider.frame.origin.y + slider.frame.size.height;
        frame.size.height = self.view.frame.size.height - slider.frame.size.height-64;
        listViewNews.frame = frame;
    }
    
    listViewNews.delegate = self;
    
    listViewNews.cellHeight = screen ? 240 : 180;
    
    [listViewNews registerNibName:@"NewsCell" cellIndentifier:@"NewsCell"];
    [listViewNews baseInit];
    
    [self beginParsing];
    
    UIBarButtonItem* itemMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_MENU]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(didClickBarButtonMenu:)];
    self.navigationItem.leftBarButtonItem = itemMenu;
    
    if(SHOW_ADS_MAIN_VIEW) {
        [MGUtilities createAdAtY:self.view.frame.size.height - AD_BANNER_HEIGHT
                  viewController:self
                         bgColor:AD_BG_COLOR];
        
        UIEdgeInsets inset = listViewNews.tableView.contentInset;
        inset.bottom = ADV_VIEW_OFFSET;
        listViewNews.tableView.contentInset = inset;
        
        inset = listViewNews.tableView.scrollIndicatorInsets;
        inset.bottom = ADV_VIEW_OFFSET;
        listViewNews.tableView.scrollIndicatorInsets = inset;
        
        NSLog(@"%@", NSStringFromCGRect(listViewNews.tableView.frame));
        
    }
}

-(void)didClickBarButtonMenu:(id)sender {
    
    AppDelegate* delegate = [AppDelegate instance];
    [delegate.sideViewController updateUI];
    
    
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)beginParsing {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = LOCALIZED(@"LOADING");
    
    [self.view addSubview:hud];
    [self.view setUserInteractionEnabled:NO];
	[hud showAnimated:YES whileExecutingBlock:^{
        
		[self performParsing];
        
	} completionBlock:^{
        
		[hud removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        [self setData];
        [listViewNews reloadData];
	}];
    
}

-(void) performParsing {
    
    [DataParser fetchServerData];
}


-(void) setData {
    
    self.arrayFeatured = [CoreDataController getFeaturedStores];
    slider.numberOfItems = self.arrayFeatured.count;
    
    [slider setNeedsReLayoutWithViewSize:CGSizeMake(self.view.frame.size.width, slider.frame.size.height)];
    [slider startAnimationWithDuration:4.0f];
//    [slider showPageControl:YES];
    
    listViewNews.arrayData = [NSMutableArray arrayWithArray:[CoreDataController getNews]];
    
}

-(void)MGSlider:(MGSlider *)slider didCreateSliderView:(MGRawView *)rawView atIndex:(int)index {
    
    Store* store = self.arrayFeatured[index];
    Photo* p = [CoreDataController getStorePhotoByStoreId:store.store_id];
    
    rawView.label1.backgroundColor = [BLACK_TEXT_COLOR colorWithAlphaComponent:0.66];
    
    rawView.labelTitle.textColor = WHITE_TEXT_COLOR;
    rawView.labelSubtitle.textColor = WHITE_TEXT_COLOR;
    
    rawView.labelTitle.text = store.store_name;
    rawView.labelSubtitle.text = store.store_address;
    
    if(p != nil)
        [self setImage:p.photo_url imageView:rawView.imgViewPhoto];
    
    rawView.buttonGo.object = store;
    [rawView.buttonGo addTarget:self
                         action:@selector(didClickButtonGo:)
               forControlEvents:UIControlEventTouchUpInside];

}

-(void)didClickButtonGo:(id)sender {
    
    MGButton* button = (MGButton*)sender;
    DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardDetail"];
    vc.store = button.object;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)MGSlider:(MGSlider *)slider didSelectSliderView:(MGRawView *)rawView atIndex:(int)index {
    
}

-(void)MGSlider:(MGSlider *)slider didPageControlClicked:(UIButton *)button atIndex:(int)index {
    
}

-(void)setImage:(NSString*)imageUrl imageView:(UIImageView*)imgView {
    
    NSURL* url = [NSURL URLWithString:imageUrl];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    
    __weak typeof(imgView ) weakImgRef = imgView;
    UIImage* imgPlaceholder = [UIImage imageNamed:SLIDER_PLACEHOLDER];
    
    [imgView setImageWithURLRequest:urlRequest
                   placeholderImage:imgPlaceholder
                            success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
                                
                                CGSize size = weakImgRef.frame.size;
                                
                                if([MGUtilities isRetinaDisplay]) {
                                    size.height *= 2;
                                    size.width *= 2;
                                }
                                
                                if(IS_IPHONE_6_PLUS_AND_ABOVE) {
                                    size.height *= 3;
                                    size.width *= 3;
                                }
                                
                                UIImage* croppedImage = [image imageByScalingAndCroppingForSize:size];
                                weakImgRef.image = croppedImage;
                                
                            } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                
                            }];
}

-(void) MGListView:(MGListView *)_listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    News* news = [listViewNews.arrayData objectAtIndex:indexPath.row];
    
    NewsDetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"storyboardNewsDetail"];
    vc.strUrl = news.news_url;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCell*)MGListView:(MGListView *)listView1 didCreateCell:(MGListCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    if(cell != nil) {
        News* news = [listViewNews.arrayData objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedColor = THEME_ORANGE_COLOR;
        cell.unSelectedColor = THEME_ORANGE_COLOR;
        cell.labelExtraInfo.backgroundColor = [BLACK_TEXT_COLOR colorWithAlphaComponent:0.66];
        cell.labelDetails.backgroundColor = [BLACK_TEXT_COLOR colorWithAlphaComponent:0.66];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.labelTitle setText:news.news_title];
        [cell.labelSubtitle setText:news.news_content];
        
        double createdAt = [news.created_at doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        [cell.labelDetails setText:formattedDateString];
        cell.labelDetails.textColor = THEME_ORANGE_COLOR;
        
        if(news.photo_url != nil)
            [self setImage:news.photo_url imageView:cell.imgViewThumb];
        else
            [self setImage:nil imageView:cell.imgViewThumb];
        
        [MGUtilities createBorders:cell.imgViewThumb
                       borderColor:THEME_BLACK_TINT_COLOR
                       shadowColor:[UIColor clearColor]
                       borderWidth:CELL_BORDER_WIDTH];
    }
    
    return cell;
}

-(void)MGListView:(MGListView *)listView scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
