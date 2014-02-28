//
//  FeedVC.m
//  chooseme
//
//  Created by Jenny Kwan on 2/7/14.
//  Copyright (c) 2014 Jenny Kwan. All rights reserved.
//

#import "FeedVC.h"
#import "FeedCell.h"
#import "Question.h"
#import "PostVC.h"
#import "UIImage+mask.h"

@interface FeedVC ()

@property (nonatomic, strong) NSMutableArray *questions;

// View elements
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *feedView;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIButton *otherButton;
@property (strong, nonatomic) IBOutlet UILabel *plusLabel;
@property (strong, nonatomic) IBOutlet UIView *statsView;
@property (strong, nonatomic) IBOutlet UILabel *numQuestions;
@property (strong, nonatomic) IBOutlet UILabel *numVotes;
@property (strong, nonatomic) IBOutlet UILabel *numFriends;

// Button actions
- (IBAction)goToCamera:(id)sender;
- (IBAction)onOtherButton:(id)sender;

// Private user data
@property (strong, nonatomic) NSString *myFacebookID;
@property (strong, nonatomic) NSString *myName;
@property (strong, nonatomic) UIImage *myPic;

@property (nonatomic, assign) BOOL hiddenTitleView;
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, assign) BOOL scrollingDown;

@property (nonatomic, assign) CGRect origTitleFrame;
@property (nonatomic, assign) CGRect origStatsFrame;
@property (nonatomic, assign) CGRect origTableFrame;
@property (nonatomic, assign) CGRect newTitleFrame;
@property (nonatomic, assign) CGRect newStatsFrame;
@property (nonatomic, assign) CGRect newTableFrame;

- (void) loadQuestionsArray:(NSString *)facebookId;
@end

@implementation FeedVC 

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
    // Do any additional setup after loading the view from its nib.

    NSLog(@"FeedVC viewDidLoad %d", [self isMe]);
    // Set up feed view
    [self.feedView registerNib:[UINib nibWithNibName:@"FeedCell" bundle:nil] forCellReuseIdentifier:@"FeedCell"];
    self.feedView.dataSource = self;
    self.feedView.delegate = self;
    
    if ([self isMe])
        self.titleLabel.text = @"MY QUESTIONS";
    else
        self.titleLabel.text = @"FRIENDS' QUESTIONS";
    
    self.view.backgroundColor = [UIColor colorWithRed:0.329 green:0.733 blue:0.616 alpha:1];
    self.titleView.backgroundColor = [UIColor colorWithRed:0.329 green:0.733 blue:0.616 alpha:1];
    
    [self.cameraButton setImage:[[UIImage imageNamed:@"86-camera.png"] maskWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    if ([self isMe]) {
        [self.otherButton setImage:[[UIImage imageNamed:@"19-gear.png"] maskWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        self.plusLabel.hidden = YES;
    } else
        [self.otherButton setImage:[[UIImage imageNamed:@"111-user.png"] maskWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];

    
    self.origTitleFrame = self.titleView.frame;
    self.origStatsFrame = self.statsView.frame;
    self.origTableFrame = self.feedView.frame;
    
    // Don't show lines below available cells
    self.feedView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Refresh control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshMe:) forControlEvents:UIControlEventValueChanged];
    [self.feedView addSubview:refresh];
    
    // Load my data
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            self.myFacebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", self.myFacebookID]];
            
            // Assign the data accordingly
            self.myName = name;
            self.myPic = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
            
            // load the questions array
            [self loadQuestionsArray:self.myFacebookID];
            
        }
    }];
    
    // Load friends' data
}

// This is called after the view has laid out its subviews
- (void)viewDidLayoutSubviews {
    
    // Hide stats view for friends' questions page
    if ([self isFriends]) {
        [self hideStatsBar];
        self.origStatsFrame = self.statsView.frame;
        self.origTableFrame = self.feedView.frame;
    }
    
//    NSLog(@"viewDidLayoutSubviews");
}

