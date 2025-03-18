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

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
extern double Lots =0.10;
extern int TP= 150;
int TP_Start= TP;
extern int SL= 0;
double SLSET= SL;
extern double LotsXponent =2;
double Start_Lots =Lots;
extern int MagicNumber =25062020;
extern int Slippage =5;
input string Parbolic = " ----- Parbolic SAR Setting -----";
input ENUM_TIMEFRAMES TIMEFRAME =PERIOD_M5;
extern double Parbolic_Step =0.02;
extern double Parbolic_Maximum =0.2;
input string MovingAverage = " ----- MovingAverage Setting -----";
input ENUM_MA_METHOD MA_MATHOD=MODE_SMA;
input ENUM_APPLIED_PRICE APPLIED_PRICE=PRICE_CLOSE;
input int MA_piriod=60;
input string _ = " ----- Trend control -----";
input ENUM_TIMEFRAMES TIMEFRAME_Trend =PERIOD_H1;
input string Event_Controller = " ----- Setting -----";
input int Allow_Spread=25;
input int distant=50;
input int maxoder=10;

int lastbar;
double max;
double current;
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
void OpenBuy()
  {
   history();
   int ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,DoubleToStr(max,2),MagicNumber,0,clrBlue);
   lastbar=bars;
   TPSL();
  }
//-----------------------------
//-----------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenSell()
  {
   history();
   int ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,DoubleToStr(max,2),MagicNumber,0,clrRed);
   lastbar=bars;
   TPSL();
  }
//-----------------------------
//-----------------------------
int BuyOpen;
int SellOpen;
double distant_buy;
double distant_sell;
double volume;
double SellOpenProfit;
double BuyOpenProfit;
//-----------------------------
void GetStat()
  {
   BuyOpen=0;
   SellOpen=0;
   distant_buy=0;
   distant_sell=0;
   volume=Start_Lots;
   SellOpenProfit=0;
   BuyOpenProfit=0;

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
               BuyOpenProfit+=OrderProfit()+OrderSwap()+OrderCommission();
               distant_buy=OrderOpenPrice()-distant*Point;
               volume=OrderLots();
              }
            if(OrderType()==OP_SELL)
              {
               SellOpen++;
               SellOpenProfit+=OrderProfit()+OrderSwap()+OrderCommission();
               distant_sell=OrderOpenPrice()+distant*Point;
               volume=OrderLots();
              }
           }//-------

        }//--symbol

     }//+end for
// if(BuyOpen>0 || SellOpen >0)
//  {
//   Lots=volume*LotsXponent;
//  }
  }
//-----------------------------
//--------------------------------------------------------------------------------------------------
void  CloseSell()
  {
   bool res;
   for(int i=OrdersTotal()-1; i>=0; i--)
      //  for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()==OP_SELL)
              {
               res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
              }
           }
        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  CloseBuy()
  {
   bool res;
   for(int i=OrdersTotal()-1; i>=0; i--)
      //  for(int i = 0; i < OrdersTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
           {
            if(OrderType()==OP_BUY)
              {
               res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
              }
           }
        }
     }
  }

//-----------------------------------------------------------------------------------------------------
//-----------------------------
double MA;
double SAR0;
double SAR1;
double AO;
int spread;
int bars;
void GetIndy()
  {
   SAR1=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,1);
   SAR0=iSAR(Symbol(),TIMEFRAME,Parbolic_Step,Parbolic_Maximum,0);
   MA=iMA(Symbol(),TIMEFRAME,MA_piriod,0,MA_MATHOD,APPLIED_PRICE,0);
   AO=iAO(Symbol(),TIMEFRAME_Trend,1);
   spread = (int)MarketInfo(Symbol(),MODE_SPREAD);
   bars=iBars(Symbol(),TIMEFRAME);
  }
