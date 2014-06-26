//
//  BGLocationManager.h
//  Listbingo 3
//
//  Created by Bishal Ghimire on 3/25/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/*
*    Represents placemark data for a geographic location. Placemark data can be
*    information such as the country, state, city, and street address.
*/
@class CLPlacemark;

@protocol BGLocationManagerDelegate;

@interface BGLocationManager : NSObject

// BLOCK json Loading handler
typedef void (^locationCompletionHandler)(BGLocationManager *locationManager, NSString *errorMsg, NSError *error);

@property (nonatomic, weak) id<BGLocationManagerDelegate>delegate;

+ (id)sharedLocationManager;
// Block Method
- (void)locationWithAccuracy:(CLLocationAccuracy)accuracy withCallBack:(locationCompletionHandler)completionHandler;


// Location Manager
- (void)setAccuracyAndStart:(CLLocationAccuracy)locationAccuracy;
- (void)startLocationManager;
- (void)stopLocationManger;

// Location Info
- (CLLocation *)locationCurrent;

/**
 *  Description:
 *   Geographical coordinate latitude
 *
 *  @return double - CLLocationDegrees - latitude in degrees.
 */
- (double)locationLatitude;
- (double)locationLongitude;
- (CLLocationCoordinate2D)locationCoordinate;
- (double)locationAltitude;
- (double)locationHorizontalAccuracy;
- (double)locationVerticalAccuracy;
- (double)locationCourse;
- (double)locationSpeed;
- (double)locationDistanceFromLocation:(CLLocation *)fromLocation;

- (NSDate *)locationTimeDetermined;
- (NSString *)locationDescription;

// ReverseGeocoding
- (void)startReverseGeocoding;

@end

// Delegates

@protocol BGLocationManagerDelegate <NSObject>
@optional
// Location
- (void)lbLocationManager:(BGLocationManager *)locationManager didUpdateWithLocation:(CLLocation *)location;
- (void)lbLocationManager:(BGLocationManager *)locationManager didFailWithErrorMsg:(NSString *)errorMsg andError:(NSError *)error;
// Reverse Geocoding
- (void)lbLocationManager:(BGLocationManager *)locationManager reverseGeocodeLocationAddress:(NSString *)address  andPlaceMarks:(CLPlacemark *)placemark;
- (void)lbLocationManager:(BGLocationManager *)locationManager reverseGeocodeErrorMsg:(NSString *)errorMsg andError:(NSError *)error;

@end
