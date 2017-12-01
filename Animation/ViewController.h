//
//  ViewController.h
//  Animation
//
//  Created by Swati Wadhera on 9/6/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MessageUI/MessageUI.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "MSImageMovieEncoder.h"
@interface ViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    IBOutlet UIImageView *imgV;
}
@end