//--------------------------------------------------------------------------------------------------
void Treding()
  {
   GetIndy();
   GetStat();
   double atr=iATR(Symbol(),PERIOD_M30,14,1);
   double atr1=NormalizeDouble(atr,Digits);
   string atr2=StringSubstr(DoubleToStr(atr,Digits), Digits-1,3);
   TP=StrToInteger(atr2);
   if(TP<distant)
      TP=distant;
   double open1=iOpen(Symbol(),TIMEFRAME,1);
   if(AO > 0)
     {
      CloseSell();
      Comment("FOCUS BUY  \n","BUY OPEN  "+IntegerToString(BuyOpen)+"\nMAX "+DoubleToStr(max,2)+"\nCURENT "+DoubleToStr(current,2)+"\nPROFIT "+DoubleToStr(BuyOpenProfit,2));
      if(BuyOpen==0)
        {
         TP=TP_Start;
         if(SAR1 > open1)
           {
            if(SAR0 < open1)
              {
               if(SAR0 <= MA)
                 {
                  if(spread <= Allow_Spread)
                    {
                     if(lastbar!=bars)
                       {
                        OpenBuy();
                       }
                    }
                 }
              }
           }
        }
      //------------------
      if(BuyOpen>0)
        {
         TP=TP_Start/2;
         if(BuyOpen < maxoder)
           {
            if(Ask < distant_buy)
              {
               if(SAR1 > open1)
                 {
                  if(SAR0 < open1)
                    {
                     if(SAR0 <= MA)
                       {
                        if(lastbar!=bars)
                          {
                           if(spread <= Allow_Spread)
                             {
                              OpenBuy();
                             }
                          }
                       }
                    }
                 }
              }
           }
        }

     }
//----------------------------
   if(AO < 0)
     {
      CloseBuy();
      Comment("FOCUS SELL  \n","SELL OPEN  "+IntegerToString(SellOpen)+"\nMAX "+DoubleToStr(max,2)+"\nCURENT "+DoubleToStr(current,2)+"\nPROFIT "+DoubleToStr(SellOpenProfit,2));
      if(SellOpen==0)
        {
         TP=TP_Start;
         if(SAR1 < open1)
           {
            if(SAR0 > open1)
              {
               if(SAR0 >= MA)
                 {
                  if(lastbar!=bars)
                    {
                     if(spread <= Allow_Spread)
                       {
                        OpenSell();
                       }
                    }
                 }
              }
           }
        }
      //------------------
      if(SellOpen>0)
        {
         TP=TP_Start/2;
         if(SellOpen < maxoder)
           {
            if(Bid > distant_sell)
              {
               if(SAR1 < open1)
                 {
                  if(SAR0 > open1)
                    {
                     if(SAR0 >= MA)
                       {
                        if(lastbar!=bars)
                          {
                           if(spread <= Allow_Spread)
                             {
                              OpenSell();
                             }
                          }
                       }
                    }
                 }
              }
           }
        }

     }//++---end sell
  }//+----------end treading
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
         if(OrderSymbol()==Symbol())
           {
            if(OrderMagicNumber()==MagicNumber)
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
  }

//-----------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------
void history()
  {
   Lots=Start_Lots;
   bool res;
   double profit=0;
   double lots=0;
   max=0;
   current=0;
   for(int i = 0; i < OrdersHistoryTotal(); i++)
     {
      res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
      if(OrderSymbol()==Symbol())
        {
         if(OrderMagicNumber()==MagicNumber)
           {
            lots=OrderLots();
            max=StrToDouble(OrderComment());
            current+=OrderProfit()+OrderSwap()+OrderCommission();
            profit=OrderProfit();
           }
        }
     } //--end for
   if(profit<0)
     {
      if(max>current)
        {
         Lots =lots*LotsXponent;
        }
     }
   if(profit >= 0)
     {
      if(max>current)
        {
         Lots =lots;
        }
     }
   if(current>max)
     {
      max=current;
     }
  }
//-----------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double rf_profit=0;
void OnTick()
  {
   Treding();
   if(rf_profit!=AccountBalance())
     {
      history();
      rf_profit=AccountBalance();
     }
  }
//----------------------------------------------------------------------------------------------------------


//+------------------------------------------------------------------+
