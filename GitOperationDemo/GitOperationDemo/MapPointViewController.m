//
//  LoginViewController.m
//  MobileCenter
//
//  Created by liuwang on 2018/6/25.
//  Copyright © 2018年 CSII. All rights reserved.
//

#import "MapPointViewController.h"
#import "RegisterProtocolViewController.h"

#import "CustomAnnotationView.h"

#import "POIAnnotation.h"
#import "MapPoiDetailViewController.h"
#import "MapATMDetailViewController.h"
#import "OrderRecordViewController.h"
#import "MapListViewController.h"
#import "CommonUtility.h"
#import "MapCustomPoint.h"
#import "LocationManager.h"
#import "MapAnnotationView.h"
#import "MTSegmentView.h"

#define kCalloutViewMargin          -8

@interface MapPointViewController ()<AMapSearchDelegate,MAMapViewDelegate,UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate,CUSegmentedControlDelegate>{
    CUSegment *segment;
    CULabel *_label;
    CULabel *_label2;
    NSString *_birthPlace;
    NSString *_livePlace;
    NSString *_taxCountry;
    NSString *_taxNum;
    NSString *_reason;
    NSString *_note;
    CLLocationCoordinate2D getCoord;
}
@property (nonatomic,strong) NSMutableArray *netWorkDataArray;
@property (nonatomic,strong) CUTableView *tableview;
@property (nonatomic ,strong) NSArray *arr;
@property (nonatomic ,strong) NSArray *arrRight;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic, assign) CGFloat logoCenterX;
@property (nonatomic, strong) UIButton *gpsButton;
@property (nonatomic, strong) AMapSearchAPI *search;
/** 机构号 */
@property (nonatomic,copy) NSString *brchNo;

@property (nonatomic,assign) BOOL isRequestNet;

@property (nonatomic,assign) BOOL isAtm;

//ASSASSIN MODIFICATION
@property(nonatomic,strong)MTSegmentView *mtSegment;

@end

@implementation MapPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self descripSelf];
    [self tableview];
}

-(void)setMapPointType:(MapPointType)type {
    self.type = type;
    
    self.title = self.type == NetPointType ? @"网点查询" : @"ATM";
    //ASSASSIN MODIFICATION
    self.mtSegment.selectedIndex = self.type == NetPointType ? 0 : 1;
}

-(void)descripSelf{
    self.title = @"网点服务";
    _netWorkDataArray = [NSMutableArray new];
    getCoord = (CLLocationCoordinate2D){[[LocationManager shareManager].latitude doubleValue],[[LocationManager shareManager].longitude doubleValue]};
    
    //_isAtm = self.type == NetPointType ? NO : YES;
    
    if ([[Context.jumpObject objectForKey:@"pageiOS"] isEqualToString:NSStringFromClass([self class])]) {
        NSDictionary * dict = [Context.jumpObject objectForKey:@"menuParam"];
        if ([[dict objectForKey:@"type"] isEqualToString:@"loan"]) {
            _brchNo = dict[@"brchNo"];
        }
    }
    NSDictionary *newDict = Context.jumpObject;
    if ([[Context.jumpObject objectForKey:@"pageiOS"] isEqualToString:NSStringFromClass([self class])]) {
        if ([newDict objectForKey:@"clientParam"]) {
            NSString *clientParamStr = newDict[@"clientParam"];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[clientParamStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            if (dict == nil) {
                dict = [NSDictionary dictionaryWithDictionary:[Context convertClientParam:clientParamStr]];
            }
            if ([[dict objectForKey:@"type"] isEqualToString:@"ATM"] || [[[dict objectForKey:@"menuParam"] objectForKey:@"type"] isEqualToString:@"ATM"]) {
                _isAtm = YES;
            }
        }
        if ([[newDict objectForKey:@"type"] isEqualToString:@"ATM"] || [[[newDict objectForKey:@"menuParam"] objectForKey:@"type"] isEqualToString:@"ATM"]) {
            _isAtm = YES;
        }
    }
    
    
    _isAtm = self.type == NetPointType ? NO : YES;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
    self.search.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.mapView.delegate = nil;
    self.search.delegate = nil;
}

- (CUTableView *)tableview
{
    if (!_tableview)
    {
        _tableview = [[CUTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.scrollEnabled = NO;
        _tableview.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1];
        _tableview.delegate = (id<UITableViewDelegate>)self;
        _tableview.dataSource = (id<UITableViewDataSource>)self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched ;
        
        [self.view addSubview:_tableview];
        [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(BOUNDS.size.height-KNavBarHeight-kTabBarBottomHeight);
            make.left.mas_equalTo(0);
            make.top.mas_offset(0);
        }];
        
    }
    return _tableview;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 &&indexPath.row == 0) {
        MapListViewController *view = [[MapListViewController alloc] init];
        view.stpe = (int)segment.selectedSegmentIndex;
        [RootNavController pushViewController:view animated:YES];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return GET_REAL_HEIGHT(kOneLineHeight);
            break;
        default:
            return 0.01;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), [self tableView:tableView heightForHeaderInSection:section])];

    //ASSASSIN MODIFICATION
    
    if (section == 0) {
        self.mtSegment = [MTSegmentView initWithBlock:^(NSInteger index) {
            self->_isAtm = !self->_isAtm;
            [self->_tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
            [self requestNetWorkData];
            
        }];
        self.mtSegment.selectedIndex = self.type == NetPointType ? 0 : 1;
        [headerView addSubview:self.mtSegment];
        self.mtSegment.frame = headerView.bounds;
    }
    
    return headerView;
}

