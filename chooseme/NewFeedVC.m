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
#import "commentView.h"
#import "AddFriendCell.h"
#import "QuestionKeeper.h"
#import "UIImage+mask.h"

@interface NewFeedVC ()

@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic, strong) NSMutableArray *questions_prev;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *feedTable;

// Private user data
@property (strong, nonatomic) NSString *myFacebookID;
@property (strong, nonatomic) NSString *myName;
@property (strong, nonatomic) UIImage *myPic;

// Random color picked in CameraVC
@property (nonatomic, strong) Colorful *colorManager;

@property (nonatomic, strong) PictureView *currentPView;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, strong) PictureView *detailPView;
@property (nonatomic, strong) commentView *cView;

@property (nonatomic, strong) UIRefreshControl *refresh;

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
        [self.colorManager randFriendsColor];
        self.view.backgroundColor = [self.colorManager currentFriendsColor];
    } else
        self.view.backgroundColor = [self.colorManager currentColor:1];
    
    // Don't show lines below available cells
    self.feedTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Refresh control
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(refreshMe:) forControlEvents:UIControlEventValueChanged];
    [self.feedTable addSubview:self.refresh];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadQuestionsArray:self.myFacebookID];
    
}

- (void) loadQuestionsArray:(NSString *)facebookId {
    self.questions_prev = self.questions;
    if ([self isMe]) {
        PFQuery *query = [Question query];
        // FIXME: Newest posts on top for now.. Eventually, custom order by recently edited or unresolved
        [query orderByDescending:@"time"];
        [query whereKey:@"author" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.questions = [objects mutableCopy];
            
            Question *lastPosted = [[QuestionKeeper instance] lastPosted];
            BOOL contains = NO;
            if (lastPosted != nil) {
                for (Question* question in self.questions) {
                    if ([[question objectId] isEqualToString:[lastPosted objectId]]) {
                        contains = YES;
                        break;
                    }
                }
                
                if (!contains) {
                    [self.questions insertObject:lastPosted atIndex:0];
                }
            }
            
            // Only reload table if questions are different
            if (self.questions.count != self.questions_prev.count)
                [self.feedTable reloadData];
            self.view.backgroundColor = [self.colorManager currentColor:1];
            [self.refresh endRefreshing];
            [self.feedTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
//            [self centerTable];
        }];
    } else {
        // FIXME: this is NOT performant
        PFQuery *query = [Question query];
        [query orderByDescending:@"time"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self.questions = [[NSMutableArray alloc] init];

            for (Question* question in objects) {
                for (int i = 0; i < question.friends.count; i++) {
                    NSDictionary *friend = [question.friends objectAtIndex:i];
                    if ([friend[@"id"] isEqualToString:facebookId]) {
                        question.myVoteIndex = i;
                        [self.questions addObject:question];
                        continue;
                    }
                }
            }
            
            // Only reload table if questions are different
            if (self.questions.count != self.questions_prev.count) {
//                NSLog(@"Re-loading table");
                [self.feedTable reloadData];
            }
            self.view.backgroundColor = [self.colorManager currentFriendsColor];
            [self.refresh endRefreshing];
            [self.feedTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
//            [self centerTable];
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
    if (tableView.tag == 1)
        return self.questions.count;
    else
        return ((Question *)self.questions[self.currentIndex]).friendsCommenting.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
        return self.view.frame.size.height - 40;
    else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        static NSString *CellIdentifier = @"NewFeedCell";
        NewFeedCell *cell = (NewFeedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (self.questions.count > 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([self isFriends])
                cell.backgroundColor = [self.colorManager currentFriendsColor:indexPath.row];
            else
                cell.backgroundColor = [self.colorManager currentColor:indexPath.row+1];
            
            // Load views and format them and stuff
            //    UIImage *image1 = [UIImage imageNamed:@"111834.jpg"];
            //    UIImage *image2 = [UIImage imageNamed:@"131466.jpg"];
            Question *q = self.questions[indexPath.row];
            if ([self isMe])
                [cell loadCell:cell.backgroundColor withQuestion:q withUserImage:self.myPic];
            else
                [cell loadCell:cell.backgroundColor withQuestion:q withUserImage:nil]; //q.profilePic]];
            //withImage1:image1 withImage2:image2 withUserImage:self.myPic];
            
            // Need to set this so that top tableView can scrollToTop
            cell.pView.friendsVotedScrollView.scrollsToTop = NO;
            
            // ************** Detail View ********************************
            // Enable single tap to enter detail view
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterDetailView:)];
            singleTap.numberOfTapsRequired = 1;
            [singleTap requireGestureRecognizerToFail:cell.doubleTap];
            cell.pView.tag = indexPath.row;
            [cell.pView addGestureRecognizer:singleTap];
        }

        return cell;
    } else {
        static NSString *CellIdentifier = @"AddFriendCell";
        AddFriendCell *cell = (AddFriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.name.textColor = [UIColor whiteColor];
        cell.pic.layer.cornerRadius = cell.pic.frame.size.width/2;
        cell.pic.clipsToBounds = YES;
        if ([self isMe])
            cell.speechBubble.backgroundColor = [self.colorManager currentColor:self.currentIndex+1];
        else
            cell.speechBubble.backgroundColor = [self.colorManager currentFriendsColor:self.currentIndex];
        cell.speechBubble.layer.cornerRadius = 5;
        if ([self isMe])
            cell.triangleView.image = [cell.triangleView.image maskWithColor:[self.colorManager currentColor:self.currentIndex+1]];
        else
            cell.triangleView.image = [cell.triangleView.image maskWithColor:[self.colorManager currentFriendsColor:self.currentIndex]];
        
        Question *q = self.questions[self.currentIndex];
        NSString *strurl = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",[q.friendsCommenting objectAtIndex:indexPath.row]];
        NSURL *url = [NSURL URLWithString:strurl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [cell.pic setImage:[[UIImage alloc] initWithData:data]];
        cell.name.text = ((Question *)self.questions[self.currentIndex]).friendsComments[indexPath.row];
        NSLog(@"Comment read: %@", ((Question *)self.questions[self.currentIndex]).friendsComments[indexPath.row]);
        
        return cell;
    }
}

# pragma mark - TextField delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect newFrame = self.cView.frame;
    newFrame.origin.y = 40;
    newFrame.size.height = self.view.frame.size.height - 216-40;
    [UIView animateWithDuration:0.4f animations:^{
        self.cView.frame = newFrame;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Pressing enter dismisses keyboard
    [self.cView.commentTextField resignFirstResponder];
    
    CGRect newFrame = CGRectMake(0, 368, 320, 200);
    [UIView animateWithDuration:0.4f animations:^{
        self.cView.frame = newFrame;
    }];

    Question *q = self.questions[self.currentIndex];
    [q.friendsCommenting addObject:self.myFacebookID];
    [q.friendsComments addObject:self.cView.commentTextField.text];
    NSLog(@"Comment submitted: %@", self.cView.commentTextField.text);
    self.cView.commentTextField.text = @"";
    
    [q saveInBackground];
    [self.cView.commentTable reloadData];
    [self.detailPView update];
    self.cView.noCommentsLabel.hidden = YES;
    
    return YES;
}

# pragma mark - ScrollView methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        [self centerTable];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self centerTable];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = [scrollView contentOffset];
    int index = offset.y / 528;
    if (offset.y - index*528 > 330) {
        UIColor *newColor;
        if ([self isFriends])
            newColor = [self.colorManager currentFriendsColor:index+1];
        else
            newColor = [self.colorManager currentColor:index+2];
        if (self.view.backgroundColor != newColor) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.backgroundColor = newColor;
            }];
        }
    } else {
        UIColor *newColor;
        if ([self isFriends])
            newColor = [self.colorManager currentFriendsColor:index];
        else
            newColor = [self.colorManager currentColor:index+1];
        if (self.view.backgroundColor != newColor) {
            [UIView animateWithDuration:0.3 animations:^{
                self.view.backgroundColor = newColor;
            }];
        }
    }
}

