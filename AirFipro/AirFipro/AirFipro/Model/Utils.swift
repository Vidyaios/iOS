//
//  Utils.swift
//  AirFipro
//
//  Created by ixm1 on 11/8/17.
//  Copyright © 2017 iexemplar. All rights reserved.
//

import Foundation

//MARK: - Character Restriction
let ACCEPTABLE_CHARACTERSAlphaNumeric = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890"
let ACCEPTABLE_CHARACTERSNumbers = "0123456789"
let ACCEPTABLE_CHARACTERSDECIMAL = "0123456789."
let ACCEPTABLE_CHARACTERSAlphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
let ACCEPTABLE_CHARACTERSAddress = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890!@#$%^&*()-_=+,.<>?`~ "
let ACCEPTABLE_CHARACTERSName = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890-"

//MARK: - Character Limit
let MAX_LIMIT_EMAIL = 100
let MAX_LIMIT_NUMBER = 5
let MAX_LIMIT_NAME = 25
let MAX_LIMIT_THREEDIGIT = 3
let MAX_LIMIT_TWODIGIT = 2
let MAX_LIMIT_FNAME = 20
let MAX_LIMIT_PNUMBER = 10
let MAX_LIMIT_ADDRESS = 50

let API_INTERVAL = 20
let CODE200 = 200
let CODE201 = 201
let CODE202 = 202
let CODE204 = 204 // not need
let CODE304 = 304
let CODE400 = 400
let CODE401 = 401
let CODE403 = 403
let CODE404 = 404
let CODE405 = 405
let CODE406 = 406
let CODE409 = 409
let CODE412 = 412
let CODE415 = 415
let CODE440 = 440
let CODE422 = 422 // not need
let CODE500 = 500

//MARK: - Alert
let WARNING = "Warning"
let SUCCESS = "Success"
let WAIT = "Please Wait"

/* MQTT */
let MQTTCONNECITONERROR = "MQTT Connection Timeout"

/* SIGNIN */
let ALLFIELDVALIDATION = "Please enter all the fields"
let EMAILIDVALIDATION = "Please enter values in the Email Id field"
let EMAILIDVALIDATIONFRG = ""
let PASSWORDVALIDATION = "Please enter values in the password field"
let INVALIDEMAIL = "Please enter valid Email Id"
let INVALIDEMAILID = "Email Id is Invalid, please enter valid email id"
let NWCONNECTION = "Please Check Your Network Connection"
let INVALIDPWD = "Password should contain atleast 6 to 10 characters"
let INTERNALSERVER = "Internal Server Error"

/* ADD MACHINE */
let MACHINENAMEVALIDATION = "Please enter values in the Machine Number / Machine Name"
let MACHINETYPEVALIDATION = "Please select values in the Machine Type"
let MACHINESTATEVALIDATION = "Please select values in the Machine State"
let INAVLIDTIME = "Invalid Time"
let WARRANTYDATEVALIDATION = "From time should be less than TO time"
let MODELVALIDATION = "Model should contain atleast 5 to 15 characters"
let MACHINENUMBERVALIDATION = "Machine Number / Machine Name should contain atleast 3 to 20 characters"
let MAKEVALIDATION = "Make should contain atleast 1 to 25 characters"
let DESCRIPTIONVALIDATION = "Description should contain atleast 8 to 100 characters"

/* CONFIGURATION */
let SSIDVALIDATION = "Please enter values in the SSID field"
let CONFIGVALIDATION = "Please select the controller serial number from the device wifi section"
let NORECORDSFOUND = "No Records Found"

/* CONSTRUCTION */
let CONSTRUCTIONNAMEVALIDATION = "Please enter values in the Construction Name"
let WEFTVALIDATION = "Please enter values in the Weft"
let WARPVALIDATION = "Please enter values in the Warp"
let MINIMUMVALIDATION = "Please enter values in the Minimum"
let MAXIMUMVALIDATION = "Please enter values in the Maximum"
let PICKSVALIDATION = "Please enter values in the Picks"
let NOMACHINEAVAILABLE = "No Machine Available"
let CONSVALIDATION = "Construction Name should contain atleast 5 to 25 characters"
let WEFTMINVALIDATION = "Please enter valid Weft value"
let WARPMINVALIDATION = "Please enter valid Warp value"
let MINIMUMLIMITVALIDATION = "Please enter valid Minimum value"
let MAXIMUMLIMITVALIDATION = "Please enter valid Maximum value"
let PICKSLIMITVALIDATION = "Please enter valid Picks value"

