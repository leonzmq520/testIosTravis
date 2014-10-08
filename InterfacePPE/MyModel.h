//
//  MyModel.h
//  BlueClient
//
//  Created by bagurdorian on 23/12/13.
//  Copyright (c) 2013 bagurdorian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface MyModel : NSObject

<CBCentralManagerDelegate, CBPeripheralDelegate>



//user properties
@property NSString* login;
@property NSString* password;
@property NSString* ville;
@property int sex;
@property double weight;
@property int age;
@property double latitude;
@property double longitude;
@property double bac;


//message properties
@property NSString* destinataire;
@property NSString* contenu;

//States
@property BOOL isLogged;
@property BOOL connectionFinished;
@property BOOL loginAvailable;
@property BOOL signedUp;
@property BOOL updated;
@property BOOL messageSent;
@property BOOL onChat;

//Web service
@property NSString* url;
@property NSMutableData *receivedData;
@property NSMutableURLRequest *theRequest;
@property NSURLConnection *signinConnection;
@property NSURLConnection *userdataConnection;
@property NSURLConnection *busConnection;
@property NSURLConnection *metroConnection;
@property NSURLConnection *samConnection;
@property NSURLConnection *taxiConnection;
@property NSURLConnection *signUpConnection;
@property NSURLConnection *checkLoginConnection;
@property NSURLConnection *updateConnection;
@property NSURLConnection *sendConnection;
@property NSURLConnection *receiveConnection;
@property NSURLConnection *conversationConnection;


//Data received
@property NSMutableArray *BUS;
@property NSMutableArray *METRO;
@property NSMutableArray *SAM;
@property NSMutableArray *TAXI;
@property NSMutableArray *CONVERSATION;
@property NSMutableArray *MESSAGES;

//Plist properties
@property NSString *fichier;

//BLE
@property (nonatomic, strong) CBCentralManager *manager ;
@property CBPeripheral *peripheral;
@property CBService *service;
@property NSArray *characteristic;
@property (nonatomic, strong) NSMutableData *dataReceived;
@property (nonatomic, strong) NSMutableData *dataSent;


@property NSMutableArray *dataReceivedList;

@property bool connected;
@property bool response;

//methods
- (id) init;
-(void) GetUsers;
-(NSDictionary*) getConnectedUser:(NSArray*)Users;
-(NSArray*) readPlist;
-(void) writePlist;
-(void) signIn;
-(void) getUserData;
-(void) getBus;
-(void) getMetro;
-(void) getSam;
-(void) getTaxi;
-(void) signUp;
-(void) checkLogin;
-(void) update:(NSString *)stringdata;
-(void) conversationMessage;
-(void) receiveMessage;
-(void) sendMessage;


+ (int) convertHexToInt:(unsigned char) byte1 byte:(unsigned char) byte2;
+ (double) convertValueToBAC:(int)value;

@end
