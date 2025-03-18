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
   //ObjectsDeleteAll();
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
ObjectsDeleteAll();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
extern double Lots =0.10;
extern double TP= 150;
extern double SL= 150;
double SLSET= SL;
extern double LotsXponent =2;
double Start_Lots =Lots;
extern int MagicNumber =17122020;
extern int Slippage =5;
input string Parbolic = " ----- Parbolic SAR Setting -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
extern double Parbolic_Step =0.02;
extern double Parbolic_Maximum =0.2;
input ENUM_APPLIED_PRICE Apply_to=PRICE_CLOSE;
input int Fast_EMA=12;
input int Slow_EMA=26;
input int MACD_SMA=9;
input string _ = " ----- Trend control -----";
input ENUM_TIMEFRAMES TIMEFRAME_Trend =PERIOD_M30;
int lastbar;
input int Allow_Spread=20;
extern int StartHour = 6;
extern int EndHour = 23;
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void OpenBuy()
  {
   history();
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,NULL,MagicNumber,0,clrGreen);
   TPSL();
   //lastbar=bars;
  }
//-----------------------------
//-----------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenSell()
  {
   history();
   int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,NULL,MagicNumber,0,clrRed);
   TPSL();
  // lastbar=bars;
  }
//-----------------------------
int BuyOpen;
int SellOpen;
//-----------------------------
void GetStat()
  {
   BuyOpen=0;
   SellOpen=0;
   bool res;
   for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS);
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY)
        {
         BuyOpen++;
        }
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL)
        {
         SellOpen++;
        }
     }//+end for
  }
//-----------------------------
//-----------------------------
double MA,TREND;
double SAR0;
double SAR1;
int spread;
//int bars;
void GetIndy()
  {
   SAR1=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,1);
   SAR0=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,0);
   MA=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,1);
   TREND=iMACD(Symbol(),TIMEFRAME_Trend,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,1);
   spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
  // bars=iBars(Symbol(),TIMEFRAME);
  }
//--------------------------------------------------------------------------------------------------
void Treding()
  {
   GetIndy();
   GetStat();
   double open1=iOpen(Symbol(),TIMEFRAME,1);
   if(TREND > 0)
      { if(working!=false){Comment("FOCUS BUY");}
      if(SAR1 > open1)
        {
         if(SAR0 < open1)
           {
            if(BuyOpen==0 && SellOpen==0)
               {
                  if(working==true)
                     {
                      if(spread<=Allow_Spread)
                        {
                        OpenBuy();
                        }
                     }
               } 
           }
        }
      }
//-------------------
   if(TREND<0)
      {if(working!=false){Comment("FOCUS SELL");}
      if(SAR1 < open1)
        {
         if(SAR0 > open1)
           {
            if(SellOpen==0 && BuyOpen==0)
               {
                  if(working==true)
                     {
                      if(spread<=Allow_Spread)
                        {
                        OpenSell();
                        }
                     }
               } 
           }
        }
      }
//-------------------


  }
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void TPSL()
  {
   double SL_SET;
   double TP_SET;
   bool res;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
           {
            if(OrderType() == OP_BUY)
              {
               if(SL==0)
                 {
                  SL_SET=0;
                 }
               else
                 {
                  SL_SET=OrderOpenPrice()-SL*Point;
                 }
               if(TP==0)
                 {
                  TP_SET=0;
                 }
               else
                 {
                  TP_SET=OrderOpenPrice()+TP*Point;
                 }
               res = OrderModify(OrderTicket(),OrderOpenPrice(),SL_SET,TP_SET,0,0);
              }
            if(OrderType() == OP_SELL)
              {
               if(SL==0)
                 {
                  SL_SET=0;
                 }
               else
                 {
                  SL_SET=OrderOpenPrice()+SL*Point;
                 }
               if(TP==0)
                 {
                  TP_SET=0;
                 }
               else
                 {
                  TP_SET=OrderOpenPrice()-TP*Point;
                 }
               res = OrderModify(OrderTicket(),OrderOpenPrice(),SL_SET,TP_SET,0,0);
              }
           }
        }
     }
  }

//-----------------------------------------------------------------------------------------------------------------------------


//+------------------------------------------------------------------+

//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void history()
  {
   Lots=Start_Lots;
   bool res;
   double profit=0;
   double lots=0;
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
            if(OrderType()==OP_BUY)
              {
               lots=OrderLots();
               profit=OrderProfit();
              }
            if(OrderType()==OP_SELL)
              {
               lots=OrderLots();
               profit=OrderProfit();
              }
        }
     } //--end for
   if(profit<0)
     {
      Lots =NormalizeDouble(lots*LotsXponent,2);
      
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool working;
void OnTick()
  {
   if ((TimeHour(TimeLocal()) >= StartHour) && (TimeHour(TimeLocal()) <= EndHour))
{
working=true;
}else{
         Comment("SleepTime ");
 working=false;        
}
   Treding();
  }
//----------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
