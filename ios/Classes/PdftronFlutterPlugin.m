#import "PdftronFlutterPlugin.h"

static NSString * const PTDisabledToolsKey = @"disabledTools";
static NSString * const PTDisabledElementsKey = @"disabledElements";
static NSString * const PTMultiTabEnabledKey = @"multiTabEnabled";

@interface PdftronFlutterPlugin () <PTTabbedDocumentViewControllerDelegate, PTDocumentViewControllerDelegate>

@property (nonatomic, strong) id config;

@end

@implementation PdftronFlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"pdftron_flutter"
            binaryMessenger:[registrar messenger]];
  PdftronFlutterPlugin* instance = [[PdftronFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

-(void)disableTools:(NSArray*)toolsToDisable documentViewController:(PTDocumentViewController *)documentViewController
{
    for(NSObject* item in toolsToDisable)
    {
        BOOL value = NO;
        
        if( [item isKindOfClass:[NSString class]])
        {
            NSString* string = (NSString*)item;
            
            if( [string isEqualToString:@"AnnotationEdit"] )
            {
                // multi-select not implemented
            }
            else if( [string isEqualToString:@"AnnotationCreateSticky"] || [string isEqualToString:@"stickyToolButton"] )
            {
                documentViewController.toolManager.textAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreateFreeHand"] || [string isEqualToString:@"freeHandToolButton"] )
            {
                documentViewController.toolManager.inkAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"TextSelect"] )
            {
                documentViewController.toolManager.textSelectionEnabled = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreateTextHighlight"] || [string isEqualToString:@"highlightToolButton"] )
            {
                documentViewController.toolManager.highlightAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreateTextUnderline"] || [string isEqualToString:@"underlineToolButton"] )
            {
                documentViewController.toolManager.underlineAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreateTextSquiggly"] || [string isEqualToString:@"squigglyToolButton"] )
            {
                documentViewController.toolManager.squigglyAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreateTextStrikeout"] || [string isEqualToString:@"strikeoutToolButton"] )
            {
                documentViewController.toolManager.strikeOutAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreateFreeText"] || [string isEqualToString:@"freeTextToolButton"] )
            {
                documentViewController.toolManager.freeTextAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreateCallout"] || [string isEqualToString:@"calloutToolButton"] )
            {
                // not supported
            }
            else if ( [string isEqualToString:@"AnnotationCreateSignature"] || [string isEqualToString:@"signatureToolButton"] )
            {
                documentViewController.toolManager.signatureAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreateLine"] || [string isEqualToString:@"lineToolButton"] )
            {
                documentViewController.toolManager.lineAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreateArrow"] || [string isEqualToString:@"arrowToolButton"] )
            {
                documentViewController.toolManager.arrowAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreatePolyline"] || [string isEqualToString:@"polylineToolButton"] )
            {
                documentViewController.toolManager.polylineAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreateStamp"] || [string isEqualToString:@"stampToolButton"] )
            {
                documentViewController.toolManager.stampAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreateRectangle"] || [string isEqualToString:@"rectangleToolButton"] )
            {
                documentViewController.toolManager.squareAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreateEllipse"] || [string isEqualToString:@"ellipseToolButton"] )
            {
                documentViewController.toolManager.circleAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreatePolygon"] || [string isEqualToString:@"polygonToolButton"] )
            {
                documentViewController.toolManager.polygonAnnotationOptions.canCreate = value;
            }
            else if ( [string isEqualToString:@"AnnotationCreatePolygonCloud"] || [string isEqualToString:@"cloudToolButton"] )
            {
                documentViewController.toolManager.cloudyAnnotationOptions.canCreate = value;
            }
            
        }
    }
}

-(void)disableElements:(NSArray*)elementsToDisable documentViewController:(PTDocumentViewController *)documentViewController
{
    typedef void (^HideElementBlock)(void);
    
    NSDictionary *hideElementActions = @{
                                         @"toolsButton":
                                             ^{
                                                 documentViewController.annotationToolbarButtonHidden = YES;
                                             },
                                         @"searchButton":
                                             ^{
                                                 documentViewController.searchButtonHidden = YES;
                                             },
                                         @"shareButton":
                                             ^{
                                                 documentViewController.shareButtonHidden = YES;
                                             },
                                         @"viewControlsButton":
                                             ^{
                                                 documentViewController.viewerSettingsButtonHidden = YES;
                                             },
                                         @"thumbnailsButton":
                                             ^{
                                                 documentViewController.thumbnailBrowserButtonHidden = YES;
                                             },
                                         @"listsButton":
                                             ^{
                                                 documentViewController.navigationListsButtonHidden = YES;
                                             },
                                         @"thumbnailSlider":
                                             ^{
                                                 documentViewController.thumbnailSliderHidden = YES;
                                             }
                                         };
    
    
    for(NSObject* item in elementsToDisable)
    {
        if( [item isKindOfClass:[NSString class]])
        {
            HideElementBlock block = hideElementActions[item];
            if (block)
            {
                block();
            }
        }
    }
    
    [self disableTools:elementsToDisable documentViewController:documentViewController];
}

-(void)configureTabbedDocumentViewController:(PTTabbedDocumentViewController*)tabbedDocumentViewController withConfig:(NSString*)config
{
    if( config && ![config isEqualToString:@"null"] )
    {
        //convert from json to dict
        NSData* jsonData = [config dataUsingEncoding:NSUTF8StringEncoding];
        id foundationObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:Nil];
        
        NSAssert( [foundationObject isKindOfClass:[NSDictionary class]], @"config JSON object not in expected dictionary format." );
        
        if( [foundationObject isKindOfClass:[NSDictionary class]] )
        {
            NSDictionary* configPairs = (NSDictionary*)foundationObject;
            
            for (NSString* key in configPairs.allKeys) {
                if ([key isEqualToString:PTMultiTabEnabledKey]) {
                    id multiTabEnabledValue = configPairs[PTMultiTabEnabledKey];
                    if ([multiTabEnabledValue isKindOfClass:[NSNumber class]]) {
                        BOOL multiTabEnabled = ((NSNumber *)multiTabEnabledValue).boolValue;
                        tabbedDocumentViewController.tabsEnabled = multiTabEnabled;
                    }
                }
            }
        }
        else
        {
            NSLog(@"config JSON object not in expected dictionary format.");
        }
    }
}

-(void)configureDocumentViewController:(PTDocumentViewController*)documentViewController withConfig:(NSString*)config
{
    if( config && ![config isEqualToString:@"null"] )
    {
        //convert from json to dict
        NSData* jsonData = [config dataUsingEncoding:NSUTF8StringEncoding];
        id foundationObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:Nil];

        NSAssert( [foundationObject isKindOfClass:[NSDictionary class]], @"config JSON object not in expected dictionary format." );
        
        if( [foundationObject isKindOfClass:[NSDictionary class]] )
        {
            NSDictionary* configPairs = (NSDictionary*)foundationObject;
            
            for (NSString* key in configPairs.allKeys) {
                if( [key isEqualToString:PTDisabledToolsKey] )
                {
                    id toolsToDisable = configPairs[PTDisabledToolsKey];
                    if( ![toolsToDisable isEqual:[NSNull null]] )
                    {
                        NSAssert( [toolsToDisable isKindOfClass:[NSArray class]], @"disabledTools JSON object not in expected array format." );
                        if( [toolsToDisable isKindOfClass:[NSArray class]] )
                        {
                            [self disableTools:(NSArray*)toolsToDisable documentViewController:documentViewController];
                        }
                        else
                        {
                            NSLog(@"disabledTools JSON object not in expected array format.");
                        }
                    }
                }
                else if( [key isEqualToString:PTDisabledElementsKey] )
                {
                    id elementsToDisable = configPairs[PTDisabledElementsKey];
                    
                    if( ![elementsToDisable isEqual:[NSNull null]] )
                    {
                        NSAssert( [elementsToDisable isKindOfClass:[NSArray class]], @"disabledTools JSON object not in expected array format." );
                        if( [elementsToDisable isKindOfClass:[NSArray class]] )
                        {
                            [self disableElements:(NSArray*)elementsToDisable documentViewController:documentViewController];
                        }
                        else
                        {
                            NSLog(@"disabledTools JSON object not in expected array format.");
                        }
                    }
                }
                else if ([key isEqualToString:PTMultiTabEnabledKey]) {
                    // Handled by tabbed config.
                }
                else
                {
                    NSLog(@"Unknown JSON key in config: %@.", key);
                    NSAssert( false, @"Unknown JSON key in config." );
                }
            }
        }
        else
        {
            NSLog(@"config JSON object not in expected dictionary format.");
        }
    }
}

- (void)handleOpenDocumentMethod:(NSDictionary<NSString *, id> *)arguments
{
    // Get document argument.
    NSString *document = nil;
    id documentValue = arguments[@"document"];
    if ([documentValue isKindOfClass:[NSString class]]) {
        document = (NSString *)documentValue;
    }
    
    if (document.length == 0) {
        // error handling
        return;
    }
    
    // Get (optional) password argument.
    NSString *password = nil;
    id passwordValue = arguments[@"password"];
    if ([passwordValue isKindOfClass:[NSString class]]) {
        password = (NSString *)passwordValue;
    }
    
    // Create and wrap a tabbed controller in a navigation controller.    
    self.tabbedDocumentViewController = [[PTTabbedDocumentViewController alloc] init];
    self.tabbedDocumentViewController.delegate = self;
    self.tabbedDocumentViewController.tabsEnabled = NO;
    
    self.tabbedDocumentViewController.restorationIdentifier = [NSUUID UUID].UUIDString;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.tabbedDocumentViewController];
    
    self.tabbedDocumentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(topLeftButtonPressed:)];
    
    NSString* config = arguments[@"config"];
    self.config = config;
    
    [self configureTabbedDocumentViewController:self.tabbedDocumentViewController withConfig:config];
    
    // Open a file URL.
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:document withExtension:@"pdf"];
    if ([document containsString:@"://"]) {
        fileURL = [NSURL URLWithString:document];
    } else if ([document hasPrefix:@"/"]) {
        fileURL = [NSURL fileURLWithPath:document];
    }
    
    [self.tabbedDocumentViewController openDocumentWithURL:fileURL password:password];
    
    UIViewController *presentingViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    // Show navigation (and tabbed) controller.
    [presentingViewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"getVersion" isEqualToString:call.method]) {
        result([@"PDFNet " stringByAppendingFormat:@"%f", [PTPDFNet GetVersion]]);
    } else if ([@"initialize" isEqualToString:call.method]) {
        NSString *licenseKey = call.arguments[@"licenseKey"];
        [PTPDFNet Initialize:licenseKey];
    } else if ([@"openDocument" isEqualToString:call.method]) {
        [self handleOpenDocumentMethod:call.arguments];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)topLeftButtonPressed:(UIBarButtonItem *)barButtonItem
{
    if (self.tabbedDocumentViewController) {
        [self.tabbedDocumentViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [UIApplication.sharedApplication.keyWindow.rootViewController.presentedViewController dismissViewControllerAnimated:YES completion:Nil];
    }
}

- (void)tabbedDocumentViewController:(PTTabbedDocumentViewController *)tabbedDocumentViewController willAddDocumentViewController:(PTDocumentViewController *)documentViewController
{
    documentViewController.delegate = self;
    
    [self configureDocumentViewController:documentViewController withConfig:self.config];
}

- (void)documentViewControllerDidOpenDocument:(PTDocumentViewController *)documentViewController
{
    NSLog(@"Document opened successfully");
}

- (void)documentViewController:(PTDocumentViewController *)documentViewController didFailToOpenDocumentWithError:(NSError *)error
{
    NSLog(@"Failed to open document: %@", error);
}

@end
