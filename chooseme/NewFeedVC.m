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
#import "FacebookClient.h"
#import "Colorful.h"

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

// Random color picked in CameraVC
@property (nonatomic, strong) Colorful *colorManager;

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
    
    self.colorManager = [Colorful sharedManager];
    if ([self isFriends]) {
        self.colorManager.friendsColorIndex = arc4random() % self.colorManager.colors.count;
        self.view.backgroundColor = self.colorManager.colors[self.colorManager.friendsColorIndex % self.colorManager.colors.count];
    } else
        self.view.backgroundColor = self.colorManager.colors[(self.colorManager.colorIndex+1) % self.colorManager.colors.count];
    
    // Don't show lines below available cells
    self.feedTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Refresh control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshMe:) forControlEvents:                         UIControlEventValueChanged];
    [self.feedTable addSubview:refresh];
    
    // Load my data
    void (^onSuccess)(void) = ^{
        FacebookClient *facebookClient = [FacebookClient instance];

        self.myName = [facebookClient myName];
        self.myFacebookID = [facebookClient myFacebookID];
        self.myPic = [facebookClient myPic];
        
        [self loadQuestionsArray:self.myFacebookID];
    };
    if ([[FacebookClient instance] myFacebookID] == nil) { // hasn't loaded yet
        [[FacebookClient instance] meRequest:onSuccess];
    } else {
        onSuccess();
    }
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
    if ([self isFriends])
        cell.backgroundColor = self.colorManager.colors[(indexPath.row + self.colorManager.friendsColorIndex + 1) % self.colorManager.colors.count];
    else
        cell.backgroundColor = self.colorManager.colors[(indexPath.row + self.colorManager.colorIndex + 1) % self.colorManager.colors.count];

    // Load views and format them and stuff
//    UIImage *image1 = [UIImage imageNamed:@"111834.jpg"];
//    UIImage *image2 = [UIImage imageNamed:@"131466.jpg"];
    Question *q = self.questions[indexPath.row];
    if ([self isMe])
        [cell loadCell:cell.backgroundColor withQuestion:q withUserImage:self.myPic];
    else
        [cell loadCell:cell.backgroundColor withQuestion:q withUserImage:[UIImage imageWithData:q.profilePic]];
        //withImage1:image1 withImage2:image2 withUserImage:self.myPic];
    
    
    
    // Need to set this so that top tableView can scrollToTop
    cell.pView.friendsVotedScrollView.scrollsToTop = NO;
    
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
        UIColor *newColor;
        if ([self isFriends])
            newColor = self.colorManager.colors[(self.colorManager.friendsColorIndex + 1 +index+1) % self.colorManager.colors.count];
        else
            newColor = self.colorManager.colors[(self.colorManager.colorIndex + 1 +index+1) % self.colorManager.colors.count];
        if (self.view.backgroundColor != newColor) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.backgroundColor = newColor;
            }];
        }
    } else {
        UIColor *newColor;
        if ([self isFriends])
            newColor = self.colorManager.colors[(self.colorManager.friendsColorIndex + 1 + index) % self.colorManager.colors.count];
        else
            newColor = self.colorManager.colors[(self.colorManager.colorIndex + 1 + index) % self.colorManager.colors.count];
        if (self.view.backgroundColor != newColor) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.backgroundColor = newColor;
            }];
        }
    }
}

# pragma mark - private methods

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