# pragma mark - private methods

- (void)enterDetailView:(UITapGestureRecognizer *)sender
{
    self.currentPView = (PictureView *)sender.view;
    self.currentIndex = sender.view.tag;
    NSLog(@"Enter detail view %d", (int)sender.view.tag);

    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"PictureView" owner:self options:nil];
    self.detailPView = [nibViews objectAtIndex:0];
    UIColor *color;
    if ([self isMe])
        color = [self.colorManager currentColor:(int)sender.view.tag+1];
    else
        color = [self.colorManager currentFriendsColor:(int)sender.view.tag];
    
    [self.detailPView populateData:self.questions[self.currentIndex] withColor:color];
    [self.detailPView highlightImage:self.currentPView.highlightedIndex];
    
    self.detailPView.frame = CGRectMake(0, 40, 320, 368);
    self.detailPView.xButton.hidden = NO;
    self.detailPView.questionLabel.hidden = NO;
    self.detailPView.questionLabel.text = ((Question *)self.questions[self.currentIndex]).question;
    self.detailPView.questionLabel.textColor = self.detailPView.numVotesLabel.textColor;
    
    // Set up button touch actions
    [self.detailPView.thumbnail1 addTarget:self action:@selector(onTapPic1:) forControlEvents:UIControlEventTouchUpInside];
    [self.detailPView.thumbnail2 addTarget:self action:@selector(onTapPic2:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitDetailView)];
    [self.detailPView addGestureRecognizer:singleTap];
    [self.view addSubview:self.detailPView];
    
    CGRect newFrame = sender.view.frame;
    sender.view.alpha = 0;
    self.feedTable.alpha = 0;
    self.currentPView.alpha = 0;
    [UIView animateWithDuration:0.4f animations:^{
        self.detailPView.frame = newFrame;
        self.view.backgroundColor = [UIColor whiteColor];
    }];
    
    nibViews = [[NSBundle mainBundle] loadNibNamed:@"commentView" owner:self options:nil];
    self.cView = [nibViews objectAtIndex:0];
    newFrame = self.cView.frame;
    newFrame.origin.y = 368;
    self.cView.frame = newFrame;
    self.cView.commentTextField.delegate = self;
    [self.cView.commentTable registerNib:[UINib nibWithNibName:@"AddFriendCell" bundle:nil] forCellReuseIdentifier:@"AddFriendCell"];
    self.cView.commentTable.delegate = self;
    self.cView.commentTable.dataSource = self;
    self.cView.commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.cView.myPic setImage:self.myPic];
    self.cView.myPic.clipsToBounds = YES;
    self.cView.myPic.layer.cornerRadius = self.cView.myPic.frame.size.width/2;
    self.cView.commentTextField.textColor = color;
    self.cView.commentTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.cView.lineView.backgroundColor = color;
    if (((Question *)self.questions[self.currentIndex]).friendsCommenting.count > 0)
        self.cView.noCommentsLabel.hidden = YES;
    
    [self.view addSubview:self.cView];
    self.cView.alpha = 0;
    [UIView animateWithDuration:0.4f delay:0.4f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.cView.alpha = 1;
    } completion:nil];
}

- (void)exitDetailView
{
    NSLog(@"Exit detail view");
    
    CGRect newFrame = self.currentPView.frame;
    newFrame.origin = CGPointMake(0, 40);
    
    [self.cView removeFromSuperview];
    [UIView animateWithDuration:0.4f animations:^{
        self.detailPView.frame = newFrame;
        self.feedTable.alpha = 1;
        if ([self isMe])
            self.view.backgroundColor = [self.colorManager currentColor:self.currentIndex+1];
        else
            self.view.backgroundColor = [self.colorManager currentFriendsColor:self.currentIndex];
    } completion:^(BOOL finished) {
        self.currentPView.alpha = 1;
        [self.currentPView update];
        [self.detailPView removeFromSuperview];
    }];
    
    [self centerTable];
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
    [self loadQuestionsArray:self.myFacebookID];
}

- (void)centerTable
{
    NSIndexPath *pathForCenterCell = [self.feedTable indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.feedTable.bounds), CGRectGetMidY(self.feedTable.bounds))];
    [self.feedTable scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


- (void)onTapPic1:(UIButton *)button
{
    [self.detailPView highlightImage:1];
}

- (void)onTapPic2:(UIButton *)button
{
    [self.detailPView highlightImage:2];
}

@end