/* NOTIFICATION */
let NOTIFICATIONVALIDATION = "From value should not be greater than To value"
let NOTIFICATIONTOVALIDATION = "Please enter the From value"

/* FEEDBACK */
let CONTACTPERSONEMPTYVALIDATION = "Please enter values in the Contact Person"
let CONTACTNUMBEREMPTYVALIDATION = "Please enter values in the Contact Number"
let EMAILADDRESSVALIDATION = "Please enter values in the Email Address"
let FEEDBACKVALIDATION = "Please enter values in the Feedback"
let CONTACTPERSONVALIDATION = "Contact Person should contain atleast 4 to 20 characters"
let FEEDBACKSUCCESS = "Thanks for your Feedback !!!"
let INVALIDEMAILVALIDATION = "Please enter valid Email Address"

/* Settings */
let OLDPSWDLIMITVALIDATION = "Old Password should contain atleast 6 to 10 characters"
let OLDPSWDMATCHVALIDATION = "Incorrect old password. Please Re-type the password"
let NEWPSWDLIMITVALIDATION = "New Password should contain atleast 6 to 10 characters"
let CONFIRMPSWDLIMITVALIDATION = "Confirm Password should contain atleast 6 to 10 characters"
let NEWPSWDMATCHVALIDATION = "The new password and confirm password does not match. Please Re-type the password"
let OLDPSWDNEWPSWDMATCHVALIDATION = "Old password and new password should not be same"
let CHANGEPASSWORDSUCCESS = "Your password has been changed successfully!"
let OLDPWDEMPTY = "Please enter values in the Old Password"
let NEWPWDEMPTY = "Please enter values in the New Password"
let CNFRMPWDEMPTY = "Please enter values in the Confirm Password"

/* Periodic Report */
let DATEFROMERROR = "Please select the FROM value"

/* Controller Retry */
let RETRYCONFIGVALIDATION = "Controller self registeration failed. Toggle OFF and ON the power switch in the controller and try again."
let CHANGENETWORKMESSAGE = "Please select your network in the wifi section of device"

/* Forgot Password */
let FORGOTPSWDSUCCESS = "Please check your email"


//MARK: - App URL
//let APPBASEURL = "http://192.168.2.64:8080/api/v1/"
let APPBASEURL = "http://ec2-52-15-33-240.us-east-2.compute.amazonaws.com:8080/api/v1/"
let SOCKETURL = "192.168.4.1"
let SOCKETHOST = 80

//MARK: - Method Name
let LOGIN_METHOD_NAME = "session"
let DEPARTMENT_METHOD_NAME = "department"
let SYSTEM_METHOD_NAME = "system"
let PREFERENCE_METHOD_NAME = "preference"
let NOTIFICATION_METHOD_NAME = "user/notificationSubscription"
let AGGREGATE_METHOD_NAME = "aggregateData"
let TYPECOLLECTION_METHOD_NAME = "typeCollection"
let ORGANIZATION_METHOD_NAME = "organization"
let CONTROLLER_METHOD_NAME = "controller"
let DAILYREPORT_METHOD_NAME = "controllerAggregateData/report"
let SETTINGS_METHOD_NAME = "user/setting"
let FORGOTPSWD_METHOD_NAME = "forgotPassword"
let FEEDBACK_METHOD_NAME = "feedback"
let NOTIFICATIONLIST_METHOD_NAME = "notification"

