//
//  BinaryClockView.m
//  BinaryClock
//
//  Created by Frédéric Hardy on 26/12/12.
//  Copyright (c) 2012 Frédéric Hardy. All rights reserved.
//

#import "BinaryClockView.h"

@implementation BinaryClockView;

static NSString * const BinaryClockName = @"Mageekbox.BinaryClock";

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    
    if (self) {
        [self setAnimationTimeInterval: 1/30.0];
        
        NSString *qtzComposition = [[NSBundle bundleForClass:[self class]] pathForResource: @"BinaryClock" ofType: @"qtz"];
        
        if (qtzComposition)
        {
            qtz = [[QCView alloc] initWithFrame: NSMakeRect(0, 0, NSWidth(frame), NSHeight(frame))];

            if (qtz)
            {
                ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName: BinaryClockName];
                
                [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSKeyedArchiver archivedDataWithRootObject: [NSColor colorWithDeviceRed: 1.0 green: 1.0 blue: 1.0 alpha: 1]], @"numberMorningColor",
                            [NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed: 1.0 green: 1.0 blue: 1.0 alpha: 1]], @"numberAfternoonColor",
                            [NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed: 1.0 green: 1.0 blue: 1.0 alpha: 1]], @"ledMorningColor",
                            [NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed: 1.0 green: 1.0 blue: 1.0 alpha: 1]], @"ledAfternoonColor",
                            @"1", @"displayNumbers",
                            @"1", @"displayHalos",
                            @"1", @"timeAsBackgroundColor",
                            nil
                        ]
                 ];
                    
                [defaults synchronize];
                
                NSColor *numberMorningColor = (NSColor*)[NSKeyedUnarchiver unarchiveObjectWithData: [defaults dataForKey: @"numberMorningColor"]];
                NSColor *numberAfternoonColor = (NSColor*)[NSKeyedUnarchiver unarchiveObjectWithData: [defaults dataForKey: @"numberAfternoonColor"]];
                NSColor *ledMorningColor = (NSColor*)[NSKeyedUnarchiver unarchiveObjectWithData: [defaults dataForKey: @"ledMorningColor"]];
                NSColor *ledAfternoonColor = (NSColor*)[NSKeyedUnarchiver unarchiveObjectWithData: [defaults dataForKey: @"ledAfternoonColor"]];

                [qtz loadCompositionFromFile: qtzComposition];
                [qtz setMaxRenderingFrameRate: 30.0f];
                [qtz setValue: numberMorningColor forInputKey: @"numberMorningColor"];
                [qtz setValue: numberAfternoonColor forInputKey: @"numberAfternoonColor"];
                [qtz setValue: ledMorningColor forInputKey: @"ledMorningColor"];
                [qtz setValue: ledAfternoonColor forInputKey: @"ledAfternoonColor"];
                
                if ([defaults boolForKey: @"displayNumbers"])
                {
                    [qtz setValue: [NSNumber numberWithBool: YES] forInputKey: @"displayNumbers"];
                }
                else
                {
                    [qtz setValue: [NSNumber numberWithBool: NO]  forInputKey: @"displayNumbers"];
                }

                if ([defaults boolForKey: @"displayHalos"])
                {
                    [qtz setValue: [NSNumber numberWithBool: YES] forInputKey: @"displayHalos"];
                }
                else
                {
                    [qtz setValue: [NSNumber numberWithBool: NO]  forInputKey: @"displayHalos"];
                }

                if ([defaults boolForKey: @"timeAsBackgroundColor"])
                {
                    [qtz setValue: [NSNumber numberWithBool: YES] forInputKey: @"timeAsBackgroundColor"];
                }
                else
                {
                    [qtz setValue: [NSNumber numberWithBool: NO] forInputKey: @"timeAsBackgroundColor"];
                }
                
                [self addSubview: qtz];
                
                [qtz release];
            }
        }
    }
    
    return self;
}

- (void)startAnimation
{
    [qtz startRendering];
    
    [super startAnimation];
}

