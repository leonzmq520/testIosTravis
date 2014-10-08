//
//  MyModel.m
//  BlueClient
//
//  Created by bagurdorian on 23/12/13.
//  Copyright (c) 2013 bagurdorian. All rights reserved.
//

#import "MyModel.h"

static NSString * const peripheralUUID = @"72DA83C8-C1B8-81ED-185F-63FAF7BB4ED0";
//static NSString * const ServiceUUID1 = @"713D0000-503E-4C75-BA94-3148F18D941E";
static NSString * const ServiceUUID1 = @"fff0";
//static NSString * const CharacteristicUUID1 =@"713D0001-503E-4C75-BA94-3148F18D941E";
static NSString * const CharacteristicUUID1 =@"fff1";
//static NSString * const CharacteristicUUID2 =@"713D0002-503E-4C75-BA94-3148F18D941E";
static NSString * const CharacteristicUUID2 =@"fff2";
//static NSString * const CharacteristicUUID3 =@"713D0003-503E-4C75-BA94-3148F18D941E";
static NSString * const CharacteristicUUID3 =@"fff3";

static NSString * const CharacteristicUUID4 =@"713D0004-503E-4C75-BA94-3148F18D941E";
static NSString * const CharacteristicUUID5 =@"713D0005-503E-4C75-BA94-3148F18D941E";



//BLE
@implementation MyModel

@synthesize manager;
@synthesize peripheral;
@synthesize service;
@synthesize characteristic;
@synthesize dataReceived;
@synthesize dataSent;

@synthesize dataReceivedList;
@synthesize connected;
@synthesize response;


//BDD
@synthesize login;
@synthesize password;
@synthesize latitude;
@synthesize longitude;
@synthesize ville;
@synthesize sex;
@synthesize weight;
@synthesize age;
@synthesize bac;

@synthesize destinataire;
@synthesize contenu;


@synthesize isLogged;
@synthesize connectionFinished;
@synthesize loginAvailable;
@synthesize signedUp;
@synthesize updated;
@synthesize messageSent;
@synthesize onChat;



@synthesize url;
@synthesize signinConnection;
@synthesize userdataConnection;
@synthesize busConnection;
@synthesize metroConnection;
@synthesize samConnection;
@synthesize taxiConnection;
@synthesize signUpConnection;
@synthesize checkLoginConnection;
@synthesize updateConnection;
@synthesize theRequest;
@synthesize receivedData;
@synthesize sendConnection;
@synthesize receiveConnection;
@synthesize conversationConnection;

@synthesize BUS;
@synthesize METRO;
@synthesize SAM;
@synthesize TAXI;
@synthesize CONVERSATION;
@synthesize MESSAGES;

@synthesize fichier;

- (id) init
{
    if(self=[super init])
    {
        /** .plist **/
        //on récupère le chemin du répertoire de stockage
        NSArray *listeEmplacement = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *emplacement = [listeEmplacement lastObject];
        //on stocke l'emplacement du fichier de stockage dans une variabe
        fichier = [[NSString alloc] initWithString:[emplacement stringByAppendingFormat:@"/userData.plist"]];
        
        /** web **/
        BUS=[[NSMutableArray alloc] init];
        METRO=[[NSMutableArray alloc] init];
        SAM=[[NSMutableArray alloc] init];
        TAXI=[[NSMutableArray alloc] init];
        CONVERSATION=[[NSMutableArray alloc] init];
        MESSAGES=[[NSMutableArray alloc] init];
        
        
        /**BLE**/
        dataReceivedList =  [[NSMutableArray alloc] init];

        url=@"ethylocle.livehost.fr";
    }
    return self;
}




/*        Gestion du fichier .plist          */

-(void) GetUsers
{
    NSDictionary *UserInfo;
    
    UserInfo=[self getConnectedUser:[self readPlist]];
    
    if(UserInfo == nil)
    {
        self.isLogged=NO;
    }
    else
    {
        self.login=[UserInfo objectForKey:@"login"];
        self.password=[UserInfo objectForKey:@"password"];
        self.isLogged=YES;
    }
}

