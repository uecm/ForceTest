//
//  ViewController.m
//  ForceTests
//
//  Created by Egor on 10/28/16.
//  Copyright © 2016 egor. All rights reserved.
//

#import "ViewController.h"

#define BETWEEN(value, min, max) (value <= max && value >= min)


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self.view setAcceptsTouchEvents:true];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (IBAction)accelerateButtonPushed:(id)sender {
    if ( [sender doubleValue] >= 1 ) {
        
        int currentPressure = ([sender doubleValue] - 1.0f) * 1000;
        [self.levelIndicator setIntValue:currentPressure];
        
    } else {
        [self.levelIndicator setIntValue:0];
    }
    
}

-(void)touchesBeganWithEvent:(NSEvent *)event{
    
    // TRACKPAD SIZE : X = 300, Y = 220
    /* TRACKPAD ZONES :
                        1 = { (0, 0) , (100, 110) }
                        2 = { (100, 0) , (200, 110) }
                        3 = { (200, 0) , (300, 110) }
                        4 = { (0, 110) , (100, 220) }
                        5 = { (100, 110) , (200, 220) }
                        6 = { (200, 110) , (300, 220) }
    */
    
    NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseBegan inView:self.view];
    for(NSTouch *touch in touches){
        
        NSInteger zone = [self trackpadZoneByTouch:touch];
        NSLog(@"Touch did happen in zone: %li", (long)zone);
        
    }
}

-(NSInteger) trackpadZoneByTouch:(NSTouch*)t {
    //Find out touch coordinates
    NSPoint fraction = t.normalizedPosition;
    NSSize size = t.deviceSize;
    NSPoint coords = {size.width, size.height};
    
    coords.x *= fraction.x;
    coords.y *= fraction.y;
    
    NSPoint point;  // Point that holds zone values in itself
    
    // Find out zone by X coordinate
    if(BETWEEN(coords.x, 0, size.width/3.f)){
        point.x = 0;
    }
    else if (BETWEEN(coords.x, size.width/3.f, 2.f*size.width/3.f)){
        point.x = 1;
    }
    else if(BETWEEN(coords.x, 2.f*size.width/3.f, size.width)){
        point.x = 2;
    }
    // Find out zone by Y coordinate
    if(BETWEEN(coords.y, 0, size.height/2.f)){
        point.y = 0;
    }
    else {
        point.y = 1;
    }
    // Find out actual zone
    NSInteger zone;
    switch ((int)point.x) {
        case 0:
            if((int)point.y == 0){
                zone = 1;
            } else {
                zone = 4;
            }
            break;
            
        case 1:
            if ((int)point.y == 0) {
                zone = 2;
            } else {
                zone = 5;
            }
            break;
            
        case 2:
            if ((int)point.y == 0) {
                zone = 3;
            } else {
                zone = 6;
            }
            break;
            
        default:
            break;
    }
    
    return zone;
}


@end
