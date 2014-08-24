//
//  TableListTVC.m
//  TableList
//
//  Created by Bing Xiong on 7/27/14.
//  Copyright (c) 2014 Mobo. All rights reserved.
//

#import "TableListTVC.h"
#import "ListDetailVC.h"
#import "Util.h"

@interface TableListTVC ()

@end


@implementation TableListTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setListModel:(NSArray *)listModel
{
    _listModel = listModel;
    [self.tableView reloadData];
}

- (InfoListCell *) tempCell
{
    if (_tempCell == nil) {
//        _tempCell = [[InfoListCell alloc] init];
        _tempCell=[[InfoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContentCell"];
    }
    
    return _tempCell;
}

- (void)awakeFromNib {
        [self.tableView registerNib:[UINib nibWithNibName:@"InfoListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ContentCell"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchJSON];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (IBAction) fetchJSON
{
    [self.refreshControl beginRefreshing];
    NSLog(@"beginRefreshing");
    dispatch_queue_t fetchQ = dispatch_queue_create("FetcherQueue", NULL);
    dispatch_async(fetchQ, ^{
        NSURL *url = [[NSURL alloc] initWithString:@"http://mobo-app.s3.amazonaws.com/ipas/list.json" ];
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.listModel = [NSJSONSerialization JSONObjectWithData:jsonResults options:(0) error:NULL];
            
            [self.refreshControl endRefreshing];
            NSLog(@"endRefreshing");
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listModel count];
}

-(void) setCellContent:(InfoListCell*)cell withInfo:(NSDictionary *)cellInfo flag:(BOOL) flag
{
    NSString * dateStr = [Util formatDateString:[cellInfo valueForKeyPath:DATE]];
    
    [cell SetContent:[cellInfo valueForKeyPath:TITLE]
          andDateStr:dateStr
               andID:[[NSString alloc] initWithFormat:@"%@",[cellInfo valueForKeyPath:ORDER_ID]]
                flag:flag];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    
    [self setCellContent:self.tempCell withInfo:[self.listModel objectAtIndex:indexPath.row] flag:NO];
//    NSLog(@"self.tempCell.cellHeight = %f", self.tempCell.cellHeight);
  
    return self.tempCell.cellHeight;
}
     

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *cellInfo = [self.listModel objectAtIndex:indexPath.row];
    [self setCellContent:cell withInfo:cellInfo flag:NO];
    
    return cell;
}

-(void) prepareListDetailVCByItem:(ListDetailVC *) dvc ofId:(NSString *)listId title:(NSString *)title date:(NSString *)date
{
    dvc.title = [NSString stringWithFormat:@"Details of %@", listId];
}

-(void) prepareListDetailVC:(ListDetailVC *) dvc ofDetails:(NSDictionary *)details
{
    dvc.details = details;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(indexPath)
        {
//            ListDetailVC *dvc = [[ListDetailVC alloc] init];
            ListDetailVC *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Cell Detail VC"];
            
            [self prepareListDetailVC:dvc ofDetails:[self.listModel objectAtIndex:indexPath.row]];
            
            [self.navigationController pushViewController:dvc animated:YES];
        }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *index = [self.tableView indexPathForCell:sender];
        if(index)
        {
            if ([segue.identifier isEqualToString:@"List To Detail"] &&
                [segue.destinationViewController isKindOfClass:[ListDetailVC class]])
            {
                [self prepareListDetailVC:segue.destinationViewController ofDetails:[self.listModel objectAtIndex:index.row]];
            }
        }
    }
    
}

- (IBAction)test:(id)sender {
    NSLog(@"Work");
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
