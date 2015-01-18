//
//  AppiumEnvironmentVariablesTableView.m
//  Appium
//
//  Created by Dan Cuellar on 09/01/2015.
//  Copyright (c) 2015 Appium. All rights reserved.
//

#import "AppiumGeneralSettingsPopOverViewController.h"
#import "AppiumAppDelegate.h"

#define TABLE_COLUMNS @[@"KeyCellView", @"ValueCellView"]

@interface AppiumGeneralSettingsPopOverViewController()

@property (readonly) NSArray *environmentVariables;
@property (nonatomic, strong) NSMutableArray *delegates;

@end

@implementation AppiumGeneralSettingsPopOverViewController

#pragma mark -

- (IBAction)addButtonClicked:(id)sender {
	AppiumGeneralSettingsModel *generalSettings = ((AppiumAppDelegate*)[[NSApplication sharedApplication] delegate]).model.general;
	[generalSettings setEnvironmentVariables:[@[@{@"key":@"NEW_KEY",@"value":@"NEW_VALUE"}] arrayByAddingObjectsFromArray:self.environmentVariables]];
	[self.environmentVariablesTableView reloadData];
}

- (IBAction)deleteButtonClicked:(id)sender {
	AppiumGeneralSettingsModel *generalSettings = ((AppiumAppDelegate*)[[NSApplication sharedApplication] delegate]).model.general;
	NSMutableArray *envVars = [self.environmentVariables mutableCopy];
	[envVars removeObjectsAtIndexes:self.environmentVariablesTableView.selectedRowIndexes];
	[generalSettings setEnvironmentVariables:envVars];
	[self.environmentVariablesTableView reloadData];
}

#pragma mark - Environment Variables Table View Delegate / Data Source

- (NSArray*) environmentVariables {

	// sanitize environment variables
	NSArray *envVars = ((AppiumAppDelegate*)[[NSApplication sharedApplication] delegate]).model.general.environmentVariables;
	NSMutableArray *finalVars = [NSMutableArray new];
	for (NSDictionary *var in envVars) {
		if ([var objectForKey:@"key"] && [var objectForKey:@"value"]) {
			[finalVars addObject:var];
		}
	}
	[((AppiumAppDelegate*)[[NSApplication sharedApplication] delegate]).model.general setEnvironmentVariables:finalVars];
	
	return finalVars;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return self.environmentVariables.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	BOOL isKey = [tableColumn.identifier isEqualToString:@"KeyCellView"];
	return [[((NSArray*)[self environmentVariables]) objectAtIndex:row] valueForKey:isKey ? @"key" : @"value"];
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
				  row:(NSInteger)row {
 
	BOOL isKey = [tableColumn.identifier isEqualToString:@"KeyColumn"];
	NSString *resultId = isKey ? @"KeyCellView" : @"ValueCellView";
	
	NSTableCellView *result = [tableView makeViewWithIdentifier:resultId owner:self];
	if (result == nil) {
		result = [[NSTableCellView alloc] initWithFrame:NSMakeRect(0, 0, tableView.frame.size.width, 1)];
		result.identifier = resultId;
	}
	result.backgroundStyle = NSBackgroundStyleLight;
	
	// set value
	NSDictionary *keyValuePair = [((NSArray*)self.environmentVariables) objectAtIndex:row];
	NSString *value = [keyValuePair valueForKey: isKey ? @"key" : @"value"];
	result.textField.stringValue = value;
	result.textField.editable = YES;
	
	// add delegate
	AppiumEnvironmentVariableTextFieldDelegate *delegate = [AppiumEnvironmentVariableTextFieldDelegate new];
	delegate.index = row;
	delegate.isKey = isKey;
	delegate.tableView = tableView;
	[self.delegates addObject:delegate];
	[result.textField setDelegate:delegate];
 
	// Return the result
	return result;
}

- (NSMutableArray *)delegates {
	
	if (!_delegates) {
		_delegates = [NSMutableArray array];
	}
	
	return _delegates;
}

@end

@implementation AppiumEnvironmentVariableTextFieldDelegate

- (void)controlTextDidEndEditing:(NSNotification *)notification {
	NSString *textFieldText = [((NSTextField*)[notification object]) stringValue];
	NSMutableArray *envVars = [((AppiumAppDelegate*)[[NSApplication sharedApplication] delegate]).model.general.environmentVariables mutableCopy];
	NSDictionary *oldKVP = [envVars objectAtIndex:self.index];
	NSString *newKey = self.isKey ? textFieldText : [oldKVP valueForKey:@"key"];
	NSString *newValue = self.isKey ? [oldKVP valueForKey:@"value"] : textFieldText;
	[envVars replaceObjectAtIndex:self.index withObject:@{@"key":newKey, @"value":newValue}];
	[((AppiumAppDelegate*)[[NSApplication sharedApplication] delegate]).model.general setEnvironmentVariables:envVars];
}

@end
