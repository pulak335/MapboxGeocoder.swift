@import MapKit;
@import CoreLocation;
@import MapboxGeocoder;

#import "ViewController.h"

// A Mapbox access token is required to use the Geocoding API.
// https://www.mapbox.com/help/create-api-access-token/
NSString *const MapboxAccessToken = @"<# your Mapbox access token #>";

@interface ViewController () <MKMapViewDelegate>

#pragma mark - Variables

@property (nonatomic) MKMapView *mapView;
@property (nonatomic) UILabel *resultsLabel;
@property (nonatomic) MBGeocoder *geocoder;

@end

#pragma mark -

@implementation ViewController

#pragma mark - Setup


- (void)viewDidLoad {
    [super viewDidLoad];

    NSAssert(![MapboxAccessToken isEqualToString:@"<# your Mapbox access token #>"], @"You must set `MapboxAccessToken` to your Mapbox access token.");

    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];

    self.resultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.view.bounds.size.width - 20, 30)];
    self.resultsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.resultsLabel.adjustsFontSizeToFitWidth = YES;
    self.resultsLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    self.resultsLabel.userInteractionEnabled = NO;
    [self.view addSubview:self.resultsLabel];

    self.geocoder = [[MBGeocoder alloc] initWithAccessToken:MapboxAccessToken];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    [self.geocoder cancelGeocode];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self.geocoder cancelGeocode];
    [self.geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude] completionHandler:^(NSArray<MBPlacemark *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else if (results.count > 0) {
            self.resultsLabel.text = results[0].name;
        } else {
            self.resultsLabel.text = @"No results";
        }
    }];
}

@end
