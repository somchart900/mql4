//+------------------------------------------------------------------+
//|                                                    .mq4 |
//|                         |
//|                                          |
//+------------------------------------------------------------------+
#property copyright "."
#property link      "https://www.facebook.com/huaylungcafe"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  { 
 ObjectsDeleteAll();
 ChartSetInteger(ChartID(),CHART_SHOW_PERIOD_SEP,0,0);
 ChartSetInteger(ChartID(),CHART_FOREGROUND,0,0);
 ChartSetInteger(ChartID(),CHART_SHOW_GRID,0,0);
 ChartSetInteger(ChartID(),CHART_SHIFT,0,1);
 ChartSetInteger(ChartID(),CHART_AUTOSCROLL,0,1);
 ChartSetInteger(ChartID(),CHART_MODE,CHART_CANDLES,1);
 ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BEAR,clrRed);
 ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BULL,clrLime);
 ChartSetInteger(ChartID(),CHART_COLOR_CHART_DOWN,clrRed);
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

extern double Money=10;
extern double MoneySleep=-10;
int Slippage=10;
input int StartTime=18;
input int Endtime=22;

//-------------------------------------------------------------------------------------------------- 
void  CloseAll(){ 
  bool res;
      for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS);
           if(OrderType()==OP_SELL){
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           }
           if(OrderType()==OP_BUY){
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           } 
      }
}  
//+----------------------



void OnTick(){ 
if(AccountProfit()>Money){CloseAll();}
  if ((TimeHour(TimeCurrent()) >= StartTime) && (TimeHour(TimeCurrent()) <= Endtime)){ 
    if(AccountProfit()>MoneySleep){CloseAll();}
  }
}
//----------------------------------------------------------------------------------------------------------

