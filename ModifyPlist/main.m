//
//  main.m
//  ModifyPlist
//
//  Created by ludawei on 14-1-27.
//  Copyright (c) 2014年 platomix.dw. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    void modifyPlist();
    @autoreleasepool {
        
        // insert code here...
//        NSLog(@"Hello, World!");
        modifyPlist();
        
    }
    return 0;
}


void modifyPlist()
{
    // plist所在路径
    NSString *plistPath = @"/Users/yuanwei/Library/Developer/Xcode/Templates/Project\ Templates/Empty\ Application-for-me.xctemplate/TemplateInfo.plist";
    
    NSString *path_dir = [plistPath stringByDeletingLastPathComponent];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path_dir];
    
    NSMutableArray *dirList = [NSMutableArray arrayWithCapacity:100];
    NSMutableArray *fileList = [NSMutableArray arrayWithCapacity:100];
    
    NSString *path;
    while ((path = [dirEnum nextObject]) != nil)
    {
        NSString *tempPath = [path_dir stringByAppendingPathComponent:path];
        if ([[[fm attributesOfItemAtPath:tempPath error:nil] fileType] isEqualToString:NSFileTypeDirectory]) {
            if ([fm contentsOfDirectoryAtPath:tempPath error:nil].count == 0) {
                [dirList addObject:path];
            }
            continue;
        }
        
        if ([path hasPrefix:@"TemplateI"] || [path hasPrefix:@"."]) {
            continue;
        }
        [fileList addObject:path];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSMutableDictionary *dict_Definitions = [NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"Definitions"]];
    NSMutableSet *arr_Nodes = [NSMutableSet setWithArray:[dict objectForKey:@"Nodes"]];
    
    for (NSString *file in fileList) {
        [arr_Nodes addObject:file];
        
        NSDictionary *tempDict = @{@"Group" : @[[file stringByDeletingLastPathComponent]], @"Path" : [@"." stringByAppendingPathComponent:file]};
        [dict_Definitions setObject:tempDict forKey:file];
    }
    
    for (NSString *file in dirList) {
        [arr_Nodes addObject:file];
        
        NSDictionary *tempDict = @{@"Path" : [@"." stringByAppendingPathComponent:file]};
        [dict_Definitions setObject:tempDict forKey:file];
    }
    
    [dict setObject:dict_Definitions forKey:@"Definitions"];
    [dict setObject:arr_Nodes.allObjects forKey:@"Nodes"];
    
    BOOL isOk = [dict writeToFile:plistPath atomically:YES];
    if (isOk) {
        NSLog(@"success");
        //        [self.statusText setStringValue:@"修改完成"];
    }
    else{
        NSLog(@"failed");
    }
}
