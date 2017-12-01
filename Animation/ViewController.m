//
//  ViewController.m
//  Animation
//
//  Created by Swati Wadhera on 9/6/17.
//  Copyright © 2017 Swati Wadhera. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    NSMutableArray <UIImage *> *imgArr = [NSMutableArray array];
    for(int i = 1; i <= 5; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%d.png",i];
        [imgArr addObject:[UIImage imageNamed:imgName]];
        float ratio = ([UIImage imageNamed:imgName].size.width)/([UIImage imageNamed:imgName].size.height);
        [imgV setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * (float)(1/ratio))];
    }
    
    [imgV setAnimationImages:imgArr];
    [imgV setAnimationDuration:2];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)startImageAnimation {
    //[imgV startAnimating];
    
    //[self makeAnimatedGif];
    
    [self mergeVideo];
}

- (IBAction)email:(id)sender {
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    [controller setToRecipients:[NSArray arrayWithObject:@"iosapps@wedmegood.com"]];
    [controller setSubject:@"Video"];
    [controller setMailComposeDelegate:self];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    controller.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
    
    NSString* documentsDirectory= [self applicationDocumentsDirectory];
    NSString *myDocumentPath= [documentsDirectory stringByAppendingPathComponent:@"merge_video.mp4"];
    NSURL *urlVideoMain = [[NSURL alloc] initFileURLWithPath: myDocumentPath];

    UISaveVideoAtPathToSavedPhotosAlbum(myDocumentPath, nil, nil, nil);

//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeImageDataToSavedPhotosAlbum:[NSData dataWithContentsOfURL:urlVideoMain] metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
//        
//        NSLog(@"Success at %@", [assetURL path] );
//    }];
    
    
    [controller addAttachmentData:[NSData dataWithContentsOfURL:urlVideoMain] mimeType:@"mp4" fileName:@"animated.mp4"];
    [controller setMessageBody:@"Copyright Swati Wadhera" isHTML:NO];
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)mergeVideo
{
    CGFloat totalDuration;
    totalDuration = 0;
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime insertTime = kCMTimeZero;
    
    for (int i = 1; i <= 3; i++)
    {
        NSString *videoName = [NSString stringWithFormat:@"Video_%d",i];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:videoName ofType:@"mov"];
        AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
        
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        
        [videoTrack insertTimeRange:timeRange
                            ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                             atTime:insertTime
                              error:nil];
        
        if([[asset tracksWithMediaType:AVMediaTypeAudio] count]) {
            [audioTrack insertTimeRange:timeRange
                                ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                 atTime:insertTime
                                  error:nil];
        }
        
        insertTime = CMTimeAdd(insertTime,asset.duration);
    }
    
    NSString* documentsDirectory= [self applicationDocumentsDirectory];
    NSString *myDocumentPath= [documentsDirectory stringByAppendingPathComponent:@"merge_video.mp4"];
    NSURL *urlVideoMain = [[NSURL alloc] initFileURLWithPath: myDocumentPath];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
    }
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = urlVideoMain;
    exporter.outputFileType = @"com.apple.quicktime-movie";
    exporter.shouldOptimizeForNetworkUse = YES;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        
        switch ([exporter status])
        {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"AVAssetExportSessionStatusFailed");
                break;
                
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"AVAssetExportSessionStatusCancelled");
                break;
                
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"AVAssetExportSessionStatusCompleted");
                break;
                
            default:
                break;
        }
    }];
}

- (NSString*) applicationDocumentsDirectory
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)makeMovie {
}

//- (void)makeMovie {
//    NSError *error = nil;
//
//    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
//    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.mov"];
//    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:
//                                  fileURL fileType:AVFileTypeQuickTimeMovie
//                                                              error:&error];
//    NSParameterAssert(videoWriter);
//
//    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
//                                   AVVideoCodecTypeH264, AVVideoCodecKey,
//                                   [NSNumber numberWithInt:640], AVVideoWidthKey,
//                                   [NSNumber numberWithInt:480], AVVideoHeightKey,
//                                   nil];
//    AVAssetWriterInput* writerInput = [AVAssetWriterInput
//                                        assetWriterInputWithMediaType:AVMediaTypeVideo
//                                        outputSettings:videoSettings]; //retain should be removed if ARC
//
//    NSParameterAssert(writerInput);
//    NSParameterAssert([videoWriter canAddInput:writerInput]);
//    [videoWriter addInput:writerInput];
//
//    [videoWriter startWriting];
//    [videoWriter startSessionAtSourceTime:kCMTimeZero];
//
//    [writerInput a:[self newPixelBufferFromCGImage:[UIImage imageNamed:@"1.png"].CGImage]];
//
//    [writerInput markAsFinished];
//    [videoWriter finishWritingWithCompletionHandler:^{
//        NSLog(@"completed at url - %@",fileURL);
//    }];
//}
//
//- (CVPixelBufferRef) newPixelBufferFromCGImage: (CGImageRef) image
//{
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
//                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
//                             nil];
//    CVPixelBufferRef pxbuffer = NULL;
//    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
//                                          frameSize.height, kCVPixelFormatType_32ARGB, (CFDictionaryRef) options,
//                                          &pxbuffer);
//    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
//
//    CVPixelBufferLockBaseAddress(pxbuffer, 0);
//    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
//    NSParameterAssert(pxdata != NULL);
//
//    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width,
//                                                 frameSize.height, 8, 4*frameSize.width, rgbColorSpace,
//                                                 kCGImageAlphaNoneSkipFirst);
//    NSParameterAssert(context);
//    CGContextConcatCTM(context, frameTransform);
//    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
//                                           CGImageGetHeight(image)), image);
//    CGColorSpaceRelease(rgbColorSpace);
//    CGContextRelease(context);
//
//    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
//
//    return pxbuffer;
//}

- (void) makeAnimatedGif {
    static NSUInteger const kFrameCount = 5;

    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @3, // 0 means loop forever
                                             }
                                     };
    
    NSDictionary *frameProperties = @{
                                      (__bridge id)kCGImagePropertyGIFDictionary: @{
                                              (__bridge id)kCGImagePropertyGIFDelayTime: @1.0f, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                              }
                                      };
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    for (int i = 1; i <= kFrameCount; i++) {
        @autoreleasepool {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
            CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
        }
    }
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    
    NSLog(@"url=%@", fileURL);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