//MARK: - JSON Fields
let APPLAUNCHSTATUS = "APPLAUNCHSTATUS"
let DEVICETYPE = "IPHONE"
let EMAILID = "EMAILID"
let PASSWORD = "PASSWORD"
let DEVICE_TOKEN = "DEVICE_TOKEN"
let DEVICE_MAC_ADDRESS = "DEVICE_MAC_ADDRESS"
let KEYVALUE = "KEYVALUE"
let KEY = "key"
let VALUE = "values"
let POSTMETHOD = "POST"
let GETMETHOD = "GET"
let PUTMETHOD = "PUT"
let DELETEMETHOD = "DELETE"
let APPLICATIONJSON = "application/json"
let APPLICATIONXWWW = "application/x-www-form-urlencoded"
let CONTENTTYPE = "Content-Type"
let ACCEPT = "Accept"
let REFERREDBY = "Referred-By"
let OAUTH = "OAuth-Key"
let BASICAUTH = "Authorization"
let ERRORS = "errors"
let CODE = "cdoe"
let MESSAGE = "message"
let RESULTS = "results"
let ROAUTHKEY = "oauthKey"
let RID = "id"
let RUNIQUECODE = "uniqueCode"
let RORGANIZATIONID = "organizationId"
let RUSER = "user"
let DEPARTMENTID = "DEPARTMENTID"
let RNAME = "name"
let RCNAME = "controllername"
let RUSERID = "RUSERID"
let CHARACTERISTICS = "characteristics"
let PURCHASEDATE = "PURCHASE_DATE"
let WARRANTYENDDATE = "WARRANTY_END_DATE"
let NUMBER = "NUMBER"
let MAKE = "MAKE"
let MODEL = "MODEL"
let DESCRIPTION = "description"
let RTYPE = "TYPE"
let RPREFERENCES = "PREFERENCES"
let RMACHINETYPE = "SYSTEM"
let DATEFORMAT = "yyyy-MM-dd"
let INDIANDATEFORMAT = "dd-MM-yyyy"
let MACHINETYPEAUTO = "AUTOMATIC"
let MACHINETYPEMANUAL = "MANUAL"
let TEXTCOLOR = "textColor"
let MACHINEMORENORAML = "moreNormal"
let MACHINEMORESELECTED = "moreSelected"
let MACHINEACTIONVIEW = "VIEW"
let MACHINEACTIONEDIT = "EDIT"
let MACHINEACTIONADD = "ADD"
let MACHINETYPECOLLECTION = "MACHINE"
let CONTROLLERCONFIGSTATUS = "CONTROLLER_CONFIG_STATUS"
let CONTROLLERSERIALNUMBER = "CONTROLLER_SERIAL_NUMBER"
let CONTROLLERCONFIGID = "CONTROLLER_ID"
let MACHINEVIEWHEADER = "VIEW MACHINE"
let MACHINEEDITHEADER = "EDIT MACHINE"
let UPDATEMESSAGE = "UPDATE"
let CONFIRMATION = "CONFIRMATION"
let DELETECONFIRMATION = "DELETECONFIRM"
let DELETESUCCESS = "DELETESUCCESS"
let ADDMESSAGE = "ADDSUCCESS"
let APIFAILURE = "Machine delete failed"
let SYSTEMID = "systemId"
let CONSTRUCTION = "CONSTRUCTION"
let WEFT = "WEFT"
let WARP = "WARP"
let MINIMUM = "MINIMUM"
let MAXIMUM = "MAXIMUM"
let PICKS = "PICKS"
let CONTROLLERID = "CONTROLLERID"
let RKEYVALUES = "keyValues"
let NOTIFICATIONSTATE = "NOTIFICATION_STATE"
let PREFERENCEITEM = "preferenceItem"
let RANGEFROM = "RANGE_FROM"
let RANGETO = "RANGE_TO"
let ALERTTYPE = "ALERT_TYPE"
let COLORNAME = "COLOR_NAME"
let COLORCODE = "COLOR_CODE"
let STATE = "STATE"
let RDESCRIPTION = "DESCRIPTION"
let SENSORNOTIFICATION = "SENSOR_NOTIFICATION"
let TYPECATEGORY = "typeCategory"
let TYPEVALUE = "typeValue"
let SETTINGTYPEVALUE = "SETTING"
let ADDMACHINETYPE = "type"
let K_DEVICE_TOKEN = "DeviceToken"
let DEVICERESET = "DEVICERESET"
let COMMENTS = "COMMENTS"
let OLDPASSWORDKEY = "OLD_PASSWORD"
let NEWPASSWORDKEY = "NEW_PASSWORD"
let CHANGEPASSWORDKEY = "CHANGE_PASSWORD"
let FORGOTPSWDKEY = "FORGOT_PASSWORD"
let EMAILADDRKEY = "EMAIL_ADDRESS"
let FEEDBACKTYPEKEY = "FEEDBACK"
let FEEDBACKNAMEKEY = "USER_NAME"
let FEEDBACKADDRKEY = "ADDRESS"
let FEEDBACKORGNAMEKEY = "ORGANIZATION_NAME"
let FEEDBACKORGNOKEY = "CONTACT_NUMBER"
let FEEDBACKCONTENTKEY = "CONTENT"
let CONTACTPERSONKEY = "CONTACT_PERSON"
let CONTACTEMAILKEY = "CONTACT_EMAIL"
let INDUSTRYTYPEKEY = "INDUSTRY_TYPE"
let TIMEZONEID = "TIME_ZONE_ID"
let SYSTEMTYPE = "SYSTEMS_TYPE"
let RSTATE = "state"
let TIMEZONE = "TIMEZONE"
let DATETIME = "DATE_TIME"
let RCOMMENTS = "comments"
let PUSHCOLORCODE = "CC_MOBILE"

