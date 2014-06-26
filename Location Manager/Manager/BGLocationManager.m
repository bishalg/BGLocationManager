//
//  BGLocationManager.h
//  Listbingo 3
//
//  Created by Bishal Ghimire on 3/25/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import "BGLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface BGLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLLocation        * location;

@end

@implementation BGLocationManager

// Block
void(^locationCompletionHandlerCallBack)(BGLocationManager *locationManager, NSString *errorMsg, NSError *error);

#pragma mark - Init

/**
 *  Description:
 *  init the location Manage
 *  sets the delegate to the self
 *  sets location accuracy to nearest ten meter which then starts the location manger
 *
 *  @return self, LBLocationManager
 */
- (id)init {
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self setAccuracyAndStart:kCLLocationAccuracyNearestTenMeters];
    }
    return self;
}

+ (id)sharedLocationManager {
    static BGLocationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


#pragma mark - Block Invoke Method
- (void)locationWithAccuracy:(CLLocationAccuracy)accuracy withCallBack:(locationCompletionHandler)completionHandler {
    locationCompletionHandlerCallBack = completionHandler;
}

#pragma mark - Location Manager

/*
 *  setAccuracy:locationAccuracy:
 *  kCLLocationAccuracy<x> CLLocationAccuracy
 *      kCLLocationAccuracyBestForNavigation
 *      kCLLocationAccuracyBest
 *      kCLLocationAccuracyNearestTenMeters
 *      kCLLocationAccuracyHundredMeters
 *      kCLLocationAccuracyKilometer
 *      kCLLocationAccuracyThreeKilometer
 *
 *  Description:
 *    Used to specify the accuracy level desired. The location service will try its best to achieve
 *    your desired accuracy. However, it is not guaranteed. To optimize
 *    power performance, be sure to specify an appropriate accuracy for your usage scenario (eg,
 *    use a large accuracy value when only a coarse location is needed).
 */
- (void)setAccuracyAndStart:(CLLocationAccuracy)locationAccuracy {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = locationAccuracy;
    self.locationManager.delegate = self;
    [self startLocationManager];
}

/*
 *  startLocationManager
 *
 *  Description:
 *      Start updating locations.
 */
- (void)startLocationManager {
    [self.locationManager startUpdatingLocation];
}

/*
 *  stopLocationManger
 *
 *  Description:
 *      Stop updating locations.
 */
- (void)stopLocationManger {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Location Info 

- (CLLocation *)locationCurrent {
    return self.location;
}

/**
 *  Description:
 *   Geographical coordinate latitude
 *
 *  @return double - CLLocationDegrees - latitude in degrees.
 */
//- (CLLocationDegrees)latitude {
- (double)locationLatitude {
    return self.location.coordinate.latitude;
}

/**
 *  Description:
 *   Geographical coordinate longitude
 *
 *  @return double - CLLocationDegrees - longitude in degrees.
 */
//- (CLLocationDegrees)longitude {
- (double)locationLongitude {
    return self.location.coordinate.longitude;
}

/**
 *  Description:
 *   A structure that contains a geographical coordinate - latitude & longitude.
 *
 *  @return struct - CLLocationCoordinate2D - Returns the coordinate of the current location.
 */
- (CLLocationCoordinate2D)locationCoordinate {
    return self.location.coordinate;
}

/**
 *  Description:
 *  Geographical coordinate altitude
 *
 *  @return double - CLLocationDistance the altitude of the location. Can be positive (above sea level) or negative (below sea level).
 */
//- (CLLocationDistance)altitude {
- (double)locationAltitude {
    return self.location.altitude;
}

/**
 *  Description:
 *  Horizontal accuracy of the location. Negative if the lateral location is invalid
 *
 *  @return double - CLLocationAccuracy
 *    Type used to represent a location accuracy level in meters. The lower the value in meters, the
 *    more physically precise the location is. A negative accuracy value indicates an invalid location.
 */
// - (CLLocationAccuracy)horizontalAccuracy {
- (double)locationHorizontalAccuracy {
    return self.location.horizontalAccuracy;
}

/**
 *  Description:
 *  Vertical accuracy of the location. Negative if the altitude is invalid.
 *
 *  @return double - CLLocationAccuracy
 *    Type used to represent a location accuracy level in meters. The lower the value in meters, the
 *    more physically precise the location is. A negative accuracy value indicates an invalid location.
 */
//- (CLLocationAccuracy)verticalAccuracy {
- (double)locationVerticalAccuracy {
    return self.location.verticalAccuracy;
}

/**
 *  Description:
 *    The course of the location in degrees true North. Negative if course is invalid.
 *
 *  @return double - CLLocationDirection
 *      Type used to represent the direction in degrees from 0 to 359.9. A negative value indicates an
 *    invalid direction.
 */
//- (CLLocationDirection)course {
- (double)locationCourse {
    return self.location.course;
}

/**
 *  Description:
 *       The speed of the location in m/s. Negative if speed is invalid.
 *
 *  @return double CLLocationSpeed
 */
//- (CLLocationSpeed)speed {
- (double)locationSpeed {
    return self.location.speed;
}

/**
 *  Description:
 *      The timestamp when this location was determined.
 *
 *  @return NSDate -
 */
- (NSDate *)locationTimeDetermined {
    return self.location.timestamp;
}

/**
 *  Returns a string representation of the location.
 *
 *  @return string
 */
- (NSString *)locationDescription {
    return self.location.description;
}

/**
 *  Description
 *
 *  @param fromLocation CLLocation from which distance is to be calculated
 *
 *  @return CLLocationDistance - Type used to represent a distance in meters.
 */
//- (CLLocationDistance)locationDistanceFromLocation:(CLLocation *)fromLocation {
- (double)locationDistanceFromLocation:(CLLocation *)fromLocation {
    return [self.location distanceFromLocation:fromLocation];
}

#pragma mark - Reverse Geocoding

- (void)startReverseGeocoding {
    // Reverse Geocoding
    CLGeocoder *geocoder;
    __block CLPlacemark *placemark;
    __block NSString *address;
    __block BGLocationManager *blockSelf = self;
    geocoder = [[CLGeocoder alloc] init];
    
    // geocoding handler, CLPlacemarks are provided in order of most confident to least confident
    [geocoder reverseGeocodeLocation:self.location  completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            address = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                       placemark.subThoroughfare, placemark.thoroughfare,
                       placemark.postalCode, placemark.locality,
                       placemark.administrativeArea,
                       placemark.country];
            if ([blockSelf.delegate respondsToSelector:@selector(lbLocationManager:reverseGeocodeLocationAddress:andPlaceMarks:)]) {
                [blockSelf.delegate lbLocationManager:self reverseGeocodeLocationAddress:address andPlaceMarks:placemark];
            }
        } else {
            if ([blockSelf.delegate respondsToSelector:@selector(lbLocationManager:reverseGeocodeErrorMsg:andError:)]) {
                [blockSelf.delegate lbLocationManager:self reverseGeocodeErrorMsg:@"Erro in Revers GeoCoding" andError:error];
            }
            NSLog(@"Error %@", error.debugDescription);
        }
    } ];
}