- (void)didSegmentValueChanged:(CUSegment*)segmentControl {
    if (segmentControl.selectedSegmentIndex == _isAtm?1:0) {
        return;
    }
    _isAtm = !_isAtm;
    [_tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
    [self requestNetWorkData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return GET_REAL_HEIGHT(kMiniSapceHeight);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), [self tableView:tableView heightForFooterInSection:section])];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 &&indexPath.row == 0) {
        return CGRectGetHeight(tableView.frame) - 3*GET_REAL_HEIGHT(kOneLineHeight) -GET_REAL_HEIGHT(5)- GET_REAL_HEIGHT(kMenCellHeight) - 2*GET_REAL_HEIGHT(kMiniSapceHeight);
    }else if (indexPath.section == 1 &&indexPath.row == 0) {
        return GET_REAL_HEIGHT(kOneLineHeight);
    }else if (indexPath.section == 2 &&indexPath.row == 0) {
        return GET_REAL_HEIGHT(kOneLineHeight);
    }else if (indexPath.section == 2 &&indexPath.row == 1) {
        return GET_REAL_HEIGHT(kMenCellHeight)+GET_REAL_HEIGHT(5);
    }
    return GET_REAL_HEIGHT(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &&indexPath.row == 0) {
        NSString *cellID = [NSString stringWithFormat:@"%ld %ld",(long)indexPath.section,(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            self.mapView = [[MAMapView alloc] initWithFrame:cell.bounds];
            self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.mapView.delegate = self;
            self.mapView.zoomLevel = 14;
            self.mapView.centerCoordinate = getCoord;
            //MARK:mapView
            [cell addSubview:self.mapView];
            [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(BOUNDS.size.width);
                make.height.mas_equalTo(cell.mas_height);
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(GET_REAL_HEIGHT(0));
            }];
            
            self.mapView.showsUserLocation = YES;
            
            self.mapView.userTrackingMode = MAUserTrackingModeFollow;
            self.mapView.userLocation.title = @"您的位置在这里";
            
//            MAUserLocationRepresentation *represent = [[MAUserLocationRepresentation alloc] init];
//            represent.showsAccuracyRing = NO;
//            represent.showsHeadingIndicator = YES;
////            represent.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
////            represent.strokeColor = [UIColor lightGrayColor];;
////            represent.lineWidth = 2.f;
//            represent.image = [UIImage imageNamed:@"userPosition"];
//            [self.mapView updateUserLocationRepresentation:represent];
            
    
        
            UIView *zoomPannelView = [self makeZoomPannelView];
            zoomPannelView.center = CGPointMake(self.view.bounds.size.width -  CGRectGetMidX(zoomPannelView.bounds) - 10,self.view.bounds.size.height -  CGRectGetMidY(zoomPannelView.bounds) - 10);
            zoomPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
            [self.mapView addSubview:zoomPannelView];
            
            self.gpsButton = [self makeGPSButtonView];
            self.gpsButton.center = CGPointMake(CGRectGetMidX(self.gpsButton.bounds) + 10,
                                                self.mapView.bounds.size.height -  CGRectGetMidY(self.gpsButton.bounds) - 20);
            [self.mapView addSubview:self.gpsButton];
            self.gpsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
            
            
            self.mapView.showsScale = YES;
            self.mapView.showsCompass = YES;
            
            self.search = [[AMapSearchAPI alloc] init];
            self.search.delegate = self;
            
            
            self.logoCenterX = self.mapView.logoCenter.x;

            [self gpsAction];
           
        }
        
        
        return cell;
        
    }else if (indexPath.section == 1 && indexPath.row == 0){
        NSString *cellID = [NSString stringWithFormat:@"%ld %ld",(long)indexPath.section,(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            CSIIUILabel *groupTitleLabel = UILable_16_DeepColor_Left;
            if (_isAtm) {
                groupTitleLabel.text = @"查看其他ATM";
            }else{
                groupTitleLabel.text = @"查看其他网点";
            }
            
            [cell addSubview:groupTitleLabel];
            
            [groupTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(cell.mas_height);
                make.left.mas_equalTo(GET_REAL_WIDTH(kDemoGlobalMargin));
                make.top.mas_equalTo(GET_REAL_HEIGHT(0));
            }];
            
        }
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 0){
        NSString *cellID = [NSString stringWithFormat:@"%ld %ld",(long)indexPath.section,(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            CSIIUILabel *groupTitleLabel = UILable_16_DeepColor_Left;
            groupTitleLabel.text = @"这些业务手机上也可轻松操作";
            [cell addSubview:groupTitleLabel];
            
            [groupTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(cell.mas_height);
                make.left.mas_equalTo(GET_REAL_WIDTH(kDemoGlobalMargin));
                make.top.mas_equalTo(GET_REAL_HEIGHT(0));
            }];
            
        }
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        NSString *cellID = [NSString stringWithFormat:@"%ld %ld",(long)indexPath.section,(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            UIView * menuCellView = [[UIView alloc] initWithFrame:CGRectMake(0, GET_REAL_HEIGHT(5), kScreenW, GET_REAL_HEIGHT(kMenCellHeight))];
            [cell addSubview:menuCellView];
//            [menuCellView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(BOUNDS.size.width);
//                make.height.mas_equalTo(cell.mas_height-GET_REAL_HEIGHT(5));
//                make.top.mas_equalTo(GET_REAL_HEIGHT(5));
//                make.left.mas_equalTo(0);
//            }];
            [Context settingCellMenuView:menuCellView Target:self action:@selector(onButtonClicked:) index:4];
        }
        return cell;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellStyleDefault"];
}

-(void)onButtonClicked:(UIButton*)sender
{
    [Context jumpPageWithButton:sender currentViewController:self param:@{}];
}
#pragma mark - 地图加载完成
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    
    
    if (updatingLocation) {
        NSString *latitude = [NSString stringWithFormat:@"%f",userLocation.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
        getCoord = userLocation.coordinate;
        [LocationManager shareManager].latitude = latitude;
        [LocationManager shareManager].longitude = longitude;
        [[LocationManager shareManager] refreshLocalData];
        if (!_isRequestNet) {
            [self requestNetWorkData];
            _isRequestNet = YES;
        }
        
//        dispatch_async(dispatch_get_main_queue(), ^{//GCJ-02
//            [self requestNetWorkData];
//        });
    }
    
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
        }];
    }
}
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    NSLog(@"map error = %@",error.description);
    
    [self setDefalutView];
}

