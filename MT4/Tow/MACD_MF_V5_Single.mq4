//+------------------------------------------------------------------+
//|                                                    .mq4 |
//|                         |
//|                                          |
//+------------------------------------------------------------------+
#property copyright "huaylungcafe"
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

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
extern double Lots =0.10;
extern double TP= 155;
extern double SL= 150;

extern double LotsXponent =2;
double Start_Lots =Lots;
extern int MagicNumber =20210331;
extern int Slippage =10;
input string MACD = " -----   Signal_Treding     -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
input ENUM_APPLIED_PRICE Apply_to=PRICE_CLOSE;
input int Fast_EMA=12;
input int Slow_EMA=26;
input int MACD_SMA=9;
input string _ = " ----- Trend control -----";
input ENUM_TIMEFRAMES TIMEFRAME_Trend =PERIOD_H1;
input int Allow_Spread=30;
int lastbar;
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void OpenBuy()
  {
   history();
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,"MACD_MF_V5_Single",MagicNumber,0,clrGreen);
   TPSL();
   lastbar=bars;
  }
//-----------------------------
//-----------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenSell()
  {
   history();
   int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,"MACD_MF_V5_Single",MagicNumber,0,clrRed);
   TPSL(); 
   lastbar=bars;
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
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
            {
             if(OrderType()==OP_BUY)
                {
                  BuyOpen++;
                }
             if(OrderType()==OP_SELL)
                {
                  SellOpen++;
                }
            }// magic     

        }//symbol

     }//+end for

  }
//-----------------------------



//-----------------------------------------------------------------------------------------------------
//-----------------------------
double S1;
double S2;
double M1;
double M2;
double TREND;
int spread;
int bars;

void GetIndy()
  {
   S1=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_SIGNAL,1);
   S2=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_SIGNAL,2);
   M1=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,1);
   M2=iMACD(Symbol(),TIMEFRAME,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,2);
   TREND=iMACD(Symbol(),TIMEFRAME_Trend,Fast_EMA,Slow_EMA,MACD_SMA,Apply_to,MODE_MAIN,1);
   spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   bars=iBars(Symbol(),TIMEFRAME);
  }
//--------------------------------------------------------------------------------------------------
void Treding()
  {
   GetIndy();
   GetStat();
   if(TREND > 0)
     {
     if(BuyOpen==0 && SellOpen==0)
        {
         if(M2<=0 && M1>0)
            {
             if(spread<=Allow_Spread && lastbar!=bars)
                {
                 OpenBuy();    
                }
            }
        } 
     }
//-----------------
   if(TREND < 0)
     {
     if(BuyOpen==0 && SellOpen==0)
        {
         if(M2>=0 && M1<0)
            {
             if(spread<=Allow_Spread && lastbar!=bars)
                {
                 OpenSell();    
                }
            }
        } 
     }
//--------------------------------


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
//-----------------------------



void OnTick()
  {
   Treding();
  }
//----------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