#pragma mark - Location Manager Delegates

/*
 * locationManager:didUpdateLocations:
 *
 *  Discussion:
 *     Invoked when new locations are available.
 *     locations is an array of CLLocation objects in chronological order.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // Last object contains the most recent location
    CLLocation *newLocation = [locations lastObject];
    self.location = newLocation;
    
    // If the location is more than 2 minutes old, ignore it
    // if([newLocation.timestamp timeIntervalSinceNow] > 120) return;
    
    [self stopLocationManger];
    if ([self.delegate respondsToSelector:@selector(lbLocationManager:didUpdateWithLocation:)]) {
        [self.delegate lbLocationManager:self didUpdateWithLocation:self.location];
    }
    if ([self respondsToSelector:@selector(locationCompletionHandlerCallBack)]) {
        locationCompletionHandlerCallBack(self, nil, nil);
    }
}

/*
 *  locationManager:didChangeAuthorizationStatus:
 *
 *  Discussion:
 *    Invoked when the authorization status changes for this application.
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSString *errorMsg = nil;
    NSError *error = nil;
    if([CLLocationManager locationServicesEnabled]) {
        // Location Services Are Enabled
        switch([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                // User has not yet made a choice with regards to this application
                errorMsg = NSLocalizedString(@"Access denied by the user", @"User has not yet made a choice");
                if ([self.delegate respondsToSelector:@selector(lbLocationManager:didFailWithErrorMsg:andError:)]) {
                    [self.delegate lbLocationManager:self didFailWithErrorMsg:errorMsg andError:error];
                }
                if ([self respondsToSelector:@selector(locationCompletionHandlerCallBack)]) {
                    locationCompletionHandlerCallBack(self, errorMsg, error);
                }
                break;
            case kCLAuthorizationStatusRestricted:
                // This application is not authorized to use location services.  Due
                // to active restrictions on location services, the user cannot change
                // this status, and may not have personally denied authorization
                errorMsg = NSLocalizedString(@"Access denied by the server", @"Application is not authorized to use location services");
                if ([self.delegate respondsToSelector:@selector(lbLocationManager:didFailWithErrorMsg:andError:)]) {
                    [self.delegate lbLocationManager:self didFailWithErrorMsg:errorMsg andError:error];
                }
                if ([self respondsToSelector:@selector(locationCompletionHandlerCallBack)]) {
                    locationCompletionHandlerCallBack(self, errorMsg, error);
                }
                break;
            case kCLAuthorizationStatusDenied:
                // User has explicitly denied authorization for this application, or
                // location services are disabled in Settings
                errorMsg = NSLocalizedString(@"Access denied by the user", @"Location Services Disabled");
                if ([self.delegate respondsToSelector:@selector(lbLocationManager:didFailWithErrorMsg:andError:)]) {
                    [self.delegate lbLocationManager:self didFailWithErrorMsg:errorMsg andError:error];
                }
                if ([self respondsToSelector:@selector(locationCompletionHandlerCallBack)]) {
                    locationCompletionHandlerCallBack(self, errorMsg, error);
                }
                break;
            case kCLAuthorizationStatusAuthorized:
                [self startLocationManager];
                // User has authorized this application to use location services
                break;
        }
    } else {
        // Location Services Disabled
        errorMsg = NSLocalizedString(@"Access denied by the user", @"Location Services Disabled");
        if ([self.delegate respondsToSelector:@selector(lbLocationManager:didFailWithErrorMsg:andError:)]) {
            [self.delegate lbLocationManager:self didFailWithErrorMsg:errorMsg andError:error];
        }
        if ([self respondsToSelector:@selector(locationCompletionHandlerCallBack)]) {
            locationCompletionHandlerCallBack(self, errorMsg, error);
        }
    }
}

/*
 *  locationManager:didFailWithError:
 *
 *  Discussion:
 *    Invoked when an error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self stopLocationManger];
    NSLog(@"Error: %@",[error localizedDescription]);
    NSString *errorMsg;
    switch([error code]) {
        case kCLErrorLocationUnknown:
            errorMsg = NSLocalizedString(@"Location is Currently Unknown", @"location is currently unknown, but CL will keep trying");
             // location is currently unknown, but CL will keep trying
            break;
        case kCLErrorDenied:
            errorMsg = NSLocalizedString(@"Access denied by the user",@"Access to location or ranging has been denied by the user");
            // Access to location or ranging has been denied by the user
            break;
        case kCLErrorNetwork:
            errorMsg = NSLocalizedString(@"Location is Currently Unknown",@"general, network-related error");
            // general, network-related error
            break;
        default:
            errorMsg = NSLocalizedString(@"Location is Currently Unknown",@"default erros");
            break;
    }
    if ([self.delegate respondsToSelector:@selector(lbLocationManager:didFailWithErrorMsg:andError:)]) {
        [self.delegate lbLocationManager:self didFailWithErrorMsg:errorMsg andError:error];
    }
    if ([self respondsToSelector:@selector(locationCompletionHandlerCallBack)]) {
        locationCompletionHandlerCallBack(self, errorMsg, error);
    }
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    [self startLocationManager];
}

/**
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error {
    
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    
}
*/

@end