-(NSDictionary*) getConnectedUser:(NSArray*)Users
{
    for(NSDictionary *User in Users)
    {
        if([User objectForKey:@"isLogged"])
        {
            return User;
        }
    }
    
    return NULL;
}

-(NSArray*) readPlist
{
    NSArray *Users=NULL;
    
    @try
    {
        Users = [NSArray arrayWithContentsOfFile:fichier];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Read Plist: %@",exception);
    }
    @finally
    {
        NSLog(@"Nom du fichier: %@", fichier);
        
        NSLog(@"%@", [Users description]);
        
        return Users;
    }
}

-(void) writePlist
{
    NSMutableArray *User=[[NSMutableArray alloc] init];
    
    if(![login isEqualToString:@""])
    {
        NSMutableDictionary *UserInfo=[[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[[NSString alloc] initWithString:login],[[NSString alloc] initWithString:password],[NSNumber numberWithBool:isLogged], nil] forKeys:[NSArray arrayWithObjects:@"login",@"password",@"isLogged", nil]];
        
        [User insertObject:UserInfo atIndex:0];
    }
    
    @try
    {
        [User writeToFile:fichier atomically:YES];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Write Plist : %@",exception);
    }
    @finally
    {
        NSLog(@"%@", [User description]);
    }
}



/*                 Web    service        */

-(void) update:(NSString *)stringdata
{
    connectionFinished=NO;
    
    receivedData=[NSMutableData dataWithCapacity: 0];
    
    theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/members/update", url]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"application/xml ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //setting of the HTTP body
    NSData *data=[stringdata dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:data];
    
    updateConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    NSLog(@"Connection established");
    
    if (!updateConnection)
    {
        receivedData=nil;
    }
}


-(void) checkLogin
{
    connectionFinished=NO;
    
    receivedData=[NSMutableData dataWithCapacity: 0];
    
    theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/members/availability", url]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"application/xml ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //setting of the HTTP body
    NSString *stringdata=[NSString stringWithFormat:@"&login=%@",login];
    NSData *data=[stringdata dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:data];
    
    checkLoginConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    NSLog(@"Connection established");
    
    if (!checkLoginConnection)
    {
        receivedData=nil;
    }
}

-(void) signUp
{
    connectionFinished=NO;
    
    receivedData=[NSMutableData dataWithCapacity: 0];
    
    theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/members/signup", url]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"application/xml ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //setting of the HTTP body
    NSString *stringdata=[NSString stringWithFormat:@"&login=%@&password=%@&age=%d&weight=%f&sex=%d&ville=%@",login,password,age,weight,sex,ville];
    NSData *data=[stringdata dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:data];
    
    signUpConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    NSLog(@"Connection established");
    
    if (!signUpConnection)
    {
        receivedData=nil;
    }
}


-(void) getTaxi
{
    connectionFinished=NO;
    
    receivedData=[NSMutableData dataWithCapacity: 0];
    
    theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/taxis/taxi", url]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"application/xml ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //setting of the HTTP body
    NSString *stringdata=[NSString stringWithFormat:@"&login=%@&password=%@",login,password];
    NSData *data=[stringdata dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:data];
    
    taxiConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    NSLog(@"Connection established");
    
    if (!taxiConnection)
    {
        receivedData=nil;
    }
}

-(void) getSam
{
    connectionFinished=NO;
    
    receivedData=[NSMutableData dataWithCapacity: 0];
    
    theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/members/sam", url]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"application/xml ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //setting of the HTTP body
    NSString *stringdata=[NSString stringWithFormat:@"&login=%@&password=%@",login,password];
    NSData *data=[stringdata dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:data];
    
    samConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    NSLog(@"Connection established");
    
    if (!samConnection)
    {
        receivedData=nil;
    }
}

-(void) getBus
{
    connectionFinished=NO;
    
    receivedData=[NSMutableData dataWithCapacity: 0];
    
    theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/ratps/bus", url]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"application/xml ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //setting of the HTTP body
    NSString *stringdata=[NSString stringWithFormat:@"&login=%@&password=%@",login,password];
    NSData *data=[stringdata dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:data];
    
    busConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    NSLog(@"Connection established");
    
    if (!busConnection)
    {
        receivedData=nil;
    }
}

