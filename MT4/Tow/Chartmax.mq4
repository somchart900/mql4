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
   double top=WindowPriceMax();
 
     
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
void OnTick()
  {
double   TP=WindowPriceMax()-WindowPriceMin();
//double   bottom=WindowPriceMin(); 

TP=MathRound(TP/Point);
double center=TP/2;
center=WindowPriceMin()+center*Point;
   Comment(center);

   
  }
//+------------------------------------------------------------------+
