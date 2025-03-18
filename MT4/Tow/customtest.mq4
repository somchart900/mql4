//+------------------------------------------------------------------+
//|                                                   customtest.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
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
void OnTick()
  {
double lower=iCustom(Symbol(),0,"Price Border",2,1);
double midle=iCustom(Symbol(),0,"Price Border",0,1);
double uper=iCustom(Symbol(),0,"Price Border",1,1);
       lower= NormalizeDouble(lower,Digits);
       midle= NormalizeDouble(midle,Digits);
       uper= NormalizeDouble(uper,Digits);
  Comment("UPER "+uper+"\nMidle "+midle+"\nlower "+lower); 
  }
//+------------------------------------------------------------------+
