/** Copyright (c) 2018-2028 Tencent Technology All Right Reserved.
* @file       TencentGMEPlugin_api.h
* @brief      Game Engine Plugin
* @version    2019-01-07 gaopenggao create this file
*******************************************************************************/

// TencentGMEPlugin.h

#ifndef _TENCENTGMEPLUGIN_API_H_
#define _TENCENTGMEPLUGIN_API_H_

#if defined (__APPLE__) || defined(ANDROID) || defined(__linux__) || defined(AK_PS4) || defined(AK_XBOXONE)
#define GMEPlugin_API_CALL
#elif defined(_WIN32) || defined(_OS_PS4)
#define GMEPlugin_API_CALL __cdecl
#endif

/**
* @brief Set the local user ID. Each GME user must have a unique identifier.
*	This function must be called before posting events sending or receiving to GME servers.
* @param[in] openID The identifier of the local GME user.
*	The value is a 64-bit integer data and should be greater than 10000. It needs to be
*	converted into character type.
*/
extern "C"
void GMEPlugin_API_CALL GMEWWisePlugin_SetUserID(const char* openID);

/**
* @brief Set the GME chatting room ID.
*	This function must be called before posting events sending or receiving to GME servers.
*	Setting a new roomID will not affect already playing voices.
* @param[in] roomID Alphanumeric character string of up to 127 characters identifying a 
*	GME chatting room.
*/
extern "C"
void GMEPlugin_API_CALL GMEWWisePlugin_SetRoomID(const char* roomID);

/**
* @brief For receiving the voice chat, set the mapping between game object ID and GME
*	voice ID. The individual voice or the mixed voice can be received according to if 
*	the mapping relationship is set.
* @param[in] gameObjectID The gameObjectID allocated in the game.
* @param[in] voiceID The voice ID of the GME user.
*/
extern "C"
void GMEPlugin_API_CALL GMEWWisePlugin_ReceivePlugin_SetReceiveOpenIDWithGameObjectID(AkUInt64 gameObjectID, const char* voiceID);

/**
* @brief For receiving the voice chat, get the mapping between game object ID and GME
*	voice ID. 
* @param[in] gameObjectID The gameObjectID allocated in the game.
* @param[out] voiceID The voice ID of the GME user.
*/
extern "C" 
void GMEPlugin_API_CALL GMEWWisePlugin_ReceivePlugin_GetReceiveOpenIDWithGameObjectID(AkUInt64 gameObjectID, char* voiceID, int maxlen);

/**
* @brief Enable or disable audio loopback. Loopback controls if sound related to the
*	specified game object is routed back to Wwise to be played on the local device.
*	The audio is always sent to the server, but will only be played locally if loopback
*	is enabled.
* @param[in] gameObjectID The gameObjectID allocated in the game.
* @param[in] enableLoopback Loopback flag value.
*/
extern "C"
void GMEPlugin_API_CALL GMEWWisePlugin_SendPlugin_EnableLoopbackWithGameObjectID(AkUInt64 gameObjectID, bool enableLoopback);

/**
* @brief Get the loopback status. Retrieve whether loopback is enabled or disabled for
*	a given game object. Loopback controls if sound posted on the specified game
*	object is routed back to Wwise to be played on the local device.
*	The audio is always sent to the server, but will only be played locally if loopback
*	is enabled.
* @param[in] gameObjectID The gameObjectID allocated in the game.
* @return The loopback status.
*/
extern "C"
bool GMEPlugin_API_CALL GMEWWisePlugin_SendPlugin_GetEnableLoopbackWithGameObjectID(AkUInt64 gameObjectID);

/**
* @brief Get status and error message from GME.
*	\note This API is unstable: New message type and code may be added.
* @param[in] localUTCTime Unix time of the message
* @param[in] messageType Message type, e.g., 101 means room status
* @param[in] code Message code, e.g., when message type is 101, the possible
*	message code can be:
*		0 (room is exited successfully)
*		1 (entering room)
*		2 (room is entered successfully),
*		3 (exiting room)
* @param[in] message Message description in certain format
* @param[in] len The length of the message to be copied.
*/
extern "C"
int GMEPlugin_API_CALL GMEWWisePlugin_GetMessage(int* localUTCTime, int* messageType, int* code, char* message, int len);

#endif // _TENCENTGMEPLUGIN_API_H_
