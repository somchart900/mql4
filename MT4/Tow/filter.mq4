//+------------------------------------------------------------------+
//|                                                       filter.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
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
//---
   
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool filter()
  {
   bool a=true;
// int count=0;
   double lastprofit=0;
   if(TimeLocal()>StringToTime(starttime) && TimeLocal()<StringToTime(endtime))
     {
      int today=TimeDayOfYear(TimeCurrent());
      for(int i = 0; i < OrdersHistoryTotal(); i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
           {
            if(OrderSymbol()==Symbol())
              {
               if(TimeDayOfYear(OrderOpenTime())==today)
                 {
                  if(OrderMagicNumber()==MagicNumber)
                    {
                     lastprofit=OrderProfit();
                     //count++;
                    }
                 }
              }
           }
        } //--end for
      // if(profit_day>riskmoney && count >=2)
      if(lastprofit>riskmoney)
        {
         a=false;
         Print("return false with profit in taget",lastprofit);

        }
     }
   else
     {
      a=false;
      Print("return false with timesleep");
     }
   return a;
  }
//+------------------------------------------------------------------+