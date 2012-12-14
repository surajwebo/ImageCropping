//
//  ViewController.h
//  ImageCropping
//
//  Created by Suraj Mirajkar on 14/12/12.
//  Copyright (c) 2012 suraj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPhotoCropperViewController.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate,SSPhotoCropperDelegate> {
    
}
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBackground;

-(void) TakeAPicture;
- (IBAction)takeAPicture:(id)sender;
-(BOOL)iOSVersion6;


@end
