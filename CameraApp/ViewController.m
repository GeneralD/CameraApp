//
//  ViewController.m
//  CameraApp
//
//  Created by Yumenosuke Koukata on 10/30/13.
//  Copyright (c) 2013 Yumenosuke Koukata. All rights reserved.
//

#import "ViewController.h"
#import "GPUImageVideoCamera.h"
#import "GPUImageSepiaFilter.h"
#import "GPUImageView.h"
#import "GPUImageSobelEdgeDetectionFilter.h"
#import "FilterData.h"
#import "GPUImageCannyEdgeDetectionFilter.h"
#import "GPUImageColorInvertFilter.h"
#import "GPUImageToonFilter.h"
#import "GPUImageWeakPixelInclusionFilter.h"

@interface ViewController ()

@end

@implementation ViewController {
	GPUImageVideoCamera *videoCamera;
}

static int const SPLIT = 3;

- (void)viewDidLoad {
	[super viewDidLoad];

	BOOL iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
	NSString *const preset = iPad ? AVCaptureSessionPreset640x480 : AVCaptureSessionPreset1280x720;

	videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:preset
													  cameraPosition:AVCaptureDevicePositionBack];
	videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
	videoCamera.horizontallyMirrorFrontFacingCamera = NO;
	videoCamera.horizontallyMirrorRearFacingCamera = NO;

	NSMutableArray *filterDatas = [NSMutableArray array];
	FilterData *data;

	data = [FilterData new]; // 0
	GPUImageToonFilter *toonFilter = [GPUImageToonFilter new];
	toonFilter.threshold = 0.2;
	toonFilter.quantizationLevels = 10.0;
	data.filter = toonFilter;
	data.name = @"Toon";
	[filterDatas addObject:data];

	data = [FilterData new]; // 1
	data.filter = [GPUImageWeakPixelInclusionFilter new];
	data.name = @"WeakPixelInclusion";
	[filterDatas addObject:data];

	data = [FilterData new]; // 2
	data.filter = [GPUImageCannyEdgeDetectionFilter new];
	data.name = @"CannyEdgeDetection";
	[filterDatas addObject:data];

	data = [FilterData new]; // 3
	data.filter = [GPUImageTwoPassFilter new];
	data.name = @"TwoPass";
	[filterDatas addObject:data];

	data = [FilterData new]; // 4
	data.filter = [GPUImageSepiaFilter new];
	data.name = @"Sepia";
	[filterDatas addObject:data];

	data = [FilterData new]; // 5
	data.filter = [GPUImageSobelEdgeDetectionFilter new];
	data.name = @"SobelEdgeDetection";
	[filterDatas addObject:data];

	data = [FilterData new]; // 6
	data.filter = [GPUImageCannyEdgeDetectionFilter new];
	data.name = @"CannyEdgeDetection";
	[filterDatas addObject:data];

	data = [FilterData new]; // 7
	data.filter = [GPUImageTwoPassFilter new];
	data.name = @"TwoPass";
	[filterDatas addObject:data];

	data = [FilterData new]; // 8
	data.filter = [GPUImageColorInvertFilter new];
	data.name = @"Negative";
	[filterDatas addObject:data];

	const CGRect frame = self.view.frame;
	const CGSize size = frame.size;
	CGFloat w = size.width, h = size.height;
	w /= SPLIT;
	h /= SPLIT;

	for (int i = 0; i < SPLIT; i++) {
		for (int j = 0; j < SPLIT; j++) {

			FilterData *data = [filterDatas objectAtIndex:SPLIT * i + j];

			// add GPUImageView
			GPUImageView *gpuImageView = [GPUImageView new];
			CGRect gpuImageFrame = CGRectMake(w * i, h * j, w, h);
			gpuImageView.frame = gpuImageFrame;

			UIGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]
					initWithTarget:[NSBlockOperation blockOperationWithBlock:
							^{
//								if (CGRectEqualToRect(gpuImageView.frame, frame)) {
//									gpuImageView.frame = gpuImageFrame;
//								} else {
//									gpuImageView.frame = frame;
//								}
							}]
							action:@selector(main)];
			[self.view addGestureRecognizer:gestureRecognizer];
			[self.view addSubview:gpuImageView];

			// add UILabel
			CGFloat lh = 24.f;
			CGFloat fontSize = 23.f;
			if (!iPad) {
				lh /= 3.f;
				fontSize /= 3.f;
			}
			UILabel *label = [UILabel new];
			label.frame = CGRectMake(0, h - lh * 1.5f, w, lh);
			label.font = [UIFont systemFontOfSize:fontSize];
			label.textColor = [UIColor whiteColor];
			label.text = data.name;
			label.textAlignment = NSTextAlignmentCenter;
			label.numberOfLines = 1;
			label.adjustsFontSizeToFitWidth = YES;
			label.userInteractionEnabled = NO;
			[gpuImageView addSubview:label];
			[data.filter addTarget:gpuImageView];
			[videoCamera addTarget:data.filter];
		}
	}
	[videoCamera startCameraCapture];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
