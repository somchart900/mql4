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
  
 
     
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
input string starttime=0000;
void OnTick()
  {
int    vspread = (int)MarketInfo(Symbol(),MODE_SPREAD);
string noww=TimeHour(TimeLocal())+""+TimeMinute(TimeLocal());

Comment(starttime);
  }
//+------------------------------------------------------------------+
