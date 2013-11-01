//
//  FcConstant.h
//  FightClub
//
//  Created by Zhang, Qianze on 10/26/13.
//  Copyright (c) 2013 Zhang, Qianze. All rights reserved.
//

#ifndef FightClub_FcConstant_h
#define FightClub_FcConstant_h

#pragma login form constants..
#define LOGIN_FORM_CELL_HEIGHT 50
#define LOGIN_FORM_CELL_FIELD_PADDING 25
#define LOGIN_FORM_TABLE_HEIGHT 500
#define LOGIN_FORM_AVATAR_HEIGHT 80

#define SEC_ATTR_USER                       @"user"
#define SEC_ATTR_PASS                       @"pwd"
#define SEC_ATTR_TEMP_USER                  @"tuser"
#define SEC_ATTR_TEMP_PASS                  @"tpwd"
#define SEC_ATTR_UID                        @"uid"
#define SEC_ATTR_SESSION                    @"session"
#define SEC_DATA                            @"sData"

#define SERVICE_MACRO_LOGIN                 @"loginService"

#define LOGIN_RESPONSE_STATUS               @"valid"
#define LOGIN_RESPONSE_DATA                 @"data"
#define LOGIN_RESPONSE_DATA_UID             @"uid"

#define TASK_ATTR_TID                       @"tid"
#define TASK_ATTR_CONTENT                   @"content"
#define TASK_ATTR_TS                        @"tstamp"
#define TASK_ATTR_EXISTS                    @"tidExists"
#define TASK_ATTR_EXISTS_VAL_YES            @"yes"
#define TASK_ATTR_EXISTS_VAL_NO             @"no"

#define DB_FILE_NAME                        @"fightclub.sqlite"

#define PING_TIME_INTERVAL                  600
#define AUTO_DATA_SYNC_TIME_INTERVAL        5

#endif
