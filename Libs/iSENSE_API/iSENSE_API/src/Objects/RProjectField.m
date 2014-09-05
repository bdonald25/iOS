//
//  RProjectField.m
//  iSENSE_API
//
//  Created by Michael Stowell on 8/21/13.
//  Copyright (c) 2013 Jeremy Poulin. All rights reserved.
//

#import "RProjectField.h"

@implementation RProjectField

@synthesize field_id, name, type, unit;

- (id) init {
    if (self = [super init]) {
        name = @"";
        unit = @"";
    }
    return self;
}

- (id)initWithName:(NSString *)uname Type:(NSNumber *)utype AndUnit:(NSString *)uunit {
    self = [super init];
    if (self) {
        self.name = uname;
        self.type = utype;
        self.unit = uunit;
    }
    return self;
}

-(NSString *)description {
    NSString *objString = [NSString stringWithFormat:@"RProjectField: {\n\tfield_id: %@\n\tname: %@\n\ttype: %@\n\tunit: %@\n}", field_id, name, type, unit];
    return objString;
}

@end