//MARK: - AUTH
let AUTHUSER = "ixmtexapiv0.1"
let AUTHPASSWORD = "ixmtexapi2017"
let TYPECOLLECTION = "TYPECOLLECTION"

//MARK: - View Controller
let INITIALVIEW = "ViewController"
let DEPARTMENTVIEW = "DepartmentViewController"
let DASHBOARDVIEW = "DashboardViewController"
let DRAWERVIEW = "DrawerViewController"
let SLIDERVIEW = "SliderLibViewController"
let SYSTEMLISTVIEW = "SystemListViewController"
let ADDMACHINEVIEW = "AddMachineViewController"
let CONTROLLERCONFIGVIEW = "ControllerConfigurationViewController"
let RETRYWIFIVIEW = "RetryWifiViewController"
let CONTROLLERDATAVIEW = "ControllerDataViewController"
let CONSTRUCTIONVIEW = "ConstructionViewController"
let NOTIFICATIONVIEW = "NotificationViewController"
let DAILYREPORTVIEW = "ReportsViewController"
let FEEDBACKVIEW = "FeedbackViewController"
let SETTINGSVIEW = "SettingsViewController"
let REPORTTYPEVIEW = "ReportTypeViewController"
let FORGOTPWDVIEW = "ForgotPwdViewController"
let PERIODICALVIEW = "PeriodicalViewController"
let STOPPAGEVIEW = "StoppageReportViewController"
let NOTILISTVIEW = "NotiListViewController"

//MARK: - Get Method Params
let QUERYMARK = "?"
let QUERYSYMBOL = "="
let GET_PARAM_ORGANIZATIONID = "organizationId"
let QUERYJOIN = "&"
let GET_PARAM_DEPARTMENTID = "departmentId"
let GET_PARAM_CONTROLLERID = "controllerId"
let DELETE_PARAMID = "id"
let GET_TYPE = "type"
let PREFERENCETYPE = "SENSOR_NOTIFICATION"
let GET_PARAM_SYSTEMID = "systemId"
let GET_PARAM_OFFSET = "offset"
let GET_PARAM_LIMIT = "limit"
let GET_PARAM_SHIFT = "SHIFT"
let GET_PARAM_START_TIME = "startTime"
let GET_PARAM_END_TIME = "endTime"
let GET_PARAM_STDATETIME = "startDateAndTime"
let GET_PARAM_ENDDATETIME = "endDateAndTime"
let GET_AGGREGATE = "SHIFT_AVG"
let GET_LIVE_AGGREGATE = "HOUR_AVG"
let GET_LIVE_AGGREGATE_MINUTE = "MINUTE_AVG"
let GET_CURRENT_TYPE = "shiftType"
let GET_PARAM_SHIFT_TYPE = "CURRENT"
let GET_PARAM_ST_DATE = "startDate"
let GET_PARAM_END_DATE = "endDate"
let GET_PARAM_SUBTYPE = "subType"

//MARK: - Common
let NAVIGATIONTYPESIGNIN = "Signin"
let NAVIGATIONTYPEDEPT = "Dashboard"
let NAVIGATIONTYPESYSTEM = "System"

//MARK: - MQTT
//let MQTT_HOST = "52.36.175.99"
let MQTT_HOST = "52.36.175.99"
let MQTT_PORT = 1883
let MQTT_CERT = "cert-key-vm"
let MQTT_PSWD = "123456"
let MQTT_CONTROLLER_PREFIX = "airfi/organization/"
let MQTT_CONTROLLER_SUFFIX = "/controllerlivestatus"
let MQTT_CONTROLLER_DELETE_PREFIX = "airfi/controller/command/"
let MQTT_CONTROLLER_DELETE_SUFFIX = "/status"


