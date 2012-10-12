/**
 * Copyright (C) 2002-2003, CodeHouse.com. All rights reserved.
 * CodeHouse(TM) is a registered trademark.
 *
 * THIS SOURCE CODE MAY BE USED FREELY PROVIDED THAT
 * IT IS NOT MODIFIED OR DISTRIBUTED, AND IT IS USED
 * ON A PUBLICLY ACCESSIBLE INTERNET WEB SITE.
 *
 * Script Name: Cool Countdown/Cool Count-up
 *
 * You can obtain this script at http://www.codehouse.com
 */

$UMSG_INVALID_HOURS='You have entered invalid input into the hours field.\n'+'Enter an amount of hours in the range of 0 - 99';
$UMSG_INVALID_MINUTES='You have entered invalid input into the minutes field.\n'+'Enter an amount of minutes in the range of 0 - 59';
$UMSG_INVALID_SECONDS='You have entered invalid input into the seconds field.\n'+'Enter an amount of minutes in the range of 0 - 59';
$UMSG_NO_INPUT='You have not entered a desired countdown time';
$UMSG_CLOSE_ACTIVE='You are attempting to exit this page while a timer is still active.\n'+'Doing so will cause the timer to terminate. When you press the "OK"\n'+'button, you will be given an opportunity to abort exiting this page';
if(navigator.userAgent.match(/(?!Opera)(MSIE)|(Gecko)/))
new function()
{
	var DOM_TARGET="target";
	var TARGET=window.attachEvent?"srcElement":DOM_TARGET;
	var MAX_TICKS=24*60*60*100+60*60*99+60*59+59;
	var ORIG_TITLE=document.title;
	var DLG_URL="stop_alarm.htm";
	var IE_DLG_STYLE="center:yes; dialogWidth:325px; dialogHeight:175px; status:no";
	var GK_DLG_STYLE="dependent,width=325,height=175";
	var COUNT_DOWN="CH_dtimer";
	var COUNT_UP="CH_utimer";
	var clockList=[];
	var isAnyClockWorking = false;
	/*if(window.attachEvent)attachEvent("onbeforeunload",function()
	{
		for(var i in clockList)
		{
			if(clockList[i].isActive())
			{
				alert($UMSG_CLOSE_ACTIVE);window.event.returnValue=false;break;
			}
		}
	}
	);*/
	function addListener(e,ev,listener)
	{
		if(window.attachEvent)
		{
			e.attachEvent("on"+ev,listener);
		}
		else
		{
			e.addEventListener(ev,listener,false);
		}
	}
	function initHandlers(clock)
	{
		function handler(event)
		{
			switch(event[TARGET])
			{
				case clock.ePause:
					if(document.getElementById('page:form:IdPauseClock').value=="true")
					{
						clock.stop();
						clock.eResume.disabled=false;
						clock.eResume.focus();
						clock.ePause.disabled=true;
					}
				break;
				case clock.eResume:
					if(document.getElementById('page:form:IdResumeClock').value=="true")
					{
						clock.start();
						clock.eResume.disabled=true;
						clock.ePause.disabled=false;
					}
				//break;
				//case clock.eStart:if(clock.eStart.disabled)
				return;
				default:
				function getNumberInput(e)
				{
					var s=e.value;
					if(!s.length)
					{
						return 0;
					}
					var i=parseInt(e.value);
					if(isNaN(i))
					{
						switch(e)
						{
							case clock.eHours:alert($UMSG_INVALID_HOURS);
							break;
							case clock.eMinutes:alert($UMSG_INVALID_MINUTES);
							break;
							case clock.eSeconds:alert($UMSG_INVALID_SECONDS);
						}
						e.value="";e.focus();
					}
					else if(s.length!=new String(i).length)
					{
						e.value=new String(i);
					}
					return i;
				}
				if(clock.type==COUNT_UP)
				{
					//clock.eStart.disabled=true;
					clock.ePause.disabled=false;
					clock.start();
					return;
				}
				var Dys=getNumberInput(clock.eDays);
				if(isNaN(Dys))
				{
					return;
				}
				var hrs=getNumberInput(clock.eHours);
				if(isNaN(hrs))
				{
					return;
				}
				var mins=getNumberInput(clock.eMinutes);
				if(isNaN(mins))
				{
					return;
				}
				var secs=getNumberInput(clock.eSeconds);
				if(isNaN(secs))
				{
					return;
				}
				clock.ePause.disabled=false;
				clock.disableTf(true);
				clock.start(hrs*3600+mins*60+secs,Dys);
				break;
			}
		}
		addListener(clock.ePause,"click",handler);
		addListener(clock.eResume,"click",handler);
	}
	function initClock(clockType,number)
	{
		function getElement(id)
		{
			return document.getElementById(clockType+number+"_"+id);
		}
		function getElement2(id)
		{
			return document.getElementById("page:form:"+clockType+number+"_"+id);
		}
		function getElement3(id)
		{
			return document.getElementById(clockType+"_"+id);
		}
		function getElement4()
		{
			return document.getElementById("page:form:SLAMin"+number).value;
		}
		function getElement5()
		{
			 //alert(document.getElementById("page:form:ActualResponse"+number).value);
			 return document.getElementById("page:form:ActualResponse"+number).value;
		}
		var ThresholdTime = document.getElementById("page:form:ThresholdTime").value;
		
		if(!getElement("digits"))return false;
		var clock=new Clock();
		clockList[clockList.length]=clock;
		function Clock()
		{
			this.type=clockType;
			this.eCont=document.getElementById(clockType+number);
			this.eDigits=getElement("digits");
			this.SLAMin=getElement4();
			this.ActualResponse = getElement5();
			//this.eStart=getElement3("start");
			this.ePause=getElement3("pause");
			this.eResume=getElement3("resume");
			if(clockType==COUNT_DOWN)
			{
				this.eDays=getElement2("days");
				this.eHours=getElement2("hours");
				this.eSeconds=getElement2("seconds");
				this.eMinutes=getElement2("minutes");
				this.eDays.maxLength=3;
				this.eHours.maxLength=this.eMinutes.maxLength=this.eSeconds.maxLength=2;
				function handler(event)
				{
					if(String.fromCharCode(event.keyCode)=="\r")
					{
						//clock.eStart.click();
						if(TARGET==DOM_TARGET)
						{
							return false;
						}
						else
						{
							event.returnValue=false;
						}
					}
				}
				addListener(this.eDays,"keydown",handler);
				addListener(this.eHours,"keydown",handler);
				addListener(this.eMinutes,"keydown",handler);
				addListener(this.eSeconds,"keydown",handler);
			}
			this.cTicks=0;
			//this.eDigits.innerHTML="00:00:00:00";
			Clock.ticker=function()
			{
				if(clock.type==COUNT_UP)
				{
					++clock.cTicks;clock.showTime();
				}
				else
				{
					clock.showTime();
					if(clock.ActualResponse != '')
					{
						clock.stop();
					}
					else
					{
						if(clock.cTicks==0)
						{
							if(clock.days>0)
							{
								--clock.days;
								clock.cTicks=86400;
							}
							else
							{
								
								clock.eDigits.innerHTML="00:00:00:00";
							}
						}
						if(clock.cTicks)
						{
							--clock.cTicks;
						}
						else
						{
							clock.eDigits.innerHTML="00:00:00:00";
							clock.stop();
							//clock.ePause.disabled=true;
							//clock.eResume.disabled=true;
							window.focus();
							
							if(window.showModalDialog&&window.attachEvent)
							{
								//showModalDialog(DLG_URL,clockList,IE_DLG_STYLE);
							}
							else
							{
								//window.open(DLG_URL,"",GK_DLG_STYLE).focus();
							}
						}
					}
				}
				
			};
			this.showTime=function()
			{
				if(this.cTicks<=MAX_TICKS)
				{
					var xx = '00';
					if (this.days != null && this.days != 0) 
						xx = Math.floor(this.days/10) + ""+Math.floor(this.days%10);
					if(xx*1 == 0 && this.cTicks == 0)
						this.eDigits.style.color = "Red";
					else 
					{
						var mineticks = this.SLAMin * 60;
						var presenteticks = (xx*24*60*60)+(this.cTicks*1);
						if(	presenteticks < mineticks*ThresholdTime/100)
							this.eDigits.style.color = "Yellow";
					}
					this.eDigits.innerHTML= xx +":"+Math.floor(this.cTicks/3600/10)+""+Math.floor(this.cTicks/3600%10)+":"+Math.floor(this.cTicks%3600/60/10)+""+Math.floor(this.cTicks%3600/60%10)+":"+Math.floor(this.cTicks%3600%60/10)+""+this.cTicks%3600%60%10;
					
				}
				
				
			};
			this.disableTf=function(flag)
			{
				this.eDays.disabled=this.eHours.disabled=this.eMinutes.disabled=this.eSeconds.disabled=flag;
			};
			this.start=function(newCountDownFrom,day)
			{
				if(newCountDownFrom)
				{
					this.cTicks=newCountDownFrom;
					this.days=day;
					this.showTime();
					--this.cTicks;
					if(this.ePause)
						this.ePause.disabled=false;
				}
				this.intervalID=setInterval(Clock.ticker,1000);
			};
			this.stop=function()
			{
				clearInterval(this.intervalID);
				this.intervalID=null;
			};
			this.isActive=function()
			{
				return this.intervalID!=null;
			};
			if(this.type==COUNT_DOWN)
			{
				this.disableTf(false);
			}
			//this.eStart.disabled=false;
			if(this.ePause)
				this.ePause.disabled=true;
			this.eResume.disabled=true;
			initHandlers(this);

		}
		return true;
	}
	for(var d=1;initClock(COUNT_DOWN,d);++d);
	for(var i=0;i<clockList.length;++i)
	{
		//clockList[i].eCont.style.visibility="visible";
		var j = i + 1;
		var days = document.getElementById("page:form:CH_dtimer"+j+"_days").value;
		var hrs = document.getElementById("page:form:CH_dtimer"+j+"_hours").value;
		var mins = document.getElementById("page:form:CH_dtimer"+j+"_minutes").value;
		var secs = document.getElementById("page:form:CH_dtimer"+j+"_seconds").value;
		var eticks = hrs*3600+mins*60+secs*1;
		clockList[i].start(eticks,days);
		var SLAClockPausedSetting = document.getElementById("page:form:SLAClockPausedSetting").value;
		var SLAClockPaused = document.getElementById("page:form:SLAClockPaused").value;
		if(SLAClockPaused.toUpperCase()=="TRUE") 
		{
			clockList[i].stop();
			clockList[i].eResume.disabled=false;
			clockList[i].ePause.disabled=true;
		}
		if( SLAClockPausedSetting.toUpperCase()=="FALSE")
		{
			//clockList[i].stop();
			clockList[i].eResume.disabled=true;
			clockList[i].ePause.disabled=true;
		}
		
	}
	
}