- (void)viewWillAppear:(BOOL)animated
{
    self.titleView.alpha = 1;
}

- (void) loadQuestionsArray:(NSString *)facebookId {
    if ([self isMe]) {
        PFQuery *query = [Question query];
        // FIXME: Newest posts on top for now.. Eventually, custom order by recently edited or unresolved
        [query orderByDescending:@"createdAt"];
        [query whereKey:@"author" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.questions = [objects mutableCopy];
            [self.feedView reloadData];
            self.numQuestions.text = [NSString stringWithFormat:@"%d", self.questions.count];
        }];
    } else {
        // FIXME: this is NOT performant
        PFQuery *query = [Question query];
        self.questions = [[NSMutableArray alloc] init];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            for (Question* question in [[objects reverseObjectEnumerator] allObjects]) {
                for (int i = 0; i < question.friends.count; i++) {
                    NSDictionary *friend = [question.friends objectAtIndex:i];
                    if ([friend[@"id"] isEqualToString:facebookId]) {
                        question.myVoteIndex = i;
                        [self.questions addObject:question];
                        continue;
                    }
                }
            }
            
            [self.feedView reloadData];
        }];
    }
    
}

# pragma mark - actions from button presses

- (IBAction)goToCamera:(id)sender {
    if ([self isMe])
        [self.delegate previousPage:self.index];
    else
        [self.delegate nextPage:self.index];
}

- (IBAction)onOtherButton:(id)sender {
    NSLog(@"Other button pressed");
}

