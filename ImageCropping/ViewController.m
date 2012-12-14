//
//  ViewController.m
//  ImageCropping
//
//  Created by Suraj Mirajkar on 14/12/12.
//  Copyright (c) 2012 suraj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/* Take Picture  method */
-(void) TakeAPicture {
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"Photo Picker" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    actSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    NSLog(@"Device:  %@",[[UIDevice currentDevice] model]); // Logs the Device Type
	
    switch (buttonIndex) {
        case 1:
            // Set type to Photo Library if button at index is selected
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
                // Set source to the Photo Library
                imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
            } else {
                imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            
            // Show image picker
            if ([self iOSVersion6])
                [self presentViewController:imagePicker animated:YES completion:nil];
            else
                [self presentModalViewController:imagePicker animated:YES];
            
            break;
        case 0:
            imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;   // Set type to Camera if button at index is selected
            
            // Show image picker
            if ([self iOSVersion6])
                [self presentViewController:imagePicker animated:YES completion:nil];
            else
                [self presentModalViewController:imagePicker animated:YES];
            break;
            
        case 2:
            NSLog(@"Cancel button clicked");
            break;
    }
    // Delegate is self
    imagePicker.delegate = self;
    
}

// ImagePicker Delegate method for
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// Access the uncropped image from info dictionary
	UIImage *selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Convert Image to NSData (byte format)
    //NSData *dataImage =  UIImageJPEGRepresentation(selectedImage,1);
    //dataImage = UIImagePNGRepresentation(selectedImage);
    
    // check if picture is taken from camera
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // Save image to Album
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        NSLog(@"Image is taken from Photo Library, so there is no need to it write again");
       // [self.imgViewBackground setImage:selectedImage];
        // Dismiss image picker
        if ([self iOSVersion6])
            [self dismissViewControllerAnimated:YES completion:nil];
        else
            [self.navigationController dismissModalViewControllerAnimated:YES];
        
        
        /*
         UIImage *photo = [UIImage imageNamed:imageNames[indexPath.row]];
         
         SSPhotoCropperViewController *photoCropper =
         [[SSPhotoCropperViewController alloc] initWithPhoto:photo
         delegate:self
         uiMode:SSPCUIModePresentedAsModalViewController
         showsInfoButton:YES];
         [photoCropper setMinZoomScale:0.75f];
         [photoCropper setMaxZoomScale:1.50f];
         UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:photoCropper];
         [self presentModalViewController:nc animated:YES];
         */
        
        
        SSPhotoCropperViewController *sSPhotoCropperViewController = [[SSPhotoCropperViewController alloc] initWithPhoto:selectedImage delegate:self];
        [sSPhotoCropperViewController setMinZoomScale:0.75f];
        [sSPhotoCropperViewController setMaxZoomScale:1.50f];
        [self.navigationController pushViewController:sSPhotoCropperViewController animated:YES];
      //  [self presentViewController:sSPhotoCropperViewController animated:YES completion:nil];
        
        
    }
}

// ImagePicker Delegate method to check if image is saved or not.
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
	// Unable to save the image
    if (error)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:nil cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
        [alert show];
    }
    // Image is saved successfully
	else
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:nil cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
        //[self.imgViewBackground setImage:image];
        SSPhotoCropperViewController *sSPhotoCropperViewController = [[SSPhotoCropperViewController alloc] initWithNibName:@"SSPhotoCropperViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:sSPhotoCropperViewController animated:YES];
        
    }
    
    
    
    // Dismiss image picker
    if ([self iOSVersion6])
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController dismissModalViewControllerAnimated:YES];
}

// ImagePicker Delegate method to detect whether Modal View is Cancelled and accordingly perform action on it.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Dismiss image picker
	if ([self iOSVersion6])
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)takeAPicture:(id)sender {
    [self TakeAPicture];
}

-(BOOL)iOSVersion6 {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        return YES;
    else
        return NO;
}

#pragma -
#pragma SSPhotoCropperDelegate Methods

- (void) photoCropper:(SSPhotoCropperViewController *)photoCropper
         didCropPhoto:(UIImage *)photo
{
   // self.croppedPhoto = photo;
    self.imgViewBackground.image = photo;
   [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) photoCropperDidCancel:(SSPhotoCropperViewController *)photoCropper
{
        [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
