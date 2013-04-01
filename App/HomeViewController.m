
#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib
    
    douto(NSLocalizedString(@"HelloWorld", "测试"))
}

@end