-(void) getMetro
{
    connectionFinished=NO;
    
    receivedData=[NSMutableData dataWithCapacity: 0];
    
    theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/ratps/metro", url]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"application/xml ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //setting of the HTTP body
    NSString *stringdata=[NSString stringWithFormat:@"&login=%@&password=%@",login,password];
    NSData *data=[stringdata dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:data];
    
    metroConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    NSLog(@"Connection established");
    
    if (!metroConnection)
    {
        receivedData=nil;
    }
}

-(void) getUserData
{
    connectionFinished=NO;
    
    receivedData=[NSMutableData dataWithCapacity: 0];
    
    theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/members/list", url]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"application/xml ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //setting of the HTTP body
    NSString *stringdata=[NSString stringWithFormat:@"&login=%@&password=%@",login,password];
    NSData *data=[stringdata dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:data];
    
    userdataConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    NSLog(@"Connection established");
    
    if (!userdataConnection)
    {
        receivedData=nil;
    }
}

-(void) signIn
{
    connectionFinished=NO;
    
    receivedData=[NSMutableData dataWithCapacity: 0];
    
    theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/members/signin", url]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"application/xml ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString *stringdata=[NSString stringWithFormat:@"&login=%@&password=%@",login,password];
    NSData *data=[stringdata dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:data];
    
    signinConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    NSLog(@"Connection established");
    
    if (!signinConnection)
    {
        receivedData=nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"data received: %@ p ",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [receivedData appendData:data];
}

-(void) sendMessage
{
    connectionFinished=NO;
    
    receivedData=[NSMutableData dataWithCapacity: 0];
    
    theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/messages/receive", url]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"application/xml ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //setting of the HTTP body
    NSString *stringdata=[NSString stringWithFormat:@"&login=%@&password=%@&destinataire=%@&contenu=%@",login, password, destinataire, contenu];
    NSData *data=[stringdata dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:data];
    
    sendConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    NSLog(@"Connection established");
    
    if (!sendConnection)
    {
        receivedData=nil;
    }
}

-(void) receiveMessage
{
    connectionFinished=NO;
    
    receivedData=[NSMutableData dataWithCapacity: 0];
    
    theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/messages/send", url]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"application/xml ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //setting of the HTTP body
    NSString *stringdata=[NSString stringWithFormat:@"&login=%@&password=%@&destinataire=%@",login, password, destinataire];
    NSData *data=[stringdata dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:data];
    
    receiveConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    NSLog(@"Connection established");
    
    if (!receiveConnection)
    {
        receivedData=nil;
    }
}

-(void) conversationMessage
{
    connectionFinished=NO;
    
    receivedData=[NSMutableData dataWithCapacity: 0];
    
    theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/messages/list", url]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"application/xml ; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //setting of the HTTP body
    NSString *stringdata=[NSString stringWithFormat:@"&login=%@&password=%@",login, password];
    NSData *data=[stringdata dataUsingEncoding:NSUTF8StringEncoding];
    [theRequest setHTTPBody:data];
    
    conversationConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    NSLog(@"Connection established");
    
    if (!conversationConnection)
    {
        receivedData=nil;
    }
}



- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    signinConnection=nil;
    userdataConnection=nil;
    busConnection=nil;
    metroConnection=nil;
    samConnection=nil;
    taxiConnection=nil;
    signUpConnection=nil;
    checkLoginConnection=nil;
    updateConnection=nil;
    sendConnection=nil;
    receiveConnection=nil;
    conversationConnection=nil;
    receivedData=nil;
    
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *dataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"web server response : %@",dataString);
    
    //traitement des données
    if(connection==signinConnection)
    {
        NSLog(@"Connection 1 finished");
        
        if([dataString isEqualToString:@"1"])
        {
            isLogged=YES;
        }
        else
        {
            isLogged=NO;
        }
    }
    
    if(connection==userdataConnection)
    {
        NSLog(@"Connection 2 finished");
        
        NSArray *data=[dataString componentsSeparatedByString:@":;"];
        
        login=data[0];
        password=data[1];
        age=[data[2] intValue];
        weight=[data[3] doubleValue];
        sex=[data[4] intValue];
        ville=data[5];
        latitude=[data[6] doubleValue];
        longitude=[data[7] doubleValue];
        bac=[data[8] doubleValue];
    }
    
    if(connection==busConnection)
    {
        NSLog(@"Connection 3 finished");
        
        [BUS removeAllObjects];
        [BUS addObjectsFromArray:[dataString componentsSeparatedByString:@":;"]];
        
        for(int i=0; i<((unsigned long)BUS.count-1);i++)
        {
            if(i%4==0)
            {
                NSLog(@"Arrêt: %@ %@ lat:%@ lon:%@",BUS[i],BUS[i+1],BUS[i+2],BUS[i+3]);
            }
        }
    }
    
    if(connection==metroConnection)
    {
        NSLog(@"Connection 4 finished");
        
        NSLog(@"web server response : %@",dataString);
        
        [METRO removeAllObjects];
        [METRO addObjectsFromArray:[dataString componentsSeparatedByString:@":;"]];
        
        for(int i=0; i<((unsigned long)METRO.count-1);i++)
        {
            if(i%4==0)
            {
                NSLog(@"Arrêt: %@ %@ lat:%@ lon:%@",METRO[i],METRO[i+1],METRO[i+2],METRO[i+3]);
            }
        }
    }
    
    if(connection==samConnection)
    {
        NSLog(@"Connection 5 finished");
        
        [SAM removeAllObjects];
        [SAM addObjectsFromArray:[dataString componentsSeparatedByString:@":;"]];
        
        for(int i=0; i<((unsigned long)SAM.count-1);i++)
        {
            if(i%6==0)
            {
                NSLog(@"peuso:%@ age:%@ sex:%@ ville:%@ lat:%@ lon:%@",SAM[i],SAM[i+1],SAM[i+2],SAM[i+3],SAM[i+4],SAM[i+5]);
            }
        }
    }
    
    if(connection==taxiConnection)
    {
        NSLog(@"Connection 6 finished");
        
        [TAXI removeAllObjects];
        [TAXI addObjectsFromArray:[dataString componentsSeparatedByString:@":;"]];
        
        for(int i=0; i<((unsigned long)TAXI.count-1);i++)
        {
            if(i%4==0)
            {
                NSLog(@"Address: %@ lat:%@ lon:%@ numéro: %@",TAXI[i],TAXI[i+1],TAXI[i+2],TAXI[i+3]);
            }
        }
    }
    
    if(connection==checkLoginConnection)
    {
        NSLog(@"Connection 7 finished");
        
        if([dataString isEqualToString:@"1"])
        {
            loginAvailable=YES;
        }
        else
        {
            loginAvailable=NO;
        }
    }
    
    if(connection==signUpConnection)
    {
        NSLog(@"Connection 8 finished");
        
        if([dataString isEqualToString:@"1"])
        {
            signedUp=YES;
        }
        else
        {
            signedUp=NO;
        }
    }
    
    if(connection==updateConnection)
    {
        NSLog(@"Connection 9 finished");
        
        if([dataString isEqualToString:@"1"])
        {
            updated=YES;
        }
        else
        {
            updated=NO;
        }
    }
    
    if(connection==sendConnection)
    {
        NSLog(@"Connection 10 finished");
        
        if([dataString isEqualToString:@"1"])
        {
            messageSent=YES;
            NSLog(@"message sent");
        }
        else
        {
            messageSent=NO;
            NSLog(@"message not sent");
        }
    }
    
    if(connection==receiveConnection)
    {
        NSLog(@"Connection 11 finished");
        
        [MESSAGES removeAllObjects];
        NSArray* messages=[[NSArray alloc] initWithArray:[dataString componentsSeparatedByString:@":;"]];
        
        for(int i=0; i<((unsigned long)messages.count-1);i++)
        {
            if(i%4==0)
            {
                NSLog(@"Source: %@ Destinataire:%@ date:%@ contenu: %@",messages[i],messages[i+1],messages[i+2],messages[i+3]);
                [MESSAGES addObject:[[NSArray alloc] initWithObjects:messages[i],messages[i+1],messages[i+2],messages[i+3], nil]];
            }
        }
    }
    
    if(connection==conversationConnection)
    {
        NSLog(@"Connection 12 finished");
        
        [CONVERSATION removeAllObjects];
        [CONVERSATION addObjectsFromArray:[[NSArray alloc] initWithArray:[dataString componentsSeparatedByString:@":;"]]];;
        
        for(int i=0; i<((unsigned long)CONVERSATION.count-1);i++)
        {
            NSLog(@"Contact: %@", [CONVERSATION objectAtIndex:i]);
        }
    }

    
    connectionFinished=YES;
    
    signinConnection=nil;
    userdataConnection=nil;
    busConnection=nil;
    metroConnection=nil;
    samConnection=nil;
    taxiConnection=nil;
    signUpConnection=nil;
    checkLoginConnection=nil;
    updateConnection=nil;
    sendConnection=nil;
    receiveConnection=nil;
    conversationConnection=nil;
    receivedData=nil;
    
}






