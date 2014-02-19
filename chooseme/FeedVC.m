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

@interface FeedVC ()

@property (nonatomic, strong) NSMutableArray *questions;

@property (strong, nonatomic) IBOutlet UITableView *feedView;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
- (IBAction)goToCamera:(id)sender;

- (void)refreshMe:(UIRefreshControl *)refresh;

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
    
    // Set up feed view.
    [self.feedView registerNib:[UINib nibWithNibName:@"FeedCell" bundle:nil] forCellReuseIdentifier:@"FeedCell"];
    self.feedView.dataSource = self;
    self.feedView.delegate = self;
    
    if ([self isMe])
        self.titleLabel.text = @"My Questions";
    else
        self.titleLabel.text = @"Friends' Questions";
    
    
    // Don't show lines below available cells
    self.feedView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Refresh control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshMe:) forControlEvents:UIControlEventValueChanged];
    [self.feedView addSubview:refresh];
    
    // Load the question array
    if ([self isMe]) {
        PFQuery *query = [Question query];
        [query whereKey:@"author" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            // Newest posts on top for now.. Eventually, custom order by recently edited or unresolved
            self.questions = [[[objects mutableCopy] reverseObjectEnumerator] allObjects];
            [self.feedView reloadData];
        }];
    } else {
        // FIXME: Remove this eventually
        self.questions = [[NSMutableArray alloc] init];
        for (int i = 0; i < 10; i++)
        {
            Question *q = [[Question alloc] init];
            q.name = [NSString stringWithFormat:@"Name%d", i];
            q.question = [NSString stringWithFormat:@"Question%d", i];
            [self.questions addObject:q];
        }
        [self.feedView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view methods

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
    CGFloat height;
    Question *q = self.questions[indexPath.row];
    if (q.question != nil)
        height = [self textViewHeightForAttributedText:[[NSAttributedString alloc] initWithString:q.question] andWidth:240];
    else
        height = 0;
    if (height > 0) {
        return height + 200;
    } else
        return 220;
}

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeedCell";
    FeedCell *cell = (FeedCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Question *q = self.questions[indexPath.row];
    cell.name.text = q.name;
    cell.question.text = q.question;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PostVC *postVC = [[PostVC alloc] initWithNibName:@"PostVC" bundle:nil];
    postVC.post = [self.questions objectAtIndex:indexPath.row];
    [self presentModalViewController:postVC animated:YES];
}

#pragma mark - Private methods

- (BOOL)isFriends
{
    return (self.index == 0);
}

- (BOOL)isMe
{
    return (self.index == 2);
}

- (IBAction)goToCamera:(id)sender {
    if ([self isMe])
        [self.delegate previousPage:self.index];
    else
        [self.delegate nextPage:self.index];
}

- (void) refreshMe: (UIRefreshControl *)refresh;{
    [self.feedView reloadData];
    
    [refresh endRefreshing];
}


@end
