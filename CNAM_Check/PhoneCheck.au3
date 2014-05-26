#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>


#include <String.au3>
#include "winhttp_com.au3"

TCPStartup()
_WinHTTP_Startup()


$phone=Int(InputBox("PhoneCheck","Enter a North American phone number without spaces or symbols.",3033090004));2812221863
$span=Int(IniRead("PhoneCheck.ini","config","span",InputBox("PhoneCcheck","Input the span of numbers to scan higher and lower.",0)))
$auth=Int(IniRead("PhoneCheck.ini","config","auth","0"))

$sid=IniRead("PhoneCheck.ini","config","sid","")
$token=IniRead("PhoneCheck.ini","config","token","")

$key='?account_sid='&$sid&'&auth_token='&$token




ConsoleWriteX("CID Scan: "&($phone-$span)&' - '&($phone+$span)&" AUTH="&$auth&@CRLF)
For $i=-$span To $span Step 1
	Local $pn=$phone+$i
	Local $url='https://api.opencnam.com/v2/phone/'&$pn
	If $auth Then $url&=$key
	ConsoleWrite($url&@CRLF)


	Local $sData=_WinHTTP_Request('GET',$url)
	If StringInStr($sData,"no caller ID name information available") Then
		ConsoleWriteX($pn&@CRLF)
	Else
		If StringInStr($sData,"Throttle limit exceeded") Then
			ConsoleWriteX('Throttle limit exceeded - Waiting a bit before continuing...'&@CRLF)
			$i-=1
			Sleep(5*60*1000);5min
		Else
			ConsoleWriteX($pn&' = '&$sData&@CRLF)
		EndIf
	EndIf
	Sleep(100)
Next
_WinHTTP_Shutdown()

;--------------------------------------------------

Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("PhoneCheck results", 542, 383, 192, 132)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Edit1 = GUICtrlCreateEdit("", 2, -2, 538, 348)
GUICtrlSetFont(-1, 12, 400, 0, "Lucida Console")
$butOK = GUICtrlCreateButton("OK", 434, 349, 104, 31, $WS_GROUP)
GUICtrlSetOnEvent(-1, "butOKClick")
$butCopy = GUICtrlCreateButton("Copy", 5, 348, 424, 31, $WS_GROUP)
GUICtrlSetOnEvent(-1, "butCopyClick")
SetFormText()
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Sleep(100)
WEnd

Func butCopyClick()
	ClipPut(GUICtrlRead($Edit1))
EndFunc
Func butOKClick()
	Exit
EndFunc
Func Form1Close()
	Exit
EndFunc

Func ConsoleWriteX($s)
	Global $StdOut_Temp; specify scope, create if nonexistent
	$StdOut_Temp&=$s
	ConsoleWrite($s)
EndFunc
Func SetFormText()
	Global $StdOut_Temp; specify scope, create if nonexistent
	GUICtrlSetData($Edit1,$StdOut_Temp)
EndFunc


;https://api.opencnam.com/v2/phone/+17097000122?format=pbx&account_sid=X&auth_token=Y

