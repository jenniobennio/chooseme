//
//  NewFeedVC.m
//  
//
//  Created by Jenny Kwan on 2/27/14.
//
//

#import "NewFeedVC.h"
#import "PictureView.h"
#import "UserQuestionView.h"
#import "NewFeedCell.h"
#import "Question.h"

@interface NewFeedVC ()

@property (nonatomic, strong) NSMutableArray *questions;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UITableView *feedTable;

@property (strong, nonatomic) NSMutableArray *colors;
@property (nonatomic, assign) int lastIndexDisplayed;

// Private user data
@property (strong, nonatomic) NSString *myFacebookID;
@property (strong, nonatomic) NSString *myName;
@property (strong, nonatomic) UIImage *myPic;

@end

@implementation NewFeedVC

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
    
    [self.feedTable registerNib:[UINib nibWithNibName:@"NewFeedCell" bundle:nil] forCellReuseIdentifier:@"NewFeedCell"];
    self.feedTable.scrollsToTop = YES;
    self.feedTable.delegate = self;
    self.feedTable.dataSource = self;
    
    // Set title
    if ([self isMe])
        self.titleLabel.text = @"MY QUESTIONS";
    else
        self.titleLabel.text = @"FRIENDS' QUESTIONS";
    
    // Pretty flat UI colors!
    self.colors = [[NSMutableArray alloc] init];
    [self.colors addObject:[UIColor colorWithRed:0.329 green:0.733 blue:0.616 alpha:0.5]];
    [self.colors addObject:[UIColor colorWithRed:0.149 green:0.706 blue:0.835 alpha:0.5]];
    [self.colors addObject:[UIColor colorWithRed:0.933 green:0.733 blue:0 alpha:0.5]];
    [self.colors addObject:[UIColor colorWithRed:0.702 green:0.141 blue:0.110 alpha:0.5]];
    [self.colors addObject:[UIColor colorWithRed:0.878 green:0.416 blue:0.039 alpha:0.5]];
    [self.colors addObject:[UIColor colorWithRed:0.929 green:0.345 blue:0.455 alpha:0.5]];
    [self.colors addObject:[UIColor colorWithRed:0.537 green:0.235 blue:0.663 alpha:0.5]];
    [self.colors addObject:[UIColor colorWithRed:0.153 green:0.220 blue:0.298 alpha:0.5]];
    
    self.view.backgroundColor = self.colors[0];
    
    // Don't show lines below available cells
    self.feedTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Refresh control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshMe:) forControlEvents:                         UIControlEventValueChanged];
    [self.feedTable addSubview:refresh];
    
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
            
            // Only reload image instead of entire table
//            NewFeedCell *cell = (NewFeedCell *)[self.feedTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            [cell reloadUserPic:self.myPic];
            
            // load the questions array
            [self loadQuestionsArray:self.myFacebookID];
            
        }
    }];

}

- (void) loadQuestionsArray:(NSString *)facebookId {
    if ([self isMe]) {
        PFQuery *query = [Question query];
        // FIXME: Newest posts on top for now.. Eventually, custom order by recently edited or unresolved
        [query orderByDescending:@"createdAt"];
        [query whereKey:@"author" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.questions = [objects mutableCopy];
            [self.feedTable reloadData];
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
            
            [self.feedTable reloadData];
        }];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height - 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewFeedCell";
    NewFeedCell *cell = (NewFeedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = self.colors[indexPath.row % self.colors.count];
    
    // Load views and format them and stuff
//    UIImage *image1 = [UIImage imageNamed:@"111834.jpg"];
//    UIImage *image2 = [UIImage imageNamed:@"131466.jpg"];
    Question *q = self.questions[indexPath.row];
    if ([self isMe])
        [cell loadCell:self.colors[indexPath.row % self.colors.count] withQuestion:q withUserImage:self.myPic];
    else
        [cell loadCell:self.colors[indexPath.row % self.colors.count] withQuestion:q withUserImage:[UIImage imageWithData:q.profilePic]];
        //withImage1:image1 withImage2:image2 withUserImage:self.myPic];
    
    
    
    // Need to set this so that top tableView can scrollToTop
    cell.pView.friendsVotedScrollView.scrollsToTop = NO;
    
    // Set up button touch actions
    [cell.pView.thumbnail1 addTarget:self action:@selector(onTapPic1:) forControlEvents:UIControlEventTouchUpInside];
    cell.pView.thumbnail1.tag = 1;
    [cell.pView.thumbnail2 addTarget:self action:@selector(onTapPic2:) forControlEvents:UIControlEventTouchUpInside];
    cell.pView.thumbnail2.tag = 2;
    
    
    // Set up gesture recognizers. Is this the right place to do this?
//    UITapGestureRecognizer *tapPic1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPic1:)];
//    UITapGestureRecognizer *tapPic2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapPic2:)];
//    [cell.pView.thumbnail1 addGestureRecognizer:tapPic1];
//    [cell.pView.thumbnail2 addGestureRecognizer:tapPic2];
    
    return cell;
}


# pragma mark - ScrollView methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = [scrollView contentOffset];
    int index = offset.y / 528;
    if (offset.y - index*528 > 330) {
        UIColor *newColor = self.colors[(index+1) % self.colors.count];
        if (self.view.backgroundColor != newColor) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.backgroundColor = newColor;
            }];
        }
    } else {
        UIColor *newColor = self.colors[index % self.colors.count];
        if (self.view.backgroundColor != newColor) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.backgroundColor = newColor;
            }];
        }
    }
}

# pragma mark - private methods
- (void)onTapPic1:(UIButton *)button
{
    NSLog(@"on tap button 1, tag = %d", button.tag);
}
- (void)onTapPic2:(UIButton *)button
{
    NSLog(@"on tap button 2, tag = %d", button.tag);
}

- (BOOL)isFriends
{
    return (self.index == 0);
}

- (BOOL)isMe
{
    return (self.index == 2);
}

- (void)reload
{
    [self loadQuestionsArray:self.myFacebookID];
}

- (void) refreshMe: (UIRefreshControl *)refresh;{
    [self reload];
    [refresh endRefreshing];
}

@end
