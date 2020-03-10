//
//  NSIndexPath+Flatten.m
//  StudentsBrowser
//
//  Created by Digital on 10/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "NSIndexPath+Flatten.h"

@implementation NSIndexPath (Flatten)

- (NSInteger)flattenIndexPathForTableView:(UITableView *)tableView {
    NSInteger sum = self.row;
    for (int section = 0; section < self.section; section++)
        sum += [tableView numberOfRowsInSection:section];
    return sum;
}

@end
