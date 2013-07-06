//
//  EBLog.h
//  EqBeats
//
//  Created by Tyrone Trevorrow on 6/07/13.
//  Copyright (c) 2013 Sudeium. All rights reserved.
//

#import "TestFlight.h"

#if defined (TESTFLIGHT)
#define EBLog(_fmt_, ...) {TFLog(_fmt_, ##__VA_ARGS__);}
#elif defined (PRE_RELEASE_BUILD) || defined (DEBUG)
#define EBLog(_fmt_, ...) {NSLog((@"%s [Line %i] " _fmt_), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#define EBLog(...)
#endif

