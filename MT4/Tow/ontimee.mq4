//+------------------------------------------------------------------+
//|                                                     Chartmax.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
 EventSetMillisecondTimer(1000);
 //Comment(TimeHour(TimeLocal()));
  //Comment(TimeHour(TimeLocal())+"."+TimeMinute(TimeLocal()));   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
//void OnTick()
void OnTimer()
  {
 string Sym1=StringSubstr(Symbol(),0,6)+".txt";
//int    vspread = (int)MarketInfo(Symbol(),MODE_SPREAD);
//Comment(vspread);
//Comment(TimeHour(TimeLocal())+"."+TimeMinute(TimeLocal()));  
//double h=iHigh(Symbol(),PERIOD_H1,1);
//double l=iLow(Symbol(),PERIOD_H1,1);
if(FileIsExist(Sym1))
  {
 Comment("OK");
 //FileDelete(Sym1);
  }else
  {
  Comment("not");
 // int filehandle = FileOpen( Sym1,FILE_WRITE|FILE_TXT);
 // FileWriteString(filehandle,"teste");  
 // FileClose(filehandle); 
   }
   // int filehandle = FileOpen( Sym1,FILE_WRITE|FILE_TXT);
 // FileWriteString(filehandle,"teste");  
  //FileClose(filehandle);
 }
//+------------------------------------------------------------------+