#pragma mark - TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self isMe])
        return self.questions.count+1;
    else
        return self.questions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    Question *q;
    
    if ([self isMe] && indexPath.row == 0)
        return 40;
    else {
        if ([self isMe])
            q = self.questions[indexPath.row-1];
        else
            q = self.questions[indexPath.row];
        
        if (q.question != nil)
            height = [self textViewHeightForAttributedText:[[NSAttributedString alloc] initWithString:q.question] andWidth:240];
        else
            height = 0;
        if (height > 0) {
            return height + 200;
        } else
            return 220;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isMe] && indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"+ Add a Question";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else {
        static NSString *CellIdentifier = @"FeedCell";
        FeedCell *cell = (FeedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        Question *q;
        if ([self isMe])
            q = self.questions[indexPath.row-1];
        else
            q = self.questions[indexPath.row];
        
        cell.isMyQuestion = [self isMe];
        cell.question = q;
        cell.questionLabel.text = q.question;
        [cell updateVoteCount];
        [cell updateVoteLabels];
        
        cell.time.text = [q formattedDate];
        cell.image1.image = [UIImage imageWithData:q.imageData1];
        cell.image2.image = [UIImage imageWithData:q.imageData2];

        if ([self isMe]) {
            cell.name.text = self.myName;
            cell.profilePic.image = self.myPic;
        } else {
            cell.name.text = q.name;
            
            NSString *strurl = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture", q.facebookID];
            NSURL *url = [NSURL URLWithString:strurl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            [cell.profilePic setImage:[[UIImage alloc] initWithData:data]];
        }
        cell.count1.text = [NSString stringWithFormat:@"%d", [q percentPic:1]];
        cell.count2.text = [NSString stringWithFormat:@"%d", [q percentPic:2]];
        
        // TODO: Load and update question objected's youVoted
        [cell.youVoted1 setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [cell.youVoted2 setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && [self isMe]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.delegate previousPage:self.index];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        PostVC *postVC = [[PostVC alloc] initWithNibName:@"PostVC" bundle:nil];
        if ([self isMe]) {
            postVC.post = [self.questions objectAtIndex:indexPath.row-1];
            postVC.posterImage = self.myPic;
        } else
            postVC.post = [self.questions objectAtIndex:indexPath.row];
        [self presentViewController:postVC animated:YES completion:nil];
    }
}

# pragma mark - ScrollView methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"scrollViewDidEndDragging");
    CGPoint scrollPos = scrollView.contentOffset;
    
    if ([self isMe] && scrollPos.y < 40) {
        [self showTitleBar:scrollView withScrollToTop:YES];
    } else if (self.scrollingDown) {
        [self showTitleBar:scrollView withScrollToTop:NO];
    } else {
        if (!self.hiddenTitleView)
            [self hideTitleBar];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidEndDecelerating");
    CGPoint scrollPos = scrollView.contentOffset;
    
    if ([self isMe] && scrollPos.y < 40) {
        [self showTitleBar:scrollView withScrollToTop:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint scrollPos = scrollView.contentOffset;
//    NSLog(@"scrollPos %f %f", scrollPos.x, scrollPos.y);
    
    int offset;
    if ([self isMe])
        offset = 40;
    else
        offset = 0;
    
    if (scrollPos.y >= offset && (scrollView.contentOffset.y > self.lastContentOffset.y)) {
        // If the user scrolls very slowly, update the frames accordingly
        CGRect newTitleFrame = self.origTitleFrame;
        newTitleFrame.size.height -= scrollPos.y-offset;
        if (newTitleFrame.size.height < 0)
            newTitleFrame.size.height = 0;
        CGRect newStatsFrame = self.origStatsFrame;
        newStatsFrame.origin.y -= scrollPos.y-offset;
        if (newStatsFrame.origin.y < 17)
            newStatsFrame.origin.y = 17;
        CGRect newTableFrame = self.origTableFrame;
        newTableFrame.origin.y -= scrollPos.y-offset;
        if (newTableFrame.origin.y < offset+18)
            newTableFrame.origin.y = offset+18;
        newTableFrame.size.height = self.origTableFrame.size.height + 25;
        
        self.titleView.frame = newTitleFrame;
        self.statsView.frame = newStatsFrame;
        self.feedView.frame = newTableFrame;
        
        if (scrollPos.y <= (offset+25))
            self.titleView.alpha = 1-(scrollPos.y-offset)/25;
        else
            self.titleView.alpha = 0;
    }
    
    self.scrollingDown = scrollView.contentOffset.y < self.lastContentOffset.y;
    self.lastContentOffset = scrollView.contentOffset;
}

#pragma mark - Private methods
- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (BOOL)isFriends
{
    return (self.index == 0);
}

- (BOOL)isMe
{
    return (self.index == 2);
}

- (void) refreshMe: (UIRefreshControl *)refresh;{
    [self reload];
    [refresh endRefreshing];
}

- (void) reload
{
    [self loadQuestionsArray:self.myFacebookID];
}

- (void)showTitleBar:(UIScrollView *)scrollView withScrollToTop:(BOOL)scrollToTop;
{
    self.hiddenTitleView = NO;
    
    // Animate to show title bar
    [UIView animateWithDuration:0.2f animations:^{
        self.titleView.frame = self.origTitleFrame;
        self.statsView.frame = self.origStatsFrame;
        self.feedView.frame = self.origTableFrame;
        self.titleView.alpha = 1;
        if (scrollToTop)
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
}

- (void)hideTitleBar
{
    self.hiddenTitleView = YES;
    
    // Complete animation to hide title bar
    CGRect newTitleFrame = self.origTitleFrame;
    newTitleFrame.size.height -= 25;
    CGRect newStatsFrame = self.origStatsFrame;
    newStatsFrame.origin.y -= 25;
    CGRect newTableFrame = self.origTableFrame;
    newTableFrame.origin.y -= 25;
    newTableFrame.size.height += 25;

    self.titleView.alpha = 0;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.titleView.frame = newTitleFrame;
        self.statsView.frame = newStatsFrame;
        self.feedView.frame = newTableFrame;
    }];
}

- (void)hideStatsBar
{
    self.statsView.hidden = YES;
    
    CGRect newFrame = self.statsView.frame;
    newFrame.size.height = 0;
    self.statsView.frame = newFrame;
    
    newFrame = self.feedView.frame;
    newFrame.size.height += 40;
    newFrame.origin.y -= 40;
    self.feedView.frame = newFrame;
}
    
@end
