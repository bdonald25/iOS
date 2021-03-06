/*
 * iSENSE Project - isenseproject.org
 * This file is part of the iSENSE iOS API and applications.
 *
 * Copyright (c) 2015, University of Massachusetts Lowell. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer. Redistributions in binary
 * form must reproduce the above copyright notice, this list of conditions and
 * the following disclaimer in the documentation and/or other materials
 * provided with the distribution. Neither the name of the University of
 * Massachusetts Lowell nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 * BSD 3-Clause License
 * http://opensource.org/licenses/BSD-3-Clause
 *
 * Our work is supported by grants DRL-0735597, DRL-0735592, DRL-0546513, IIS-1123998,
 * and IIS-1123972 from the National Science Foundation and a gift from Google Inc.
 *
 */

//
// Fields.h
// iSENSE_API
//
// Created by Mike Stowell on 3/4/13.
//

#import <Foundation/Foundation.h>

@interface DataContainer : NSObject {}

@property (retain) NSMutableDictionary* data;
-(void) addData:(NSString *)dataValue forKey:(NSString *)dataKey;

// Fields string constants
#define sNULL_STRING    @"nil"
#define sACCEL_X        @"Accel-X"
#define sACCEL_Y        @"Accel-Y"
#define sACCEL_Z        @"Accel-Z"
#define sACCEL_TOTAL    @"Accel-Total"
#define sTEMPERATURE_C  @"Temperature-C"
#define sTEMPERATURE_F  @"Temperature-F"
#define sTEMPERATURE_K  @"Temperature-K"
#define sTIME_MILLIS    @"Time"
#define sLUX            @"Luminous Flux"
#define sANGLE_DEG      @"Angle-Deg"
#define sANGLE_RAD      @"Angle-Rad"
#define sLATITUDE       @"Latitude"
#define sLONGITUDE      @"Longitude"
#define sMAG_X          @"Magnetic-X"
#define sMAG_Y          @"Magnetic-Y"
#define sMAG_Z          @"Magnetic-Z"
#define sMAG_TOTAL      @"Magnetic-Total"
#define sALTITUDE       @"Altitude"
#define sPRESSURE       @"Pressure"
#define sGYRO_X         @"Gyroscope-X"
#define sGYRO_Y         @"Gyroscope-Y"
#define sGYRO_Z         @"Gyroscope-Z"

@end