//BLE

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch(central.state)
    {
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"Bluetooth is currently powered off.");
            break;
        }
        case CBCentralManagerStateUnknown:
        {
            NSLog(@"State unknown, update imminent.");
            break;
        }
        case CBCentralManagerStateResetting:
        {
            NSLog(@"The connection with the system service was momentarily lost, update imminent.");
            break;
        }
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"The platform doesn't support Bluetooth Low Energy");
            break;
        }
        case CBCentralManagerStateUnauthorized:
        {
            NSLog(@"The app is not authorized to use Bluetooth Low Energy");
            break;
        }
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"Bluetooth is currently powered on.");
            [manager scanForPeripheralsWithServices:nil options:nil];
            break;
        }
        default:
            NSLog(@"Central Manager did change state");
            break;
    }
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)Peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@" Discover:");
    
    NSLog(@"name: %@",[Peripheral name]);
    NSLog(@"identifier: %@",[[Peripheral identifier] UUIDString]);
    
    if (peripheral != Peripheral)
    {
        peripheral = Peripheral;
        
        [manager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)Peripheral
{
    NSLog(@"Connected to %@",[Peripheral name]);
    
    if ([[Peripheral name] isEqualToString:@"Simple BLE Peripher"])
    {
        [manager stopScan];
        
        //Clears the data that we may already have
        [dataReceived setLength:0];
        
        //Sets the peripheral delegate
        [peripheral setDelegate:self];
        
        //Asks the peripheral to discover service
        [self.peripheral discoverServices:nil];
    }
    else
    {
        [manager cancelPeripheralConnection:peripheral];
        [self setPeripheral:nil];
        
        //[self centralManagerDidUpdateState:nil];
    }
}

- (void) peripheral:(CBPeripheral *)Peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error discovering service:%@",[error localizedDescription]);
        return;
    }
    
    for (CBService *Service in [Peripheral services])
    {
        NSLog(@"Service Discovered: %@", [Service UUID]);
        
        //Discovers the characteristics for a given service
        if ([[Service UUID] isEqual:[CBUUID UUIDWithString:ServiceUUID1]])
        {
            //NSLog(@"Service: %@", [Service UUID]);
            
            [self setService:Service];
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)Peripheral didDiscoverCharacteristicsForService:(CBService *)Service error:(NSError *)error
{
    if(error)
    {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    if ([[Service UUID] isEqual:[CBUUID UUIDWithString:ServiceUUID1]])
    {
        characteristic= [NSArray arrayWithArray:Service.characteristics];
        
        connected=YES;
        
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)Characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error reading characteristic value: %@",[error localizedDescription]);
    }
    else
    {
        [dataReceivedList addObject:[[NSMutableData alloc] initWithData:[Characteristic value]]];
        
        NSLog(@"Data received from %@: %@",Characteristic.UUID,[[NSString alloc] initWithData:[Characteristic value] encoding:NSUTF8StringEncoding]);
        
        response=YES;
    }
}

-(void) peripheral:(CBPeripheral *)Peripheral didWriteValueForCharacteristic:(CBCharacteristic *)Characteristic error:(NSError *) error
{
    if (error)
    {
        NSLog(@"Error writing characteristic value: %@",error.localizedDescription);
    }
    else
    {
        NSLog(@"Writing value for characteristic %@", Characteristic);
    }
}

- (void)peripheral:(CBPeripheral *)Peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)Characteristic error:(NSError *)error {
    if (error)
    {
        NSLog(@"Error changing notification state: %@",[error localizedDescription]);
    }
    
    //Exits if it's not the transfer characteristic
    if (![[Characteristic UUID] isEqual:[CBUUID UUIDWithString:CharacteristicUUID1]])
    {
        return;
    }
    
    //Notification has started
    if ([Characteristic isNotifying])
    {
        NSLog(@"Notification began on %@",Characteristic);
        [Peripheral readValueForCharacteristic:Characteristic];
    }
    else
    {
        [self computeData];
    }
}