- (void)addAction
{
    OrderRecordViewController *view = [[OrderRecordViewController alloc] init];
    view.frompoi = getCoord;
    [RootNavController pushViewController:view animated:YES];
}



- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

//MARK:Map 点击进入详情
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id<MAAnnotation> annotation = view.annotation;
    
    if ([annotation isKindOfClass:[MapCustomPoint class]])
    {
        MapCustomPoint *poiAnnotation = (MapCustomPoint*)annotation;
        NSDictionary *dict = poiAnnotation.dict;
        NSLog(@"==%@",dict[@"brchNme"]);
        if ([dict[@"nodeType"] isEqualToString:@"0"]) {//网点
            MapPoiDetailViewController *detail = [[MapPoiDetailViewController alloc] init];
            detail.dict = dict;
            detail.frompoi = getCoord;
            [self.navigationController pushViewController:detail animated:YES];
        }else{//atm
            MapATMDetailViewController *detail = [[MapATMDetailViewController alloc] init];
            detail.dict = dict;
            detail.frompoi = getCoord;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }
}
//MARK:Map 定制标记点样式
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"userPosition"];
        
        self.userLocationAnnotationView = annotationView;
        
        return annotationView;
    }
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
            poiAnnotationView.image = [CUImage imageNamed:@"map_mark_select"];
        }
        poiAnnotationView.userInteractionEnabled = YES;
        poiAnnotationView.canShowCallout = YES;
        
        MapAnnotationView * alterView = [[MapAnnotationView alloc] initWithFrame:CGRectMake(0, 0, GET_REAL_WIDTH(345), GET_REAL_HEIGHT(100))];
        poiAnnotationView.customCalloutView = alterView;
        if (_netWorkDataArray.count > 0) {
            MapCustomPoint *point = (MapCustomPoint*)annotation;
            alterView.dataDict = point.dict;
            alterView.userInteractionEnabled = YES;
            UIControl *control = [[UIControl alloc] initWithFrame:alterView.bounds];
            [control addTarget:self action:@selector(clickAlterView) forControlEvents:UIControlEventTouchUpInside];
            [alterView addSubview:control];
        }
        return poiAnnotationView;
    }

    return nil;
}

