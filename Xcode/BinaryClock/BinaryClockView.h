//
//  BinaryClockView.h
//  BinaryClock
//
//  Created by Frédéric Hardy on 26/12/12.
//  Copyright (c) 2012 Frédéric Hardy. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <Quartz/Quartz.h>

@interface BinaryClockView : ScreenSaverView
{
    QCView* qtz;
    
    IBOutlet id configSheet;
    IBOutlet NSButton *timeAsBackgroundColor;
    IBOutlet NSButton *displayNumbers;
    IBOutlet NSButton *displayHalos;
    IBOutlet NSColorWell *numberMorningColorWell;
    IBOutlet NSColorWell *numberAfternoonColorWell;
    IBOutlet NSColorWell *ledMorningColorWell;
    IBOutlet NSColorWell *ledAfternoonColorWell;
}

@end