+ (int) convertHexToInt:(unsigned char) byte1 byte:(unsigned char) byte2
{
    int ct=1;
    int value=0;
    
    
    for(int i=0; i< 8;i++)
    {
        if((byte2 >> i) & 0x01 )
        {
            value+=ct;
        }
        ct*=2;
    }
    
    for(int i=0; i< 8;i++)
    {
        if((byte1 >> i) & 0x01 )
        {
            value+=ct;
        }
        ct*=2;
    }
    
    return value;
    
}

+ (double) convertValueToBAC:(int)value
{
    double BAC;
    
    BAC=value*3400/65535;
    
    NSLog(@"mvolt= %f", BAC);
    
    BAC = BAC*0.2 - 3.9;
    
    //y=9E-10x(5) - 7E-07x(4) +0,0002x(3) - 0,0195x(2) + 1,5028x - 1,6617
    //BAC=4.78*pow(10,-13)*exp(-10)*pow(BAC, 5) - 7*exp(-7)*pow(BAC, 4) + 0.0002*pow(BAC, 3) - 0.0195*pow(BAC, 2) + 1.5028*BAC - 1.6617;
    
    //T=8.90852882562807e-10*z.^5-6.69091353957656e-07*z.^4+0.000182719831863348*z.^3-0.0195418323814134*z.^2+1.50275732673445*z.^1-1.66165210175391
    NSLog(@"%f %f",BAC, pow(BAC,2));
    
    BAC= 8.90852882562807*pow(10,-10)*pow(BAC, 5) - 6.69091353957656*pow(10,-7)*pow(BAC, 4) + 0.000182719831863348*pow(BAC, 3) - 0.0195418323814134*pow(BAC, 2) + 1.50275732673445*BAC - 1.66165210175391;
    
    //  BAC/1000 ?
    NSLog(@"BAC= %f", BAC/1000);
    
    return BAC/1000;
    
}

- (void) computeData
{
    //Traitement des données et calcul du taux d'alcoolémie
    unsigned char byte1;
    unsigned char byte2;
    
    float value=0;
    
    @try
    {
        for (NSData *datum in [self dataReceivedList])
        {
            [datum getBytes:&byte1 range:NSMakeRange(0, 1)];
            [datum getBytes:&byte2 range:NSMakeRange(1, 1)];
            
            NSLog(@"value= %d",[MyModel convertHexToInt:byte1 byte:byte2]);
            
            value = value + [MyModel convertHexToInt:byte1 byte:byte2];
        }
        
        value = value / [dataReceivedList count];
        
        NSLog(@"average value: %f", value);
        
        [self setBac:[MyModel convertValueToBAC:value]];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Erro occured in didUpdateNotificationState: %@", [exception description]);
    }
    @finally
    {
        
    }
}




@end