-(void)clickAlterView{
    NSDictionary *dict =[_netWorkDataArray firstObject];
    if ([dict[@"nodeType"] isEqualToString:@"0"]) {//网点
        MapPoiDetailViewController *detail = [[MapPoiDetailViewController alloc] init];
        detail.dict = dict;
        detail.frompoi = getCoord;
        [self.navigationController pushViewController:detail animated:YES];
    }else{//atm
        MapATMDetailViewController *detail = [[MapATMDetailViewController alloc] init];
        detail.dict = dict;
        detail.frompoi = getCoord;
        [self.navigationController pushViewController:detail animated:YES];
    }
}



- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        CustomAnnotationView *cusView = (CustomAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
        
        if (!CGRectContainsRect(self.mapView.frame, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
            
            CGPoint theCenter = self.mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
            
            [self.mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }
}

//MARK:Map 地图控件交互
- (UIView *)makeZoomPannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 98)];
    
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}

- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
    self.mapView.showsScale = YES;
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
    self.mapView.showsScale = NO;
}

- (void)changeLogoPosition {
    CGPoint oldCenter = self.mapView.logoCenter;
    self.mapView.logoCenter = CGPointMake(oldCenter.x > self.view.bounds.size.width / 2 ? self.logoCenterX : self.mapView.bounds.size.width - self.logoCenterX, oldCenter.y);
}

- (UIButton *)makeGPSButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}

- (void)gpsAction {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:getCoord animated:YES];
        [self.gpsButton setSelected:YES];
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
}
/** 默认数据 */
-(void)setDefalutView{
    [self requestNetWorkData];
}
#pragma mark - 请求数据
-(void)requestNetWorkData{
    NSDictionary *dict = @{@"qryTyp":@"1",@"currLongitude":[NSString stringWithFormat:@"%.5f",getCoord.longitude],@"currLatitude":[NSString stringWithFormat:@"%.5f",getCoord.latitude],@"headPageNum":@"1",@"headPageSize":@"1"};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
    [params setObject:@"0" forKey:@"nodeTypeFlag"];
    if (segment.selectedSegmentIndex == 1) {
        [params setObject:@"1" forKey:@"nodeTypeFlag"];
    }
    if (_brchNo.length > 0) {
        [params setObject:@"3" forKey:@"qryTyp"];
        [params setObject:_brchNo forKey:@"brchNo"];
    }
    [_netWorkDataArray removeAllObjects];
    [[CSIIBusinessRPCLogic sharedInstance] executeRpc:@"hall.nodeListQry.do" params:params responseHeaderFields:^(NSDictionary *allHeaderFields) {
        
        
        if ([[allHeaderFields objectForKey:@"_RejCode"] isEqualToString:@"000000"]) {
            
            
            NSArray *arr = [allHeaderFields objectForKey:@"list"];
            [self->_netWorkDataArray addObjectsFromArray:arr];
            
            
            [self dataShowMapView];
            
            
        }else{
            
            
            [self dataShowMapView];
            
            
        }
    }];
}

-(void)dataShowMapView{
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self->_mapView setZoomLevel:12];
        [self->_mapView removeAnnotations:self->_mapView.annotations];
        if (self->_netWorkDataArray.count == 0) {
            [self->_mapView setCenterCoordinate:self->getCoord];
            return;
        }
        
        NSDictionary *dict = [self->_netWorkDataArray firstObject];
        CLLocationCoordinate2D coord = (CLLocationCoordinate2D){[dict[@"latitude"] doubleValue],[dict[@"longitude"] doubleValue]};
        MapCustomPoint *annotation = [[MapCustomPoint alloc] init];
        
        
        annotation.coordinate = coord;
        annotation.dict = dict;
        annotation.title = dict[@"brchNme"];
        annotation.subtitle = dict[@"brchAddr"];
        
        
        
        [self.mapView addAnnotation:annotation];
        [self.mapView showAnnotations:@[annotation] animated:YES];
        [self.mapView selectAnnotation:annotation animated:YES];
        
        //ASSASSIN MODIFICATION 添加支行为默认定位点
        [self.mapView setCenterCoordinate:coord];
        
    });
    
    
}
@end