- (void)stopAnimation
{
    [qtz stopRendering];
    
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow*)configureSheet
{
    if (!configSheet)
    {
        [NSBundle loadNibNamed: @"ConfigSheet" owner: self];
    }
 
    ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName: BinaryClockName];
    
    [numberMorningColorWell setColor: (NSColor*)[NSKeyedUnarchiver unarchiveObjectWithData: [defaults dataForKey: @"numberMorningColor"]]];
    [numberAfternoonColorWell setColor: (NSColor*)[NSKeyedUnarchiver unarchiveObjectWithData: [defaults dataForKey: @"numberAfternoonColor"]]];
    [ledMorningColorWell setColor: (NSColor*)[NSKeyedUnarchiver unarchiveObjectWithData: [defaults dataForKey: @"ledMorningColor"]]];
    [ledAfternoonColorWell setColor: (NSColor*)[NSKeyedUnarchiver unarchiveObjectWithData: [defaults dataForKey: @"ledAfternoonColor"]]];
    [timeAsBackgroundColor setState: [defaults boolForKey: @"timeAsBackgroundColor"]];
    [displayNumbers setState: [defaults boolForKey: @"displayNumbers"]];
    [displayHalos setState: [defaults boolForKey: @"displayHalos"]];
    
    return configSheet;
}

- (IBAction)saveConfig:(id)sender
{
    NSColor *numberMorningColor = [numberMorningColorWell color];
    NSColor *numberAfternoonColor = [numberAfternoonColorWell color];
    NSColor *ledMorningColor = [ledMorningColorWell color];
    NSColor *ledAfternoonColor = [ledAfternoonColorWell color];
    
    ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName: BinaryClockName];

    [defaults setObject: [NSKeyedArchiver archivedDataWithRootObject: numberMorningColor] forKey: @"numberMorningColor"];
	[defaults setObject: [NSKeyedArchiver archivedDataWithRootObject: numberAfternoonColor] forKey: @"numberAfternoonColor"];
    [defaults setObject: [NSKeyedArchiver archivedDataWithRootObject: ledMorningColor] forKey: @"ledMorningColor"];
    [defaults setObject: [NSKeyedArchiver archivedDataWithRootObject: ledAfternoonColor] forKey: @"ledAfternoonColor"];
    [defaults setBool: [timeAsBackgroundColor state] forKey: @"timeAsBackgroundColor"];
    [defaults setBool: [displayNumbers state] forKey: @"displayNumbers"];
    [defaults setBool: [displayHalos state] forKey: @"displayHalos"];
    
    [defaults synchronize];
    
    [qtz setValue: numberMorningColor forInputKey: @"numberMorningColor"];
    [qtz setValue: numberAfternoonColor forInputKey: @"numberAfternoonColor"];
    [qtz setValue: ledMorningColor forInputKey: @"ledMorningColor"];
    [qtz setValue: ledAfternoonColor forInputKey: @"ledAfternoonColor"];
    
    if ([defaults boolForKey: @"displayNumbers"])
    {
        [qtz setValue: [NSNumber numberWithBool: YES] forInputKey: @"displayNumbers"];
    }
    else
    {
        [qtz setValue: [NSNumber numberWithBool: NO] forInputKey: @"displayNumbers"];
    }
    
    if ([defaults boolForKey: @"displayHalos"])
    {
        [qtz setValue: [NSNumber numberWithBool: YES] forInputKey: @"displayHalos"];
    }
    else
    {
        [qtz setValue: [NSNumber numberWithBool: NO]  forInputKey: @"displayHalos"];
    }
    
    if ([defaults boolForKey: @"timeAsBackgroundColor"])
    {
        [qtz setValue: [NSNumber numberWithBool: YES] forInputKey: @"timeAsBackgroundColor"];
    }
    else
    {
        [qtz setValue: [NSNumber numberWithBool: NO] forInputKey: @"timeAsBackgroundColor"];
    }

    [[NSApplication sharedApplication] endSheet:configSheet];
}

- (IBAction)cancelConfig:(id)sender
{
    [[NSApplication sharedApplication] endSheet:configSheet];
}

@end